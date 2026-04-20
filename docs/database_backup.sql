--
-- PostgreSQL database dump
--

\restrict acvYfcfiZmZuQ5I29ifffowwVtutjROGopeKRDfjaKx6ytCvl6IJtKBoy9eTv8C

-- Dumped from database version 18.1
-- Dumped by pg_dump version 18.1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.categories (
    id bigint NOT NULL,
    name character varying(100) NOT NULL,
    description text,
    display_order integer DEFAULT 0 NOT NULL,
    active boolean DEFAULT true NOT NULL
);


--
-- Name: categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.categories_id_seq OWNED BY public.categories.id;


--
-- Name: flyway_schema_history; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.flyway_schema_history (
    installed_rank integer NOT NULL,
    version character varying(50),
    description character varying(200) NOT NULL,
    type character varying(20) NOT NULL,
    script character varying(1000) NOT NULL,
    checksum integer,
    installed_by character varying(100) NOT NULL,
    installed_on timestamp without time zone DEFAULT now() NOT NULL,
    execution_time integer NOT NULL,
    success boolean NOT NULL
);


--
-- Name: invoices; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.invoices (
    id bigint NOT NULL,
    order_id bigint NOT NULL,
    table_number integer NOT NULL,
    cashier_id bigint,
    payment_method character varying(20) DEFAULT 'CASH'::character varying NOT NULL,
    total numeric(10,2) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    waiter_id bigint,
    waiter_name character varying(200)
);


--
-- Name: invoices_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.invoices_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: invoices_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.invoices_id_seq OWNED BY public.invoices.id;


--
-- Name: menu_items; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.menu_items (
    id bigint NOT NULL,
    category_id bigint NOT NULL,
    name character varying(150) NOT NULL,
    description text,
    price numeric(10,2) NOT NULL,
    available boolean DEFAULT true NOT NULL,
    image_url character varying(500),
    preparation_time integer DEFAULT 15 NOT NULL,
    CONSTRAINT menu_items_price_check CHECK ((price >= (0)::numeric))
);


--
-- Name: menu_items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.menu_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: menu_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.menu_items_id_seq OWNED BY public.menu_items.id;


--
-- Name: order_items; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.order_items (
    id bigint NOT NULL,
    order_id bigint NOT NULL,
    menu_item_id bigint NOT NULL,
    menu_item_name character varying(150) NOT NULL,
    quantity integer NOT NULL,
    unit_price numeric(10,2) NOT NULL,
    status character varying(30) DEFAULT 'PENDING'::character varying NOT NULL,
    notes text,
    CONSTRAINT order_items_quantity_check CHECK ((quantity > 0))
);


--
-- Name: order_items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.order_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: order_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.order_items_id_seq OWNED BY public.order_items.id;


