package com.restaurant.auth.dto;

import jakarta.validation.constraints.NotBlank;

public record UpdateUserRequest(
        @NotBlank String username,
        @NotBlank String fullName,
        @NotBlank String role,
        String password
) {}
