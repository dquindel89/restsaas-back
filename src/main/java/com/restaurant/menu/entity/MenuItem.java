package com.restaurant.menu.entity;

import lombok.*;
import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Table;

import java.math.BigDecimal;

@Table("menu_items")
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class MenuItem {

    @Id
    private Long id;

    private Long categoryId;
    private String name;
    private String description;
    private BigDecimal price;
    private boolean available;
    private String imageUrl;
    private Integer preparationTime;
}
