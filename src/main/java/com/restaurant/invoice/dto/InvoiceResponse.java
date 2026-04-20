package com.restaurant.invoice.dto;

import com.restaurant.invoice.entity.Invoice;
import com.restaurant.order.dto.OrderItemResponse;
import com.restaurant.order.entity.OrderItem;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

public record InvoiceResponse(
        Long id,
        Long orderId,
        Integer tableNumber,
        Long cashierId,
        String paymentMethod,
        BigDecimal total,
        Long waiterId,
        String waiterName,
        List<OrderItemResponse> items,
        LocalDateTime createdAt
) {
    public static InvoiceResponse from(Invoice invoice, List<OrderItem> items) {
        return new InvoiceResponse(
                invoice.getId(),
                invoice.getOrderId(),
                invoice.getTableNumber(),
                invoice.getCashierId(),
                invoice.getPaymentMethod(),
                invoice.getTotal(),
                invoice.getWaiterId(),
                invoice.getWaiterName(),
                items.stream().map(OrderItemResponse::from).toList(),
                invoice.getCreatedAt()
        );
    }
}
