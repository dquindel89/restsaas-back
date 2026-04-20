-- ============================================================
-- V1 - Esquema inicial del sistema de gestión de restaurante
-- ============================================================

-- USUARIOS
CREATE TABLE users (
    id          BIGSERIAL PRIMARY KEY,
    username    VARCHAR(100) UNIQUE NOT NULL,
    password    VARCHAR(255) NOT NULL,
    full_name   VARCHAR(200),
    role        VARCHAR(50)  NOT NULL DEFAULT 'WAITER',  -- ADMIN | WAITER | KITCHEN | CASHIER
    active      BOOLEAN NOT NULL DEFAULT TRUE,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- CATEGORÍAS DE MENÚ
CREATE TABLE categories (
    id              BIGSERIAL PRIMARY KEY,
    name            VARCHAR(100) NOT NULL,
    description     TEXT,
    display_order   INT NOT NULL DEFAULT 0,
    active          BOOLEAN NOT NULL DEFAULT TRUE
);

-- ÍTEMS DE MENÚ
CREATE TABLE menu_items (
    id                  BIGSERIAL PRIMARY KEY,
    category_id         BIGINT NOT NULL REFERENCES categories(id),
    name                VARCHAR(150) NOT NULL,
    description         TEXT,
    price               NUMERIC(10,2) NOT NULL CHECK (price >= 0),
    available           BOOLEAN NOT NULL DEFAULT TRUE,
    image_url           VARCHAR(500),
    preparation_time    INT NOT NULL DEFAULT 15  -- minutos estimados
);

-- MESAS
CREATE TABLE restaurant_tables (
    id          BIGSERIAL PRIMARY KEY,
    number      INT UNIQUE NOT NULL,
    capacity    INT NOT NULL DEFAULT 4,
    status      VARCHAR(20) NOT NULL DEFAULT 'FREE'  -- FREE | OCCUPIED | RESERVED
);

-- COMANDAS
CREATE TABLE orders (
    id          BIGSERIAL PRIMARY KEY,
    table_id    BIGINT REFERENCES restaurant_tables(id),
    waiter_id   BIGINT REFERENCES users(id),
    status      VARCHAR(30) NOT NULL DEFAULT 'PENDING',
    -- PENDING → IN_PROGRESS → READY → DELIVERED → PAID | CANCELLED
    notes       TEXT,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ÍTEMS DE COMANDA
-- unit_price y menu_item_name son snapshots: preservan el valor al momento del pedido
CREATE TABLE order_items (
    id              BIGSERIAL PRIMARY KEY,
    order_id        BIGINT NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
    menu_item_id    BIGINT NOT NULL REFERENCES menu_items(id),
    menu_item_name  VARCHAR(150) NOT NULL,  -- snapshot del nombre
    quantity        INT NOT NULL CHECK (quantity > 0),
    unit_price      NUMERIC(10,2) NOT NULL,  -- snapshot del precio
    status          VARCHAR(30) NOT NULL DEFAULT 'PENDING',
    notes           TEXT
);

-- Índices para las queries más frecuentes
CREATE INDEX idx_orders_status      ON orders(status);
CREATE INDEX idx_orders_table_id    ON orders(table_id);
CREATE INDEX idx_orders_waiter_id   ON orders(waiter_id);
CREATE INDEX idx_order_items_order  ON order_items(order_id);
CREATE INDEX idx_menu_items_cat     ON menu_items(category_id);
