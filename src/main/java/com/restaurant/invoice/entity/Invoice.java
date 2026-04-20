package com.restaurant.invoice.entity;

import lombok.*;
import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Table;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Table("invoices")
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Invoice {

    @Id
    private Long id;

    private Long orderId;
    private Integer tableNumber;
    private Long cashierId;       // quién procesó el pago
    private String paymentMethod; // CASH | CARD | TRANSFER
    private BigDecimal total;
    private Long waiterId;        // mesero que atendió la mesa
    private String waiterName;    // snapshot del nombre del mesero
    private LocalDateTime createdAt;
}
