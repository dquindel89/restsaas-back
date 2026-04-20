package com.restaurant.invoice.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;

public record CreateInvoiceRequest(
        @NotNull Long orderId,
        Long cashierId,
        @NotBlank @Pattern(regexp = "CASH|CARD|TRANSFER") String paymentMethod
) {}
