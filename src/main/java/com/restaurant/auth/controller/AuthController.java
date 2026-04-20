package com.restaurant.auth.controller;

import com.restaurant.auth.dto.LoginRequest;
import com.restaurant.auth.dto.LoginResponse;
import com.restaurant.auth.dto.RegisterRequest;
import com.restaurant.auth.dto.UpdateUserRequest;
import com.restaurant.auth.entity.User;
import com.restaurant.auth.service.AuthService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

@RestController
@RequestMapping("/api/v1/auth")
@RequiredArgsConstructor
public class AuthController {

    private final AuthService authService;

    @PostMapping("/login")
    public Mono<LoginResponse> login(@Valid @RequestBody LoginRequest request) {
        return authService.login(request);
    }

    @PostMapping("/register")
    @ResponseStatus(HttpStatus.CREATED)
    public Mono<User> register(@Valid @RequestBody RegisterRequest request) {
        return authService.register(request);
    }

    @GetMapping("/users")
    public Flux<User> listUsers() {
        return authService.listUsers();
    }

    @PutMapping("/users/{id}")
    public Mono<User> updateUser(@PathVariable Long id, @Valid @RequestBody UpdateUserRequest request) {
        return authService.updateUser(id, request);
    }

    @PatchMapping("/users/{id}/toggle")
    public Mono<User> toggleStatus(@PathVariable Long id) {
        return authService.toggleUserStatus(id);
    }
}
