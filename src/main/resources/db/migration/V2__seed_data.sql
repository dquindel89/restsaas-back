-- ============================================================
-- V2 - Datos iniciales de demostración
-- Usuarios creados programáticamente por DataInitializer.java
-- ============================================================

-- CATEGORÍAS
INSERT INTO categories (name, description, display_order) VALUES
('Entradas',          'Platos de entrada y aperitivos',      1),
('Platos Principales','Platos de fondo y especialidades',    2),
('Bebidas',           'Bebidas frías, calientes y cocteles', 3),
('Postres',           'Dulces y postres de temporada',       4);

-- ÍTEMS DE MENÚ
INSERT INTO menu_items (category_id, name, description, price, preparation_time) VALUES
-- Entradas
(1, 'Ceviche Clásico',    'Pescado fresco con leche de tigre, choclo y camote', 25.00, 10),
(1, 'Causa Limeña',       'Causa de atún con crema de ají amarillo',            18.00,  8),
(1, 'Tequeños',           'Palitos de queso fritos crujientes (6 unidades)',     15.00,  7),

-- Platos Principales
(2, 'Lomo Saltado',       'Lomo de res salteado con papas fritas y arroz',      38.00, 20),
(2, 'Pollo a la Brasa',   'Pollo al carbón con papas fritas y ensalada',        32.00, 25),
(2, 'Arroz con Mariscos', 'Arroz cremoso con mixtura de mariscos frescos',      42.00, 22),
(2, 'Tallarín Saltado',   'Tallarines con verduras y carne saltada',            30.00, 18),

-- Bebidas
(3, 'Chicha Morada',      'Bebida tradicional de maíz morado',                   8.00,  2),
(3, 'Limonada Clásica',   'Limonada natural con o sin gas',                      7.00,  2),
(3, 'Agua Mineral',       'Agua con o sin gas (500ml)',                           5.00,  1),
(3, 'Pisco Sour',         'Cóctel peruano tradicional',                          18.00,  3),

-- Postres
(4, 'Suspiro Limeño',     'Postre tradicional con manjar y merengue',            12.00,  5),
(4, 'Picarones',          'Picarones con miel de chancaca (4 unidades)',         10.00,  8),
(4, 'Arroz con Leche',    'Arroz con leche cremoso con canela',                   9.00,  5);

-- MESAS
INSERT INTO restaurant_tables (number, capacity) VALUES
(1,  2),
(2,  2),
(3,  4),
(4,  4),
(5,  4),
(6,  4),
(7,  6),
(8,  6),
(9,  8),
(10, 8);
