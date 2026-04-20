package com.restaurant.auth.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import lombok.*;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Table;

import java.time.LocalDateTime;

@Table("users")
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class User {

    @Id
    private Long id;

    private String username;
    @JsonIgnore
    private String password;
    private String fullName;
    private String role;
    private boolean active;

    @CreatedDate
    private LocalDateTime createdAt;
}
