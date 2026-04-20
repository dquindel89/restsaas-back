package com.restaurant.order.dto;

import java.math.BigDecimal;

public record DashboardStatsResponse(
        long pendingOrders,
        long activeOrders,
        BigDecimal todayRevenue
) {}