--
-- Name: orders; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.orders (
    id bigint NOT NULL,
    table_id bigint,
    waiter_id bigint,
    status character varying(30) DEFAULT 'PENDING'::character varying NOT NULL,
    notes text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: orders_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.orders_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: orders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.orders_id_seq OWNED BY public.orders.id;


--
-- Name: restaurant_tables; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.restaurant_tables (
    id bigint NOT NULL,
    number integer NOT NULL,
    capacity integer DEFAULT 4 NOT NULL,
    status character varying(20) DEFAULT 'FREE'::character varying NOT NULL
);


--
-- Name: restaurant_tables_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.restaurant_tables_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: restaurant_tables_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.restaurant_tables_id_seq OWNED BY public.restaurant_tables.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    username character varying(100) NOT NULL,
    password character varying(255) NOT NULL,
    full_name character varying(200),
    role character varying(50) DEFAULT 'WAITER'::character varying NOT NULL,
    active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: categories id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categories ALTER COLUMN id SET DEFAULT nextval('public.categories_id_seq'::regclass);


--
-- Name: invoices id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invoices ALTER COLUMN id SET DEFAULT nextval('public.invoices_id_seq'::regclass);


--
-- Name: menu_items id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.menu_items ALTER COLUMN id SET DEFAULT nextval('public.menu_items_id_seq'::regclass);


--
-- Name: order_items id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_items ALTER COLUMN id SET DEFAULT nextval('public.order_items_id_seq'::regclass);


--
-- Name: orders id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.orders ALTER COLUMN id SET DEFAULT nextval('public.orders_id_seq'::regclass);


--
-- Name: restaurant_tables id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.restaurant_tables ALTER COLUMN id SET DEFAULT nextval('public.restaurant_tables_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: categories; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.categories VALUES (1, 'Entradas', 'Platos de entrada y aperitivos', 1, true);
INSERT INTO public.categories VALUES (2, 'Platos Principales', 'Platos de fondo y especialidades', 2, true);
INSERT INTO public.categories VALUES (3, 'Bebidas', 'Bebidas frías, calientes y cocteles', 3, true);
INSERT INTO public.categories VALUES (4, 'Postres', 'Dulces y postres de temporada', 4, true);


--
-- Data for Name: flyway_schema_history; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.flyway_schema_history VALUES (1, '1', 'init schema', 'SQL', 'V1__init_schema.sql', 1836541707, 'restaurant_user', '2026-04-17 17:37:00.988555', 31, true);
INSERT INTO public.flyway_schema_history VALUES (2, '2', 'seed data', 'SQL', 'V2__seed_data.sql', 775852790, 'restaurant_user', '2026-04-17 17:37:01.03594', 3, true);
INSERT INTO public.flyway_schema_history VALUES (3, '3', 'invoice', 'SQL', 'V3__invoice.sql', -872841771, 'restaurant_user', '2026-04-18 01:50:32.111355', 204, true);
INSERT INTO public.flyway_schema_history VALUES (4, '4', 'invoice waiter', 'SQL', 'V4__invoice_waiter.sql', 431499651, 'restaurant_user', '2026-04-18 02:43:03.607352', 14, true);


--
-- Data for Name: invoices; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.invoices VALUES (1, 5, 2, 4, 'CASH', 38.00, '2026-04-18 01:57:41.959606-05', NULL, NULL);
INSERT INTO public.invoices VALUES (2, 8, 3, 2, 'CARD', 18.00, '2026-04-18 02:48:16.637956-05', 2, 'Juan Mesero');
INSERT INTO public.invoices VALUES (3, 10, 7, 1, 'CASH', 40.00, '2026-04-18 03:00:03.325749-05', 2, 'Juan Mesero');
INSERT INTO public.invoices VALUES (4, 11, 9, 1, 'TRANSFER', 52.00, '2026-04-18 03:01:35.871616-05', 2, 'Juan Mesero');
INSERT INTO public.invoices VALUES (5, 12, 1, 1, 'CARD', 30.00, '2026-04-18 13:49:24.909564-05', 2, 'Juan Mesero');
INSERT INTO public.invoices VALUES (6, 15, 3, 1, 'CASH', 25.00, '2026-04-19 12:31:57.435599-05', 1, 'Administrador');
INSERT INTO public.invoices VALUES (7, 16, 6, 4, 'CARD', 26.00, '2026-04-19 12:55:36.797487-05', 1, 'Administrador');
INSERT INTO public.invoices VALUES (8, 17, 1, 4, 'TRANSFER', 58.00, '2026-04-19 13:16:00.845981-05', 5, 'Daniel Quinde');
INSERT INTO public.invoices VALUES (9, 18, 6, 4, 'CARD', 39.00, '2026-04-19 13:16:01.851479-05', 2, 'Javier Urbina');
INSERT INTO public.invoices VALUES (10, 20, 1, 4, 'CASH', 10.00, '2026-04-19 14:04:33.674779-05', 2, 'Javier Urbina');
INSERT INTO public.invoices VALUES (11, 19, 6, 4, 'TRANSFER', 35.00, '2026-04-19 14:04:49.830752-05', 5, 'Daniel Quinde');
INSERT INTO public.invoices VALUES (12, 21, 6, 4, 'TRANSFER', 23.00, '2026-04-19 15:37:02.373224-05', 5, 'Daniel Quinde');
INSERT INTO public.invoices VALUES (13, 22, 8, 4, 'CARD', 32.00, '2026-04-19 17:50:27.404805-05', 2, 'Javier Urbina');
INSERT INTO public.invoices VALUES (14, 23, 2, 4, 'CARD', 32.00, '2026-04-20 00:38:55.380881-05', 2, 'Javier Urbina');
INSERT INTO public.invoices VALUES (15, 24, 10, 4, 'CASH', 50.00, '2026-04-20 00:40:13.573755-05', 5, 'Daniel Quinde');


--
-- Data for Name: menu_items; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.menu_items VALUES (1, 1, 'Ceviche Clásico', 'Pescado fresco con leche de tigre, choclo y camote', 25.00, true, NULL, 10);
INSERT INTO public.menu_items VALUES (2, 1, 'Causa Limeña', 'Causa de atún con crema de ají amarillo', 18.00, true, NULL, 8);
INSERT INTO public.menu_items VALUES (3, 1, 'Tequeños', 'Palitos de queso fritos crujientes (6 unidades)', 15.00, true, NULL, 7);
INSERT INTO public.menu_items VALUES (4, 2, 'Lomo Saltado', 'Lomo de res salteado con papas fritas y arroz', 38.00, true, NULL, 20);
INSERT INTO public.menu_items VALUES (5, 2, 'Pollo a la Brasa', 'Pollo al carbón con papas fritas y ensalada', 32.00, true, NULL, 25);
INSERT INTO public.menu_items VALUES (6, 2, 'Arroz con Mariscos', 'Arroz cremoso con mixtura de mariscos frescos', 42.00, true, NULL, 22);
INSERT INTO public.menu_items VALUES (7, 2, 'Tallarín Saltado', 'Tallarines con verduras y carne saltada', 30.00, true, NULL, 18);
INSERT INTO public.menu_items VALUES (8, 3, 'Chicha Morada', 'Bebida tradicional de maíz morado', 8.00, true, NULL, 2);
INSERT INTO public.menu_items VALUES (9, 3, 'Limonada Clásica', 'Limonada natural con o sin gas', 7.00, true, NULL, 2);
INSERT INTO public.menu_items VALUES (10, 3, 'Agua Mineral', 'Agua con o sin gas (500ml)', 5.00, true, NULL, 1);
INSERT INTO public.menu_items VALUES (11, 3, 'Pisco Sour', 'Cóctel peruano tradicional', 18.00, true, NULL, 3);
INSERT INTO public.menu_items VALUES (12, 4, 'Suspiro Limeño', 'Postre tradicional con manjar y merengue', 12.00, true, NULL, 5);
INSERT INTO public.menu_items VALUES (13, 4, 'Picarones', 'Picarones con miel de chancaca (4 unidades)', 10.00, true, NULL, 8);
INSERT INTO public.menu_items VALUES (14, 4, 'Arroz con Leche', 'Arroz con leche cremoso con canela', 9.00, true, NULL, 5);
INSERT INTO public.menu_items VALUES (15, 2, 'Arroz con pollo', '', 30.00, true, NULL, 15);


--
-- Data for Name: order_items; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.order_items VALUES (1, 1, 1, 'Ceviche Clásico', 1, 25.00, 'PENDING', NULL);
INSERT INTO public.order_items VALUES (2, 1, 10, 'Agua Mineral', 1, 5.00, 'PENDING', NULL);
INSERT INTO public.order_items VALUES (3, 2, 1, 'Ceviche Clásico', 1, 25.00, 'PENDING', NULL);
INSERT INTO public.order_items VALUES (4, 2, 8, 'Chicha Morada', 1, 8.00, 'PENDING', NULL);
INSERT INTO public.order_items VALUES (5, 3, 1, 'Ceviche Clásico', 2, 25.00, 'PENDING', '');
INSERT INTO public.order_items VALUES (6, 3, 5, 'Pollo a la Brasa', 1, 32.00, 'PENDING', 'extra salsa');
INSERT INTO public.order_items VALUES (7, 4, 2, 'Causa Limeña', 1, 18.00, 'PENDING', NULL);
INSERT INTO public.order_items VALUES (8, 4, 10, 'Agua Mineral', 1, 5.00, 'PENDING', NULL);
INSERT INTO public.order_items VALUES (9, 5, 3, 'Tequeños', 2, 15.00, 'PENDING', NULL);
INSERT INTO public.order_items VALUES (10, 5, 8, 'Chicha Morada', 1, 8.00, 'PENDING', NULL);
INSERT INTO public.order_items VALUES (11, 6, 15, 'Arroz con pollo', 1, 30.00, 'PENDING', NULL);
INSERT INTO public.order_items VALUES (12, 6, 9, 'Limonada Clásica', 1, 7.00, 'PENDING', NULL);
INSERT INTO public.order_items VALUES (13, 7, 1, 'Ceviche Clásico', 1, 25.00, 'PENDING', NULL);
INSERT INTO public.order_items VALUES (14, 7, 8, 'Chicha Morada', 1, 8.00, 'PENDING', NULL);
INSERT INTO public.order_items VALUES (15, 8, 2, 'Causa Limeña', 1, 18.00, 'PENDING', NULL);
INSERT INTO public.order_items VALUES (16, 9, 7, 'Tallarín Saltado', 1, 30.00, 'PENDING', NULL);
INSERT INTO public.order_items VALUES (17, 9, 10, 'Agua Mineral', 1, 5.00, 'PENDING', NULL);
INSERT INTO public.order_items VALUES (18, 10, 2, 'Causa Limeña', 1, 18.00, 'PENDING', NULL);
INSERT INTO public.order_items VALUES (19, 10, 3, 'Tequeños', 1, 15.00, 'PENDING', NULL);
INSERT INTO public.order_items VALUES (20, 10, 9, 'Limonada Clásica', 1, 7.00, 'PENDING', NULL);
INSERT INTO public.order_items VALUES (21, 11, 13, 'Picarones', 1, 10.00, 'PENDING', NULL);
INSERT INTO public.order_items VALUES (22, 11, 6, 'Arroz con Mariscos', 1, 42.00, 'PENDING', NULL);
INSERT INTO public.order_items VALUES (23, 12, 11, 'Pisco Sour', 1, 18.00, 'PENDING', NULL);
INSERT INTO public.order_items VALUES (24, 12, 12, 'Suspiro Limeño', 1, 12.00, 'PENDING', NULL);
INSERT INTO public.order_items VALUES (25, 13, 3, 'Tequeños', 1, 15.00, 'PENDING', NULL);
INSERT INTO public.order_items VALUES (26, 13, 10, 'Agua Mineral', 1, 5.00, 'PENDING', NULL);
INSERT INTO public.order_items VALUES (27, 14, 1, 'Ceviche Clásico', 1, 25.00, 'PENDING', NULL);
INSERT INTO public.order_items VALUES (28, 14, 2, 'Causa Limeña', 1, 18.00, 'PENDING', NULL);
INSERT INTO public.order_items VALUES (29, 15, 2, 'Causa Limeña', 1, 18.00, 'PENDING', NULL);
INSERT INTO public.order_items VALUES (30, 15, 9, 'Limonada Clásica', 1, 7.00, 'PENDING', NULL);
INSERT INTO public.order_items VALUES (31, 16, 2, 'Causa Limeña', 1, 18.00, 'PENDING', NULL);
INSERT INTO public.order_items VALUES (32, 16, 8, 'Chicha Morada', 1, 8.00, 'PENDING', NULL);
INSERT INTO public.order_items VALUES (33, 17, 11, 'Pisco Sour', 1, 18.00, 'PENDING', NULL);
INSERT INTO public.order_items VALUES (34, 17, 7, 'Tallarín Saltado', 1, 30.00, 'PENDING', NULL);
INSERT INTO public.order_items VALUES (35, 17, 13, 'Picarones', 1, 10.00, 'PENDING', NULL);
INSERT INTO public.order_items VALUES (36, 18, 15, 'Arroz con pollo', 1, 30.00, 'PENDING', NULL);
INSERT INTO public.order_items VALUES (37, 18, 14, 'Arroz con Leche', 1, 9.00, 'PENDING', NULL);
INSERT INTO public.order_items VALUES (38, 19, 2, 'Causa Limeña', 1, 18.00, 'PENDING', NULL);
INSERT INTO public.order_items VALUES (39, 19, 10, 'Agua Mineral', 2, 5.00, 'PENDING', NULL);
INSERT INTO public.order_items VALUES (40, 19, 9, 'Limonada Clásica', 1, 7.00, 'PENDING', NULL);
INSERT INTO public.order_items VALUES (41, 20, 13, 'Picarones', 1, 10.00, 'PENDING', NULL);
INSERT INTO public.order_items VALUES (42, 21, 2, 'Causa Limeña', 1, 18.00, 'PENDING', NULL);
INSERT INTO public.order_items VALUES (43, 21, 10, 'Agua Mineral', 1, 5.00, 'PENDING', NULL);
INSERT INTO public.order_items VALUES (44, 22, 1, 'Ceviche Clásico', 1, 25.00, 'PENDING', NULL);
INSERT INTO public.order_items VALUES (45, 22, 9, 'Limonada Clásica', 1, 7.00, 'PENDING', NULL);
INSERT INTO public.order_items VALUES (46, 23, 1, 'Ceviche Clásico', 1, 25.00, 'PENDING', NULL);
INSERT INTO public.order_items VALUES (47, 23, 9, 'Limonada Clásica', 1, 7.00, 'PENDING', NULL);
INSERT INTO public.order_items VALUES (48, 24, 3, 'Tequeños', 1, 15.00, 'PENDING', NULL);
INSERT INTO public.order_items VALUES (49, 24, 10, 'Agua Mineral', 1, 5.00, 'PENDING', NULL);
INSERT INTO public.order_items VALUES (50, 24, 15, 'Arroz con pollo', 1, 30.00, 'PENDING', NULL);
INSERT INTO public.order_items VALUES (51, 25, 4, 'Lomo Saltado', 2, 38.00, 'PENDING', NULL);
INSERT INTO public.order_items VALUES (52, 25, 3, 'Tequeños', 1, 15.00, 'PENDING', NULL);
INSERT INTO public.order_items VALUES (53, 25, 2, 'Causa Limeña', 1, 18.00, 'PENDING', NULL);
INSERT INTO public.order_items VALUES (54, 25, 5, 'Pollo a la Brasa', 1, 32.00, 'PENDING', NULL);
INSERT INTO public.order_items VALUES (55, 26, 1, 'Ceviche Clásico', 1, 25.00, 'PENDING', NULL);
INSERT INTO public.order_items VALUES (56, 26, 2, 'Causa Limeña', 1, 18.00, 'PENDING', NULL);
INSERT INTO public.order_items VALUES (57, 26, 3, 'Tequeños', 1, 15.00, 'PENDING', NULL);


--
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.orders VALUES (1, 1, 2, 'PAID', 'El ceviche picante', '2026-04-17 18:21:35.69201-05', '2026-04-17 18:23:18.661673-05');
INSERT INTO public.orders VALUES (15, 3, 1, 'PAID', NULL, '2026-04-19 12:12:29.202971-05', '2026-04-19 12:31:57.428598-05');
INSERT INTO public.orders VALUES (2, 2, 2, 'PAID', NULL, '2026-04-17 18:31:08.510149-05', '2026-04-17 18:32:05.470784-05');
INSERT INTO public.orders VALUES (16, 6, 1, 'PAID', NULL, '2026-04-19 12:32:27.265549-05', '2026-04-19 12:55:36.780988-05');
INSERT INTO public.orders VALUES (3, 1, 2, 'PAID', 'Sin picante', '2026-04-18 01:00:45.087569-05', '2026-04-18 01:02:58.012854-05');
INSERT INTO public.orders VALUES (4, 4, 2, 'PAID', NULL, '2026-04-18 01:04:44.861181-05', '2026-04-18 01:05:49.602577-05');
INSERT INTO public.orders VALUES (17, 1, 5, 'PAID', NULL, '2026-04-19 13:13:17.993244-05', '2026-04-19 13:16:00.841982-05');
INSERT INTO public.orders VALUES (18, 6, 2, 'PAID', NULL, '2026-04-19 13:14:32.268126-05', '2026-04-19 13:16:01.845977-05');
INSERT INTO public.orders VALUES (5, 2, 2, 'PAID', NULL, '2026-04-18 01:57:41.346532-05', '2026-04-18 01:57:41.953107-05');
INSERT INTO public.orders VALUES (6, 4, 2, 'PAID', 'La limonada sin azúcar', '2026-04-18 02:10:16.06104-05', '2026-04-18 02:11:33.231068-05');
INSERT INTO public.orders VALUES (7, 5, 2, 'PAID', NULL, '2026-04-18 02:13:50.124656-05', '2026-04-18 02:16:47.794937-05');
INSERT INTO public.orders VALUES (20, 1, 2, 'PAID', NULL, '2026-04-19 14:03:20.570898-05', '2026-04-19 14:04:33.66928-05');
INSERT INTO public.orders VALUES (19, 6, 5, 'PAID', NULL, '2026-04-19 14:03:05.037924-05', '2026-04-19 14:04:49.826753-05');
INSERT INTO public.orders VALUES (8, 3, 2, 'PAID', NULL, '2026-04-18 02:48:16.312956-05', '2026-04-18 02:48:16.632956-05');
INSERT INTO public.orders VALUES (21, 6, 5, 'PAID', NULL, '2026-04-19 15:34:52.352935-05', '2026-04-19 15:37:02.370225-05');
INSERT INTO public.orders VALUES (9, 10, 2, 'PAID', 'Agua helada con gas', '2026-04-18 02:53:02.263818-05', '2026-04-18 02:53:29.555845-05');
INSERT INTO public.orders VALUES (22, 8, 2, 'PAID', 'La Limonada sin azúcar', '2026-04-19 17:47:42.386072-05', '2026-04-19 17:50:27.397306-05');
INSERT INTO public.orders VALUES (10, 7, 2, 'PAID', NULL, '2026-04-18 02:54:56.318355-05', '2026-04-18 03:00:03.32125-05');
INSERT INTO public.orders VALUES (11, 9, 2, 'PAID', NULL, '2026-04-18 03:00:33.022217-05', '2026-04-18 03:01:35.868116-05');
INSERT INTO public.orders VALUES (23, 2, 2, 'PAID', NULL, '2026-04-20 00:38:03.699464-05', '2026-04-20 00:38:55.368381-05');
INSERT INTO public.orders VALUES (12, 1, 2, 'PAID', 'Con Hielo', '2026-04-18 13:47:02.743205-05', '2026-04-18 13:49:24.90406-05');
INSERT INTO public.orders VALUES (24, 10, 5, 'PAID', NULL, '2026-04-20 00:39:54.813784-05', '2026-04-20 00:40:13.570254-05');
INSERT INTO public.orders VALUES (13, 1, 2, 'PAID', NULL, '2026-04-19 12:09:46.974414-05', '2026-04-19 12:10:08.146224-05');
INSERT INTO public.orders VALUES (25, 5, 2, 'DELIVERED', NULL, '2026-04-20 00:41:31.725128-05', '2026-04-20 00:41:36.51662-05');
INSERT INTO public.orders VALUES (14, 1, 1, 'PAID', NULL, '2026-04-19 12:11:50.080557-05', '2026-04-19 12:12:00.625536-05');
INSERT INTO public.orders VALUES (26, 2, 5, 'DELIVERED', NULL, '2026-04-20 00:41:46.836604-05', '2026-04-20 00:41:51.014098-05');


--
-- Data for Name: restaurant_tables; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.restaurant_tables VALUES (10, 10, 8, 'FREE');
INSERT INTO public.restaurant_tables VALUES (5, 5, 4, 'OCCUPIED');
INSERT INTO public.restaurant_tables VALUES (2, 2, 2, 'OCCUPIED');
INSERT INTO public.restaurant_tables VALUES (12, 11, 4, 'FREE');
INSERT INTO public.restaurant_tables VALUES (4, 4, 4, 'FREE');
INSERT INTO public.restaurant_tables VALUES (7, 7, 6, 'FREE');
INSERT INTO public.restaurant_tables VALUES (9, 9, 8, 'FREE');
INSERT INTO public.restaurant_tables VALUES (3, 3, 4, 'FREE');
INSERT INTO public.restaurant_tables VALUES (1, 1, 3, 'FREE');
INSERT INTO public.restaurant_tables VALUES (6, 6, 4, 'FREE');
INSERT INTO public.restaurant_tables VALUES (8, 8, 6, 'FREE');


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.users VALUES (5, 'dquinde', '$2a$10$A8MHW9GypsXMLkEyLKuxMeCEyKmipCbCq.O39Cb.3LRH2/TL6iqou', 'Daniel Quinde', 'WAITER', true, '2026-04-18 02:48:16.094457-05');
INSERT INTO public.users VALUES (1, 'admin', '$2a$10$ZFznCgg25u2RPxqIxXsLJ.F2Z7a1GJKGG2/YdAR38M1.6BuhoLRKy', 'Administrador', 'ADMIN', true, '2026-04-17 17:37:01.699086-05');
INSERT INTO public.users VALUES (4, 'nvidal', '$2a$10$mDmR5/kKvRvBfnNoITgUvO03TJ/ZGcQBw.wwmXQXh4oCtHw4NvWzm', 'Nuria Vidal', 'CASHIER', true, '2026-04-17 17:37:01.728085-05');
INSERT INTO public.users VALUES (3, 'wtelles', '$2a$10$cIugV0Ku6gp/EK0DCibfB.3td1e9UzkgexRH2FBcNn0x9W4BTj/cG', 'Walter Telles', 'KITCHEN', true, '2026-04-17 17:37:01.723085-05');
INSERT INTO public.users VALUES (2, 'jurbina', '$2a$10$jt.wPmswmjn/hDZ4vEjFaO42BZ1oYn6uQE1JJxTrW/WPjM.IvZLG.', 'Javier Urbina', 'WAITER', true, '2026-04-17 17:37:01.718086-05');
INSERT INTO public.users VALUES (12, 'waiter1', '$2a$10$Qb7m4/QMAv/bNFvTG.LL/OJvbv6ri39OZREuG7tLytuR751TwEMHe', 'Juan Mesero', 'WAITER', true, '2026-04-19 17:34:22.319862-05');
INSERT INTO public.users VALUES (13, 'kitchen1', '$2a$10$jMcMkt0bfJ4HisTvz/qwGewB8p01GaJFSv6kLRL3fHaWkei6QRZk6', 'Carlos Cocinero', 'KITCHEN', true, '2026-04-19 17:34:22.335362-05');
INSERT INTO public.users VALUES (14, 'cajero1', '$2a$10$w/xn1/ZP3BQdqrY8rx1Q8uXuw2YOv7dTfbu8vcTmgD.rQXjK6XQji', 'María Cajera', 'CASHIER', true, '2026-04-19 17:34:22.339862-05');


--
-- Name: categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.categories_id_seq', 4, true);


--
-- Name: invoices_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.invoices_id_seq', 15, true);


--
-- Name: menu_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.menu_items_id_seq', 15, true);


--
-- Name: order_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.order_items_id_seq', 57, true);


--
-- Name: orders_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.orders_id_seq', 26, true);


--
-- Name: restaurant_tables_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.restaurant_tables_id_seq', 12, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.users_id_seq', 14, true);


--
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- Name: flyway_schema_history flyway_schema_history_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.flyway_schema_history
    ADD CONSTRAINT flyway_schema_history_pk PRIMARY KEY (installed_rank);


--
-- Name: invoices invoices_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT invoices_pkey PRIMARY KEY (id);


--
-- Name: menu_items menu_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.menu_items
    ADD CONSTRAINT menu_items_pkey PRIMARY KEY (id);


--
-- Name: order_items order_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_pkey PRIMARY KEY (id);


--
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (id);


--
-- Name: restaurant_tables restaurant_tables_number_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.restaurant_tables
    ADD CONSTRAINT restaurant_tables_number_key UNIQUE (number);


--
-- Name: restaurant_tables restaurant_tables_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.restaurant_tables
    ADD CONSTRAINT restaurant_tables_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- Name: flyway_schema_history_s_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX flyway_schema_history_s_idx ON public.flyway_schema_history USING btree (success);


--
-- Name: idx_invoices_created; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_invoices_created ON public.invoices USING btree (created_at);


--
-- Name: idx_invoices_order_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_invoices_order_id ON public.invoices USING btree (order_id);


--
-- Name: idx_menu_items_cat; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_menu_items_cat ON public.menu_items USING btree (category_id);


--
-- Name: idx_order_items_order; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_order_items_order ON public.order_items USING btree (order_id);


--
-- Name: idx_orders_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_orders_status ON public.orders USING btree (status);


--
-- Name: idx_orders_table_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_orders_table_id ON public.orders USING btree (table_id);


--
-- Name: idx_orders_waiter_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_orders_waiter_id ON public.orders USING btree (waiter_id);


--
-- Name: invoices invoices_cashier_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT invoices_cashier_id_fkey FOREIGN KEY (cashier_id) REFERENCES public.users(id);


--
-- Name: invoices invoices_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT invoices_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(id);


--
-- Name: invoices invoices_waiter_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT invoices_waiter_id_fkey FOREIGN KEY (waiter_id) REFERENCES public.users(id);


--
-- Name: menu_items menu_items_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.menu_items
    ADD CONSTRAINT menu_items_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.categories(id);


--
-- Name: order_items order_items_menu_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_menu_item_id_fkey FOREIGN KEY (menu_item_id) REFERENCES public.menu_items(id);


--
-- Name: order_items order_items_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(id) ON DELETE CASCADE;


--
-- Name: orders orders_table_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_table_id_fkey FOREIGN KEY (table_id) REFERENCES public.restaurant_tables(id);


--
-- Name: orders orders_waiter_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_waiter_id_fkey FOREIGN KEY (waiter_id) REFERENCES public.users(id);


--
-- PostgreSQL database dump complete
--

\unrestrict acvYfcfiZmZuQ5I29ifffowwVtutjROGopeKRDfjaKx6ytCvl6IJtKBoy9eTv8C

