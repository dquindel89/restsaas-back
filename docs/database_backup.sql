-- =============================================================================
-- RESTAURANT SAAS - Script completo de base de datos
-- Generado: 2026-04-20  |  Motor: PostgreSQL 15+
-- Incluye: esquema completo + datos semilla de demostracion
-- =============================================================================
-- RESTAURACION:
--   createdb restaurant
--   psql -U postgres -d restaurant -f database_backup.sql
-- =============================================================================

\set ON_ERROR_STOP on

-- ---------------------------------------------------------------------------
-- ESQUEMA
-- ---------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS users (
    id          BIGSERIAL    PRIMARY KEY,
    username    VARCHAR(100) UNIQUE NOT NULL,
    password    VARCHAR(255) NOT NULL,
    full_name   VARCHAR(200),
    role        VARCHAR(50)  NOT NULL DEFAULT 'WAITER',
    active      BOOLEAN      NOT NULL DEFAULT TRUE,
    created_at  TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS categories (
    id              BIGSERIAL    PRIMARY KEY,
    name            VARCHAR(100) NOT NULL,
    description     TEXT,
    display_order   INT          NOT NULL DEFAULT 0,
    active          BOOLEAN      NOT NULL DEFAULT TRUE
);

CREATE TABLE IF NOT EXISTS menu_items (
    id                  BIGSERIAL      PRIMARY KEY,
    category_id         BIGINT         NOT NULL REFERENCES categories(id),
    name                VARCHAR(150)   NOT NULL,
    description         TEXT,
    price               NUMERIC(10,2)  NOT NULL CHECK (price >= 0),
    available           BOOLEAN        NOT NULL DEFAULT TRUE,
    image_url           VARCHAR(500),
    preparation_time    INT            NOT NULL DEFAULT 15
);

CREATE TABLE IF NOT EXISTS restaurant_tables (
    id          BIGSERIAL   PRIMARY KEY,
    number      INT         UNIQUE NOT NULL,
    capacity    INT         NOT NULL DEFAULT 4,
    status      VARCHAR(20) NOT NULL DEFAULT 'FREE'
);

CREATE TABLE IF NOT EXISTS orders (
    id          BIGSERIAL   PRIMARY KEY,
    table_id    BIGINT      REFERENCES restaurant_tables(id),
    waiter_id   BIGINT      REFERENCES users(id),
    status      VARCHAR(30) NOT NULL DEFAULT 'PENDING',
    notes       TEXT,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS order_items (
    id              BIGSERIAL      PRIMARY KEY,
    order_id        BIGINT         NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
    menu_item_id    BIGINT         NOT NULL REFERENCES menu_items(id),
    menu_item_name  VARCHAR(150)   NOT NULL,
    quantity        INT            NOT NULL CHECK (quantity > 0),
    unit_price      NUMERIC(10,2)  NOT NULL,
    status          VARCHAR(30)    NOT NULL DEFAULT 'PENDING',
    notes           TEXT
);

CREATE TABLE IF NOT EXISTS invoices (
    id              BIGSERIAL      PRIMARY KEY,
    order_id        BIGINT         NOT NULL REFERENCES orders(id),
    table_number    INTEGER        NOT NULL,
    cashier_id      BIGINT         REFERENCES users(id),
    payment_method  VARCHAR(20)    NOT NULL DEFAULT 'CASH',
    total           NUMERIC(10,2)  NOT NULL,
    waiter_id       BIGINT         REFERENCES users(id),
    waiter_name     VARCHAR(200),
    created_at      TIMESTAMPTZ    NOT NULL DEFAULT NOW()
);

-- ---------------------------------------------------------------------------
-- INDICES
-- ---------------------------------------------------------------------------

CREATE INDEX IF NOT EXISTS idx_orders_status     ON orders(status);
CREATE INDEX IF NOT EXISTS idx_orders_table_id   ON orders(table_id);
CREATE INDEX IF NOT EXISTS idx_orders_waiter_id  ON orders(waiter_id);
CREATE INDEX IF NOT EXISTS idx_order_items_order ON order_items(order_id);
CREATE INDEX IF NOT EXISTS idx_menu_items_cat    ON menu_items(category_id);
CREATE INDEX IF NOT EXISTS idx_invoices_order_id ON invoices(order_id);
CREATE INDEX IF NOT EXISTS idx_invoices_created  ON invoices(created_at);

-- ---------------------------------------------------------------------------
-- DATOS SEMILLA - CATEGORIAS
-- ---------------------------------------------------------------------------

INSERT INTO categories (name, description, display_order) VALUES
('Entradas',           'Platos de entrada y aperitivos',      1),
('Platos Principales', 'Platos de fondo y especialidades',    2),
('Bebidas',            'Bebidas frias, calientes y cocteles', 3),
('Postres',            'Dulces y postres de temporada',       4)
ON CONFLICT DO NOTHING;

-- ---------------------------------------------------------------------------
-- DATOS SEMILLA - ITEMS DE MENU
-- ---------------------------------------------------------------------------

INSERT INTO menu_items (category_id, name, description, price, preparation_time) VALUES
(1, 'Ceviche Clasico',    'Pescado fresco con leche de tigre, choclo y camote', 25.00, 10),
(1, 'Causa Limena',       'Causa de atun con crema de aji amarillo',            18.00,  8),
(1, 'Tequenos',           'Palitos de queso fritos crujientes (6 unidades)',     15.00,  7),
(2, 'Lomo Saltado',       'Lomo de res salteado con papas fritas y arroz',      38.00, 20),
(2, 'Pollo a la Brasa',   'Pollo al carbon con papas fritas y ensalada',        32.00, 25),
(2, 'Arroz con Mariscos', 'Arroz cremoso con mixtura de mariscos frescos',      42.00, 22),
(2, 'Tallarin Saltado',   'Tallarines con verduras y carne saltada',            30.00, 18),
(3, 'Chicha Morada',      'Bebida tradicional de maiz morado',                   8.00,  2),
(3, 'Limonada Clasica',   'Limonada natural con o sin gas',                      7.00,  2),
(3, 'Agua Mineral',       'Agua con o sin gas (500ml)',                           5.00,  1),
(3, 'Pisco Sour',         'Coctel peruano tradicional',                          18.00,  3),
(4, 'Suspiro Limeno',     'Postre tradicional con manjar y merengue',            12.00,  5),
(4, 'Picarones',          'Picarones con miel de chancaca (4 unidades)',         10.00,  8),
(4, 'Arroz con Leche',    'Arroz con leche cremoso con canela',                   9.00,  5)
ON CONFLICT DO NOTHING;

-- ---------------------------------------------------------------------------
-- DATOS SEMILLA - MESAS
-- ---------------------------------------------------------------------------

INSERT INTO restaurant_tables (number, capacity) VALUES
(1,2),(2,2),(3,4),(4,4),(5,4),(6,4),(7,6),(8,6),(9,8),(10,8)
ON CONFLICT (number) DO NOTHING;

-- ---------------------------------------------------------------------------
-- NOTA SOBRE USUARIOS
-- Los usuarios base son creados por DataInitializer.java al arrancar la app.
-- Credenciales de desarrollo (cambiar en produccion):
--
--   usuario   | password     | rol
--   ----------|--------------|----------
--   admin     | admin123     | ADMIN
--   waiter1   | waiter123    | WAITER
--   kitchen1  | kitchen123   | KITCHEN
--   cajero1   | cajero123    | CASHIER
-- ---------------------------------------------------------------------------

-- =============================================================================
-- FIN DEL SCRIPT
-- =============================================================================
