package com.restaurant.table.entity;

import lombok.*;
import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Table;

@Table("restaurant_tables")
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class RestaurantTable {

    @Id
    private Long id;

    private Integer number;
    private Integer capacity;
    private String status;   // FREE | OCCUPIED | RESERVED
}
