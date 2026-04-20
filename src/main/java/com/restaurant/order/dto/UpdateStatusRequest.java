package com.restaurant.order.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;

public record UpdateStatusRequest(
        @NotBlank
        @Pattern(regexp = "PENDING|IN_PROGRESS|READY|DELIVERED|PAID|CANCELLED",
                 message = "status debe ser PENDING, IN_PROGRESS, READY, DELIVERED, PAID o CANCELLED")
        String status
) {}
