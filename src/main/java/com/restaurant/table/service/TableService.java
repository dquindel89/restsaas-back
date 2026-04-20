package com.restaurant.table.service;

import com.restaurant.common.exception.BusinessException;
import com.restaurant.common.exception.NotFoundException;
import com.restaurant.table.dto.CreateTableRequest;
import com.restaurant.table.dto.UpdateTableRequest;
import com.restaurant.table.dto.UpdateTableStatusRequest;
import com.restaurant.table.entity.RestaurantTable;
import com.restaurant.table.repository.TableRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

@Service
@RequiredArgsConstructor
public class TableService {

    private final TableRepository tableRepository;

    public Flux<RestaurantTable> listAll() {
        return tableRepository.findAll();
    }

    public Flux<RestaurantTable> listByStatus(String status) {
        return tableRepository.findByStatus(status.toUpperCase());
    }

    public Mono<RestaurantTable> getTable(Long id) {
        return tableRepository.findById(id)
                .switchIfEmpty(Mono.error(new NotFoundException("Mesa no encontrada: " + id)));
    }

    public Mono<RestaurantTable> createTable(CreateTableRequest request) {
        return tableRepository.findByNumber(request.number())
                .flatMap(existing -> Mono.<RestaurantTable>error(
                        new BusinessException("Ya existe una mesa con el número " + request.number())))
                .switchIfEmpty(tableRepository.save(RestaurantTable.builder()
                        .number(request.number())
                        .capacity(request.capacity())
                        .status("FREE")
                        .build()));
    }

    public Mono<RestaurantTable> updateTable(Long id, UpdateTableRequest request) {
        return getTable(id)
                .flatMap(table -> tableRepository.findByNumber(request.number())
                        .filter(existing -> !existing.getId().equals(id))
                        .flatMap(conflict -> Mono.<RestaurantTable>error(
                                new BusinessException("Ya existe una mesa con el número " + request.number())))
                        .switchIfEmpty(Mono.defer(() -> {
                            table.setNumber(request.number());
                            table.setCapacity(request.capacity());
                            return tableRepository.save(table);
                        })));
    }

    public Mono<Void> deleteTable(Long id) {
        return getTable(id)
                .flatMap(table -> {
                    if (!"FREE".equals(table.getStatus())) {
                        return Mono.error(new BusinessException(
                                "Solo se pueden eliminar mesas en estado LIBRE"));
                    }
                    return tableRepository.deleteById(id);
                });
    }

    public Mono<RestaurantTable> updateStatus(Long id, UpdateTableStatusRequest request) {
        return getTable(id)
                .flatMap(table -> {
                    table.setStatus(request.status());
                    return tableRepository.save(table);
                });
    }
}
