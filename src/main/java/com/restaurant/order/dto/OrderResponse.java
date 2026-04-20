package com.restaurant.order.dto;

import com.restaurant.order.entity.Order;
import com.restaurant.order.entity.OrderItem;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

public record OrderResponse(
        Long id,
        Long tableId,
        Long waiterId,
        String status,
        String notes,
        List<OrderItemResponse> items,
        BigDecimal total,
        LocalDateTime createdAt,
        LocalDateTime updatedAt
) {
    public static OrderResponse from(Order order, List<OrderItem> items) {
        List<OrderItemResponse> itemResponses = items.stream()
                .map(OrderItemResponse::from)
                .toList();

        BigDecimal total = itemResponses.stream()
                .map(OrderItemResponse::subtotal)
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        return new OrderResponse(
                order.getId(),
                order.getTableId(),
                order.getWaiterId(),
                order.getStatus(),
                order.getNotes(),
                itemResponses,
                total,
                order.getCreatedAt(),
                order.getUpdatedAt()
        );
    }
}
