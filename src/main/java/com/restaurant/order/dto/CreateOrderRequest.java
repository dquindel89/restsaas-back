package com.restaurant.order.dto;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;

import java.util.List;

public record CreateOrderRequest(
        @NotNull Long tableId,
        Long waiterId,
        @NotEmpty @Valid List<OrderItemRequest> items,
        String notes
) {}
