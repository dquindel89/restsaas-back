package com.restaurant.menu.service;

import com.restaurant.common.exception.NotFoundException;
import com.restaurant.menu.dto.CategoryRequest;
import com.restaurant.menu.dto.MenuItemRequest;
import com.restaurant.menu.entity.Category;
import com.restaurant.menu.entity.MenuItem;
import com.restaurant.menu.repository.CategoryRepository;
import com.restaurant.menu.repository.MenuItemRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

@Service
@RequiredArgsConstructor
public class MenuService {

    private final CategoryRepository categoryRepository;
    private final MenuItemRepository menuItemRepository;

    // ── Categorías ──────────────────────────────────────────────────────────

    public Flux<Category> listCategories() {
        return categoryRepository.findByActiveTrueOrderByDisplayOrderAsc();
    }

    public Mono<Category> getCategory(Long id) {
        return categoryRepository.findById(id)
                .switchIfEmpty(Mono.error(new NotFoundException("Categoría no encontrada: " + id)));
    }

    public Mono<Category> createCategory(CategoryRequest request) {
        return categoryRepository.save(Category.builder()
                .name(request.name())
                .description(request.description())
                .displayOrder(request.displayOrder() != null ? request.displayOrder() : 0)
                .active(true)
                .build());
    }

    public Mono<Category> updateCategory(Long id, CategoryRequest request) {
        return getCategory(id)
                .flatMap(cat -> {
                    cat.setName(request.name());
                    cat.setDescription(request.description());
                    if (request.displayOrder() != null) cat.setDisplayOrder(request.displayOrder());
                    return categoryRepository.save(cat);
                });
    }

    public Mono<Void> deleteCategory(Long id) {
        return getCategory(id)
                .flatMap(cat -> {
                    cat.setActive(false);
                    return categoryRepository.save(cat);
                })
                .then();
    }

    // ── Ítems de menú ───────────────────────────────────────────────────────

    public Flux<MenuItem> listItems() {
        return menuItemRepository.findByAvailableTrue();
    }

    public Flux<MenuItem> listItemsByCategory(Long categoryId) {
        return menuItemRepository.findByCategoryIdAndAvailableTrue(categoryId);
    }

    public Mono<MenuItem> getItem(Long id) {
        return menuItemRepository.findById(id)
                .switchIfEmpty(Mono.error(new NotFoundException("Ítem no encontrado: " + id)));
    }

    public Mono<MenuItem> createItem(MenuItemRequest request) {
        return categoryRepository.findById(request.categoryId())
                .switchIfEmpty(Mono.error(new NotFoundException("Categoría no encontrada: " + request.categoryId())))
                .flatMap(cat -> menuItemRepository.save(MenuItem.builder()
                        .categoryId(request.categoryId())
                        .name(request.name())
                        .description(request.description())
                        .price(request.price())
                        .available(true)
                        .imageUrl(request.imageUrl())
                        .preparationTime(request.preparationTime() != null ? request.preparationTime() : 15)
                        .build()));
    }

    public Mono<MenuItem> updateItem(Long id, MenuItemRequest request) {
        return getItem(id)
                .flatMap(item -> {
                    item.setCategoryId(request.categoryId());
                    item.setName(request.name());
                    item.setDescription(request.description());
                    item.setPrice(request.price());
                    item.setImageUrl(request.imageUrl());
                    if (request.preparationTime() != null) item.setPreparationTime(request.preparationTime());
                    return menuItemRepository.save(item);
                });
    }

    public Mono<MenuItem> toggleAvailability(Long id) {
        return getItem(id)
                .flatMap(item -> {
                    item.setAvailable(!item.isAvailable());
                    return menuItemRepository.save(item);
                });
    }

    public Mono<Void> deleteItem(Long id) {
        return getItem(id)
                .flatMap(item -> {
                    item.setAvailable(false);
                    return menuItemRepository.save(item);
                })
                .then();
    }
}
