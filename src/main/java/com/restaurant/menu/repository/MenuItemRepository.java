package com.restaurant.menu.repository;

import com.restaurant.menu.entity.MenuItem;
import org.springframework.data.repository.reactive.ReactiveCrudRepository;
import org.springframework.stereotype.Repository;
import reactor.core.publisher.Flux;

@Repository
public interface MenuItemRepository extends ReactiveCrudRepository<MenuItem, Long> {

    Flux<MenuItem> findByCategoryId(Long categoryId);

    Flux<MenuItem> findByAvailableTrue();

    Flux<MenuItem> findByCategoryIdAndAvailableTrue(Long categoryId);
}
