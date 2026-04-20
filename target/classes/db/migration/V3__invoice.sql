-- ============================================================
-- V3 - Módulo de facturación
-- ============================================================

CREATE TABLE invoices (
    id              BIGSERIAL PRIMARY KEY,
    order_id        BIGINT NOT NULL REFERENCES orders(id),
    table_number    INTEGER NOT NULL,
    cashier_id      BIGINT REFERENCES users(id),
    payment_method  VARCHAR(20) NOT NULL DEFAULT 'CASH',   -- CASH | CARD | TRANSFER
    total           NUMERIC(10,2) NOT NULL,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_invoices_order_id  ON invoices(order_id);
CREATE INDEX idx_invoices_created   ON invoices(created_at);
