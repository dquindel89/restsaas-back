package com.restaurant.invoice.repository;

import com.restaurant.invoice.entity.Invoice;
import org.springframework.data.r2dbc.repository.Query;
import org.springframework.data.repository.reactive.ReactiveCrudRepository;
import org.springframework.stereotype.Repository;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import java.math.BigDecimal;

@Repository
public interface InvoiceRepository extends ReactiveCrudRepository<Invoice, Long> {

    @Query("SELECT * FROM invoices ORDER BY created_at DESC")
    Flux<Invoice> findAllByOrderByCreatedAtDesc();

    @Query("SELECT * FROM invoices WHERE DATE(created_at) = CURRENT_DATE ORDER BY created_at DESC")
    Flux<Invoice> findTodayInvoices();

    @Query("SELECT COALESCE(SUM(total), 0) FROM invoices WHERE DATE(created_at) = CURRENT_DATE")
    Mono<BigDecimal> sumTodayRevenue();

    @Query("SELECT * FROM invoices WHERE waiter_id = :waiterId AND DATE(created_at) = CURRENT_DATE ORDER BY created_at DESC")
    Flux<Invoice> findTodayByWaiterId(Long waiterId);

    @Query("SELECT COALESCE(SUM(total), 0) FROM invoices WHERE waiter_id = :waiterId AND DATE(created_at) = CURRENT_DATE")
    Mono<BigDecimal> sumTodayRevenueByWaiterId(Long waiterId);
}
