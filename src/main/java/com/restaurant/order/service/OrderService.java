package com.restaurant.order.service;

import com.restaurant.common.exception.BusinessException;
import com.restaurant.common.exception.NotFoundException;
import com.restaurant.common.enums.OrderStatus;
import com.restaurant.menu.repository.MenuItemRepository;
import com.restaurant.order.dto.CreateOrderRequest;
import com.restaurant.order.dto.DashboardStatsResponse;
import com.restaurant.order.dto.OrderItemRequest;
import com.restaurant.order.dto.OrderResponse;
import com.restaurant.order.dto.UpdateStatusRequest;
import com.restaurant.order.entity.Order;
import com.restaurant.order.entity.OrderItem;
import com.restaurant.order.repository.OrderItemRepository;
import com.restaurant.order.repository.OrderRepository;
import com.restaurant.table.repository.TableRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.codec.ServerSentEvent;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;
import reactor.core.publisher.Sinks;

import java.time.LocalDateTime;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
public class OrderService {

    private final OrderRepository         orderRepository;
    private final OrderItemRepository     orderItemRepository;
    private final MenuItemRepository      menuItemRepository;
    private final TableRepository         tableRepository;
    private final Sinks.Many<Order>       orderSink;

    // ── Crear comanda ────────────────────────────────────────────────────────

    @Transactional
    public Mono<OrderResponse> createOrder(CreateOrderRequest request) {
        return tableRepository.findById(request.tableId())
                .switchIfEmpty(Mono.error(new NotFoundException("Mesa no encontrada: " + request.tableId())))
                .flatMap(table -> {
                    Order order = Order.builder()
                            .tableId(request.tableId())
                            .waiterId(request.waiterId())
                            .status(OrderStatus.PENDING.name())
                            .notes(request.notes())
                            .createdAt(LocalDateTime.now())
                            .updatedAt(LocalDateTime.now())
                            .build();
                    return orderRepository.save(order);
                })
                .flatMap(order -> saveItems(order, request.items())
                        .collectList()
                        .flatMap(items -> {
                            // Marcar mesa como OCCUPIED
                            return tableRepository.findById(order.getTableId())
                                    .flatMap(t -> {
                                        t.setStatus("OCCUPIED");
                                        return tableRepository.save(t);
                                    })
                                    .thenReturn(OrderResponse.from(order, items));
                        })
                        .doOnSuccess(resp -> orderSink.tryEmitNext(order)));
    }

    // ── Consultar comandas ───────────────────────────────────────────────────

    public Mono<OrderResponse> getOrder(Long orderId) {
        return orderRepository.findById(orderId)
                .switchIfEmpty(Mono.error(new NotFoundException("Comanda no encontrada: " + orderId)))
                .flatMap(this::buildResponse);
    }

    public Flux<OrderResponse> getActiveOrders() {
        return orderRepository.findActiveOrders()
                .flatMap(this::buildResponse);
    }

    public Flux<OrderResponse> getOrdersByTable(Long tableId) {
        return orderRepository.findByTableId(tableId)
                .flatMap(this::buildResponse);
    }

    public Flux<OrderResponse> getOrdersByWaiter(Long waiterId) {
        return orderRepository.findByWaiterId(waiterId)
                .flatMap(this::buildResponse);
    }

    public Flux<OrderResponse> getOrdersByStatus(String status) {
        return orderRepository.findByStatus(status.toUpperCase())
                .flatMap(this::buildResponse);
    }

    public Flux<OrderResponse> getTodayOrdersByWaiter(Long waiterId) {
        return orderRepository.findTodayByWaiterId(waiterId)
                .flatMap(this::buildResponse);
    }

    public Mono<DashboardStatsResponse> getStats() {
        return Mono.zip(
                orderRepository.countPendingOrders().defaultIfEmpty(0L),
                orderRepository.countActiveOrders().defaultIfEmpty(0L)
        ).map(t -> new DashboardStatsResponse(t.getT1(), t.getT2(), java.math.BigDecimal.ZERO));
    }

    // ── Actualizar estado ────────────────────────────────────────────────────

    @Transactional
    public Mono<OrderResponse> updateStatus(Long orderId, UpdateStatusRequest request) {
        return orderRepository.findById(orderId)
                .switchIfEmpty(Mono.error(new NotFoundException("Comanda no encontrada: " + orderId)))
                .flatMap(order -> {
                    OrderStatus current = OrderStatus.valueOf(order.getStatus());
                    OrderStatus next    = OrderStatus.valueOf(request.status());

                    if (!current.canTransitionTo(next)) {
                        return Mono.error(new BusinessException(
                                "Transición inválida: " + current + " → " + next));
                    }

                    order.setStatus(next.name());
                    order.setUpdatedAt(LocalDateTime.now());
                    return orderRepository.save(order);
                })
                .flatMap(order -> {
                    Mono<Void> freeTable = "PAID".equals(order.getStatus())
                            ? tableRepository.findById(order.getTableId())
                                    .flatMap(t -> { t.setStatus("FREE"); return tableRepository.save(t); })
                                    .then()
                            : Mono.empty();
                    return freeTable.then(buildResponse(order)
                            .doOnSuccess(resp -> orderSink.tryEmitNext(order)));
                });
    }

    // ── SSE Stream para cocina ───────────────────────────────────────────────

    /**
     * Emite el estado actual de comandas activas al conectar,
     * luego mantiene el stream abierto con actualizaciones en tiempo real.
     */
    public Flux<ServerSentEvent<OrderResponse>> streamOrders() {
        Flux<ServerSentEvent<OrderResponse>> initialState = getActiveOrders()
                .map(resp -> ServerSentEvent.<OrderResponse>builder()
                        .event("order-update")
                        .data(resp)
                        .build());

        Flux<ServerSentEvent<OrderResponse>> liveEvents = orderSink.asFlux()
                .onBackpressureBuffer(50,
                        dropped -> log.warn("SSE: comanda descartada del stream: {}", dropped.getId()))
                .flatMap(order -> buildResponse(order)
                        .map(resp -> ServerSentEvent.<OrderResponse>builder()
                                .id(String.valueOf(order.getId()))
                                .event("order-update")
                                .data(resp)
                                .build()));

        return Flux.concat(initialState, liveEvents);
    }

    // ── Helpers privados ─────────────────────────────────────────────────────

    private Mono<OrderResponse> buildResponse(Order order) {
        return orderItemRepository.findByOrderId(order.getId())
                .collectList()
                .map(items -> OrderResponse.from(order, items));
    }

    private Flux<OrderItem> saveItems(Order order, List<OrderItemRequest> items) {
        return Flux.fromIterable(items)
                .flatMap(req -> menuItemRepository.findById(req.menuItemId())
                        .switchIfEmpty(Mono.error(
                                new NotFoundException("Ítem de menú no encontrado: " + req.menuItemId())))
                        .flatMap(menuItem -> orderItemRepository.save(
                                OrderItem.builder()
                                        .orderId(order.getId())
                                        .menuItemId(menuItem.getId())
                                        .menuItemName(menuItem.getName())
                                        .quantity(req.quantity())
                                        .unitPrice(menuItem.getPrice())
                                        .status(OrderStatus.PENDING.name())
                                        .notes(req.notes())
                                        .build()
                        )));
    }
}
