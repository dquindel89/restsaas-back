package com.restaurant.table.controller;

import com.restaurant.table.dto.CreateTableRequest;
import com.restaurant.table.dto.UpdateTableRequest;
import com.restaurant.table.dto.UpdateTableStatusRequest;
import com.restaurant.table.entity.RestaurantTable;
import com.restaurant.table.service.TableService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

@RestController
@RequestMapping("/api/v1/tables")
@RequiredArgsConstructor
public class TableController {

    private final TableService tableService;

    @GetMapping
    public Flux<RestaurantTable> listTables(@RequestParam(required = false) String status) {
        return status != null ? tableService.listByStatus(status) : tableService.listAll();
    }

    @GetMapping("/{id}")
    public Mono<RestaurantTable> getTable(@PathVariable Long id) {
        return tableService.getTable(id);
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public Mono<RestaurantTable> createTable(@Valid @RequestBody CreateTableRequest request) {
        return tableService.createTable(request);
    }

    @PutMapping("/{id}")
    public Mono<RestaurantTable> updateTable(@PathVariable Long id,
                                              @Valid @RequestBody UpdateTableRequest request) {
        return tableService.updateTable(id, request);
    }

    @DeleteMapping("/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public Mono<Void> deleteTable(@PathVariable Long id) {
        return tableService.deleteTable(id);
    }

    @PatchMapping("/{id}/status")
    public Mono<RestaurantTable> updateStatus(@PathVariable Long id,
                                               @Valid @RequestBody UpdateTableStatusRequest request) {
        return tableService.updateStatus(id, request);
    }
}
