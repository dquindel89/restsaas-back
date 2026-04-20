package com.restaurant.table.repository;

import com.restaurant.table.entity.RestaurantTable;
import org.springframework.data.repository.reactive.ReactiveCrudRepository;
import org.springframework.stereotype.Repository;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

@Repository
public interface TableRepository extends ReactiveCrudRepository<RestaurantTable, Long> {

    Flux<RestaurantTable> findByStatus(String status);

    Mono<RestaurantTable> findByNumber(Integer number);
}
