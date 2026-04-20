package com.restaurant.order.repository;

import com.restaurant.order.entity.Order;
import org.springframework.data.r2dbc.repository.Query;
import org.springframework.data.repository.reactive.ReactiveCrudRepository;
import org.springframework.stereotype.Repository;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

@Repository
public interface OrderRepository extends ReactiveCrudRepository<Order, Long> {

    Flux<Order> findByStatus(String status);

    Flux<Order> findByTableId(Long tableId);

    Flux<Order> findByWaiterId(Long waiterId);

    /** Comandas activas (pendientes de pago/cancelación) ordenadas por antigüedad. */
    @Query("SELECT * FROM orders WHERE status NOT IN ('PAID', 'CANCELLED') ORDER BY created_at ASC")
    Flux<Order> findActiveOrders();

    @Query("SELECT COUNT(*) FROM orders WHERE status = 'PENDING'")
    Mono<Long> countPendingOrders();

    @Query("SELECT COUNT(*) FROM orders WHERE status NOT IN ('PAID', 'CANCELLED')")
    Mono<Long> countActiveOrders();

    @Query("SELECT * FROM orders WHERE waiter_id = :waiterId AND DATE(created_at) = CURRENT_DATE ORDER BY created_at DESC")
    Flux<Order> findTodayByWaiterId(Long waiterId);
}
