package com.restaurant.order.entity;

import lombok.*;
import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Table;

import java.math.BigDecimal;

@Table("order_items")
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class OrderItem {

    @Id
    private Long id;

    private Long orderId;
    private Long menuItemId;
    private String menuItemName;   // snapshot del nombre al momento del pedido
    private Integer quantity;
    private BigDecimal unitPrice;  // snapshot del precio al momento del pedido
    private String status;         // PENDING | IN_PROGRESS | READY | DELIVERED
    private String notes;
}
