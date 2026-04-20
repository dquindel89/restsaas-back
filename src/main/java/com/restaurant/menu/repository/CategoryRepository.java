package com.restaurant.menu.repository;

import com.restaurant.menu.entity.Category;
import org.springframework.data.repository.reactive.ReactiveCrudRepository;
import org.springframework.stereotype.Repository;
import reactor.core.publisher.Flux;

@Repository
public interface CategoryRepository extends ReactiveCrudRepository<Category, Long> {

    Flux<Category> findByActiveTrueOrderByDisplayOrderAsc();
}
