package com.restaurant.invoice.controller;

import com.restaurant.invoice.dto.CreateInvoiceRequest;
import com.restaurant.invoice.dto.InvoiceResponse;
import com.restaurant.invoice.service.InvoiceService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import java.math.BigDecimal;

@RestController
@RequestMapping("/api/v1/invoices")
@RequiredArgsConstructor
public class InvoiceController {

    private final InvoiceService invoiceService;

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public Mono<InvoiceResponse> createInvoice(@Valid @RequestBody CreateInvoiceRequest request) {
        return invoiceService.createInvoice(request);
    }

    @GetMapping("/today")
    public Flux<InvoiceResponse> todayInvoices() {
        return invoiceService.listTodayInvoices();
    }

    @GetMapping("/today/revenue")
    public Mono<BigDecimal> todayRevenue() {
        return invoiceService.getTodayRevenue();
    }

    @GetMapping("/today/waiter/{waiterId}")
    public Flux<InvoiceResponse> todayInvoicesByWaiter(@PathVariable Long waiterId) {
        return invoiceService.listTodayByWaiter(waiterId);
    }

    @GetMapping("/today/waiter/{waiterId}/revenue")
    public Mono<BigDecimal> todayRevenueByWaiter(@PathVariable Long waiterId) {
        return invoiceService.getTodayRevenueByWaiter(waiterId);
    }

    @GetMapping("/{id}")
    public Mono<InvoiceResponse> getInvoice(@PathVariable Long id) {
        return invoiceService.getInvoice(id);
    }
}
