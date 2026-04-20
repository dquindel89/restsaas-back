package com.restaurant.config;

import com.restaurant.order.entity.Order;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.r2dbc.config.EnableR2dbcAuditing;
import reactor.core.publisher.Sinks;

@Configuration
@EnableR2dbcAuditing
public class ReactiveConfig {

    /**
     * Hot stream singleton para broadcast de eventos de comandas.
     * Múltiples suscriptores (cocina, meseros, admin) reciben el mismo evento.
     * Buffer de 200 para absorber picos de demanda.
     */
    @Bean
    public Sinks.Many<Order> orderSink() {
        return Sinks.many().multicast().onBackpressureBuffer(200);
    }
}
