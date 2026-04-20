package com.restaurant.table.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;

public record UpdateTableStatusRequest(
        @NotBlank
        @Pattern(regexp = "FREE|OCCUPIED|RESERVED", message = "status debe ser FREE, OCCUPIED o RESERVED")
        String status
) {}
