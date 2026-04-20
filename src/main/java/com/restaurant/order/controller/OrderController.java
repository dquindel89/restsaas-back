package com.restaurant.order.controller;

import com.restaurant.order.dto.CreateOrderRequest;
import com.restaurant.order.dto.DashboardStatsResponse;
import com.restaurant.order.dto.OrderResponse;
import com.restaurant.order.dto.UpdateStatusRequest;
import com.restaurant.order.service.OrderService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.codec.ServerSentEvent;
import org.springframework.web.bind.annotation.*;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

@RestController
@RequestMapping("/api/v1/orders")
@RequiredArgsConstructor
public class OrderController {

    private final OrderService orderService;

    /**
     * Crea una nueva comanda.
     * POST /api/v1/orders
     */
    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public Mono<OrderResponse> createOrder(@Valid @RequestBody CreateOrderRequest request) {
        return orderService.createOrder(request);
    }

    /**
     * Consulta una comanda por ID.
     * GET /api/v1/orders/{id}
     */
    @GetMapping("/{id}")
    public Mono<OrderResponse> getOrder(@PathVariable Long id) {
        return orderService.getOrder(id);
    }

    /**
     * Comandas activas (todas las que no están PAID/CANCELLED).
     * GET /api/v1/orders/active
     */
    @GetMapping("/active")
    public Flux<OrderResponse> getActiveOrders() {
        return orderService.getActiveOrders();
    }

    /**
     * Comandas filtradas.
     * GET /api/v1/orders?tableId=3
     * GET /api/v1/orders?waiterId=2
     * GET /api/v1/orders?status=DELIVERED
     */
    @GetMapping
    public Flux<OrderResponse> getOrders(@RequestParam(required = false) Long tableId,
                                          @RequestParam(required = false) Long waiterId,
                                          @RequestParam(required = false) String status) {
        if (tableId  != null) return orderService.getOrdersByTable(tableId);
        if (waiterId != null) return orderService.getOrdersByWaiter(waiterId);
        if (status   != null) return orderService.getOrdersByStatus(status);
        return orderService.getActiveOrders();
    }

    /**
     * Actualiza el estado de una comanda con validación de transición.
     * PATCH /api/v1/orders/{id}/status
     */
    @PatchMapping("/{id}/status")
    public Mono<OrderResponse> updateStatus(@PathVariable Long id,
                                             @Valid @RequestBody UpdateStatusRequest request) {
        return orderService.updateStatus(id, request);
    }

    /**
     * Estadísticas del dashboard.
     * GET /api/v1/orders/stats
     */
    @GetMapping("/stats")
    public Mono<DashboardStatsResponse> getStats() {
        return orderService.getStats();
    }

    /**
     * Comandas de hoy por mesero.
     * GET /api/v1/orders/today/waiter/{waiterId}
     */
    @GetMapping("/today/waiter/{waiterId}")
    public Flux<OrderResponse> getTodayOrdersByWaiter(@PathVariable Long waiterId) {
        return orderService.getTodayOrdersByWaiter(waiterId);
    }

    /**
     * Stream SSE para la pantalla de cocina.
     * GET /api/v1/orders/stream
     */
    @GetMapping(value = "/stream", produces = MediaType.TEXT_EVENT_STREAM_VALUE)
    public Flux<ServerSentEvent<OrderResponse>> streamOrders() {
        return orderService.streamOrders();
    }
}
