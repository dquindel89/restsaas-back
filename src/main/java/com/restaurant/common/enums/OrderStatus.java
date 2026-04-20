package com.restaurant.common.enums;

public enum OrderStatus {
    PENDING,
    IN_PROGRESS,
    READY,
    DELIVERED,
    PAID,
    CANCELLED;

    public boolean canTransitionTo(OrderStatus next) {
        return switch (this) {
            case PENDING     -> next == IN_PROGRESS || next == CANCELLED;
            case IN_PROGRESS -> next == READY       || next == CANCELLED;
            case READY       -> next == DELIVERED   || next == CANCELLED;
            case DELIVERED   -> next == PAID        || next == CANCELLED;
            default          -> false;
        };
    }
}
