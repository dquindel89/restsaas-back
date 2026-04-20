package com.restaurant.table.dto;

import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;

public record UpdateTableRequest(
        @NotNull @Min(1) Integer number,
        @NotNull @Min(1) @Max(30) Integer capacity
) {}
