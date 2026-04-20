package com.restaurant.menu.controller;

import com.restaurant.menu.dto.CategoryRequest;
import com.restaurant.menu.dto.MenuItemRequest;
import com.restaurant.menu.entity.Category;
import com.restaurant.menu.entity.MenuItem;
import com.restaurant.menu.service.MenuService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

@RestController
@RequestMapping("/api/v1/menu")
@RequiredArgsConstructor
public class MenuController {

    private final MenuService menuService;

    // ── Categorías ──────────────────────────────────────────────────────────

    @GetMapping("/categories")
    public Flux<Category> listCategories() {
        return menuService.listCategories();
    }

    @GetMapping("/categories/{id}")
    public Mono<Category> getCategory(@PathVariable Long id) {
        return menuService.getCategory(id);
    }

    @PostMapping("/categories")
    @ResponseStatus(HttpStatus.CREATED)
    public Mono<Category> createCategory(@Valid @RequestBody CategoryRequest request) {
        return menuService.createCategory(request);
    }

    @PutMapping("/categories/{id}")
    public Mono<Category> updateCategory(@PathVariable Long id,
                                          @Valid @RequestBody CategoryRequest request) {
        return menuService.updateCategory(id, request);
    }

    @DeleteMapping("/categories/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public Mono<Void> deleteCategory(@PathVariable Long id) {
        return menuService.deleteCategory(id);
    }

    // ── Ítems ────────────────────────────────────────────────────────────────

    @GetMapping("/items")
    public Flux<MenuItem> listItems(@RequestParam(required = false) Long categoryId) {
        if (categoryId != null) {
            return menuService.listItemsByCategory(categoryId);
        }
        return menuService.listItems();
    }

    @GetMapping("/items/{id}")
    public Mono<MenuItem> getItem(@PathVariable Long id) {
        return menuService.getItem(id);
    }

    @PostMapping("/items")
    @ResponseStatus(HttpStatus.CREATED)
    public Mono<MenuItem> createItem(@Valid @RequestBody MenuItemRequest request) {
        return menuService.createItem(request);
    }

    @PutMapping("/items/{id}")
    public Mono<MenuItem> updateItem(@PathVariable Long id,
                                      @Valid @RequestBody MenuItemRequest request) {
        return menuService.updateItem(id, request);
    }

    @PatchMapping("/items/{id}/availability")
    public Mono<MenuItem> toggleAvailability(@PathVariable Long id) {
        return menuService.toggleAvailability(id);
    }

    @DeleteMapping("/items/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public Mono<Void> deleteItem(@PathVariable Long id) {
        return menuService.deleteItem(id);
    }
}
