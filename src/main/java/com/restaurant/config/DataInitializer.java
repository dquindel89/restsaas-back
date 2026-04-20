package com.restaurant.config;

import com.restaurant.auth.entity.User;
import com.restaurant.auth.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;
import reactor.core.publisher.Mono;

@Slf4j
@Component
@RequiredArgsConstructor
public class DataInitializer implements ApplicationRunner {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    @Override
    public void run(ApplicationArguments args) {
        createUserIfAbsent("admin",    "admin123",   "Administrador",  "ADMIN")
                .then(createUserIfAbsent("waiter1",  "waiter123",  "Juan Mesero",    "WAITER"))
                .then(createUserIfAbsent("kitchen1", "kitchen123", "Carlos Cocinero","KITCHEN"))
                .then(createUserIfAbsent("cajero1",  "cajero123",  "María Cajera",   "CASHIER"))
                .block();
        log.info("DataInitializer: usuarios base verificados.");
    }

    private Mono<User> createUserIfAbsent(String username, String password,
                                           String fullName, String role) {
        return userRepository.findByUsername(username)
                .switchIfEmpty(userRepository.save(User.builder()
                        .username(username)
                        .password(passwordEncoder.encode(password))
                        .fullName(fullName)
                        .role(role)
                        .active(true)
                        .build())
                        .doOnSuccess(u -> log.info("Usuario creado: {} [{}]", u.getUsername(), u.getRole())));
    }
}
