-- V4 - Agregar datos del mesero a la factura
ALTER TABLE invoices ADD COLUMN waiter_id   BIGINT REFERENCES users(id);
ALTER TABLE invoices ADD COLUMN waiter_name VARCHAR(200);
