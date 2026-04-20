package com.restaurant.order.entity;

import lombok.*;
import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Table;

import java.time.LocalDateTime;

@Table("orders")
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Order {

    @Id
    private Long id;

    private Long tableId;
    private Long waiterId;
    private String status;     // PENDING | IN_PROGRESS | READY | DELIVERED | PAID | CANCELLED
    private String notes;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
