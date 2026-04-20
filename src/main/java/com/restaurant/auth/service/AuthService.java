package com.restaurant.auth.service;

import com.restaurant.auth.dto.LoginRequest;
import com.restaurant.auth.dto.LoginResponse;
import com.restaurant.auth.dto.RegisterRequest;
import com.restaurant.auth.dto.UpdateUserRequest;
import com.restaurant.auth.entity.User;
import com.restaurant.auth.repository.UserRepository;
import com.restaurant.auth.security.JwtUtil;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

@Service
@RequiredArgsConstructor
public class AuthService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtUtil jwtUtil;

    public Mono<LoginResponse> login(LoginRequest request) {
        return userRepository.findByUsername(request.username())
                .filter(User::isActive)
                .filter(user -> passwordEncoder.matches(request.password(), user.getPassword()))
                .map(user -> new LoginResponse(
                        jwtUtil.generateToken(user),
                        user.getUsername(),
                        user.getFullName(),
                        user.getRole(),
                        user.getId()
                ))
                .switchIfEmpty(Mono.error(new ResponseStatusException(
                        HttpStatus.UNAUTHORIZED, "Credenciales inválidas")));
    }

    public Mono<User> register(RegisterRequest request) {
        return userRepository.existsByUsername(request.username())
                .flatMap(exists -> {
                    if (exists) {
                        return Mono.error(new ResponseStatusException(
                                HttpStatus.CONFLICT, "El usuario ya existe"));
                    }
                    String role = (request.role() != null && !request.role().isBlank())
                            ? request.role().toUpperCase()
                            : "WAITER";
                    return userRepository.save(User.builder()
                            .username(request.username())
                            .password(passwordEncoder.encode(request.password()))
                            .fullName(request.fullName())
                            .role(role)
                            .active(true)
                            .build());
                });
    }

    public Flux<User> listUsers() {
        return userRepository.findAll();
    }

    public Mono<User> updateUser(Long userId, UpdateUserRequest request) {
        return userRepository.findById(userId)
                .switchIfEmpty(Mono.error(new ResponseStatusException(HttpStatus.NOT_FOUND, "Usuario no encontrado")))
                .flatMap(user -> {
                    String newUsername = request.username().trim().toLowerCase();
                    boolean usernameChanged = !newUsername.equals(user.getUsername());

                    Mono<Void> usernameCheck = usernameChanged
                            ? userRepository.findByUsername(newUsername)
                                    .flatMap(existing -> Mono.<Void>error(
                                            new ResponseStatusException(HttpStatus.CONFLICT, "El nombre de usuario ya está en uso")))
                                    .then()
                            : Mono.empty();

                    return usernameCheck.then(Mono.defer(() -> {
                        if (usernameChanged) user.setUsername(newUsername);
                        user.setFullName(request.fullName());
                        user.setRole(request.role().toUpperCase());
                        if (request.password() != null && !request.password().isBlank()) {
                            user.setPassword(passwordEncoder.encode(request.password()));
                        }
                        return userRepository.save(user);
                    }));
                });
    }

    public Mono<User> toggleUserStatus(Long userId) {
        return userRepository.findById(userId)
                .switchIfEmpty(Mono.error(new ResponseStatusException(HttpStatus.NOT_FOUND, "Usuario no encontrado")))
                .flatMap(user -> {
                    user.setActive(!user.isActive());
                    return userRepository.save(user);
                });
    }
}
