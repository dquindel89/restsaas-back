package com.restaurant.invoice.service;

import com.restaurant.auth.repository.UserRepository;
import com.restaurant.common.exception.BusinessException;
import com.restaurant.common.exception.NotFoundException;
import com.restaurant.invoice.dto.CreateInvoiceRequest;
import com.restaurant.invoice.dto.InvoiceResponse;
import com.restaurant.invoice.entity.Invoice;
import com.restaurant.invoice.repository.InvoiceRepository;
import com.restaurant.order.entity.Order;
import com.restaurant.order.entity.OrderItem;
import com.restaurant.order.repository.OrderItemRepository;
import com.restaurant.order.repository.OrderRepository;
import com.restaurant.table.repository.TableRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;
import reactor.core.publisher.Sinks;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@Service
@RequiredArgsConstructor
public class InvoiceService {

    private final InvoiceRepository   invoiceRepository;
    private final OrderRepository     orderRepository;
    private final OrderItemRepository orderItemRepository;
    private final TableRepository     tableRepository;
    private final UserRepository      userRepository;
    private final Sinks.Many<Order>   orderSink;

    @Transactional
    public Mono<InvoiceResponse> createInvoice(CreateInvoiceRequest req) {
        return orderRepository.findById(req.orderId())
                .switchIfEmpty(Mono.error(new NotFoundException("Comanda no encontrada: " + req.orderId())))
                .filter(o -> "DELIVERED".equals(o.getStatus()))
                .switchIfEmpty(Mono.error(new BusinessException("La comanda debe estar ENTREGADA para cobrar")))
                .flatMap(order -> {
                    order.setStatus("PAID");
                    order.setUpdatedAt(LocalDateTime.now());
                    return orderRepository.save(order);
                })
                .flatMap(savedOrder ->
                        Mono.zip(
                                tableRepository.findById(savedOrder.getTableId())
                                        .switchIfEmpty(Mono.error(new NotFoundException("Mesa no encontrada"))),
                                orderItemRepository.findByOrderId(savedOrder.getId()).collectList(),
                                // Cargar nombre del mesero (fallback si no existe)
                                savedOrder.getWaiterId() != null
                                        ? userRepository.findById(savedOrder.getWaiterId()).map(u -> u.getFullName()).defaultIfEmpty("—")
                                        : Mono.just("—")
                        )
                        .flatMap(tuple -> {
                            var table     = tuple.getT1();
                            var items     = tuple.getT2();
                            var waiterName = tuple.getT3();

                            BigDecimal total  = computeTotal(items);
                            int tableNum      = table.getNumber();

                            table.setStatus("FREE");
                            return tableRepository.save(table)
                                    .then(invoiceRepository.save(Invoice.builder()
                                            .orderId(savedOrder.getId())
                                            .tableNumber(tableNum)
                                            .cashierId(req.cashierId())
                                            .paymentMethod(req.paymentMethod())
                                            .total(total)
                                            .waiterId(savedOrder.getWaiterId())
                                            .waiterName(waiterName)
                                            .createdAt(LocalDateTime.now())
                                            .build()))
                                    .map(invoice -> InvoiceResponse.from(invoice, items))
                                    .doOnSuccess(r -> orderSink.tryEmitNext(savedOrder));
                        })
                );
    }

    public Flux<InvoiceResponse> listTodayInvoices() {
        return invoiceRepository.findTodayInvoices()
                .flatMap(invoice -> orderItemRepository.findByOrderId(invoice.getOrderId())
                        .collectList()
                        .map(items -> InvoiceResponse.from(invoice, items)));
    }

    public Mono<InvoiceResponse> getInvoice(Long id) {
        return invoiceRepository.findById(id)
                .switchIfEmpty(Mono.error(new NotFoundException("Factura no encontrada: " + id)))
                .flatMap(invoice -> orderItemRepository.findByOrderId(invoice.getOrderId())
                        .collectList()
                        .map(items -> InvoiceResponse.from(invoice, items)));
    }

    public Mono<BigDecimal> getTodayRevenue() {
        return invoiceRepository.sumTodayRevenue().defaultIfEmpty(BigDecimal.ZERO);
    }

    public Flux<InvoiceResponse> listTodayByWaiter(Long waiterId) {
        return invoiceRepository.findTodayByWaiterId(waiterId)
                .flatMap(invoice -> orderItemRepository.findByOrderId(invoice.getOrderId())
                        .collectList()
                        .map(items -> InvoiceResponse.from(invoice, items)));
    }

    public Mono<BigDecimal> getTodayRevenueByWaiter(Long waiterId) {
        return invoiceRepository.sumTodayRevenueByWaiterId(waiterId).defaultIfEmpty(BigDecimal.ZERO);
    }

    private BigDecimal computeTotal(List<OrderItem> items) {
        return items.stream()
                .map(i -> i.getUnitPrice().multiply(BigDecimal.valueOf(i.getQuantity())))
                .reduce(BigDecimal.ZERO, BigDecimal::add);
    }
}
