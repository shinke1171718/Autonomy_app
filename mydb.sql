--
-- PostgreSQL database dump
--

-- Dumped from database version 14.8 (Homebrew)
-- Dumped by pg_dump version 14.8 (Homebrew)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
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
-- Name: active_storage_attachments; Type: TABLE; Schema: public; Owner: apple
--

CREATE TABLE public.active_storage_attachments (
    id bigint NOT NULL,
    name character varying NOT NULL,
    record_type character varying NOT NULL,
    record_id bigint NOT NULL,
    blob_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.active_storage_attachments OWNER TO apple;

--
-- Name: active_storage_attachments_id_seq; Type: SEQUENCE; Schema: public; Owner: apple
--

CREATE SEQUENCE public.active_storage_attachments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.active_storage_attachments_id_seq OWNER TO apple;

--
-- Name: active_storage_attachments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: apple
--

ALTER SEQUENCE public.active_storage_attachments_id_seq OWNED BY public.active_storage_attachments.id;


--
-- Name: active_storage_blobs; Type: TABLE; Schema: public; Owner: apple
--

CREATE TABLE public.active_storage_blobs (
    id bigint NOT NULL,
    key character varying NOT NULL,
    filename character varying NOT NULL,
    content_type character varying,
    metadata text,
    service_name character varying NOT NULL,
    byte_size bigint NOT NULL,
    checksum character varying,
    created_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.active_storage_blobs OWNER TO apple;

--
-- Name: active_storage_blobs_id_seq; Type: SEQUENCE; Schema: public; Owner: apple
--

CREATE SEQUENCE public.active_storage_blobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.active_storage_blobs_id_seq OWNER TO apple;

--
-- Name: active_storage_blobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: apple
--

ALTER SEQUENCE public.active_storage_blobs_id_seq OWNED BY public.active_storage_blobs.id;


--
-- Name: active_storage_variant_records; Type: TABLE; Schema: public; Owner: apple
--

CREATE TABLE public.active_storage_variant_records (
    id bigint NOT NULL,
    blob_id bigint NOT NULL,
    variation_digest character varying NOT NULL
);


ALTER TABLE public.active_storage_variant_records OWNER TO apple;

--
-- Name: active_storage_variant_records_id_seq; Type: SEQUENCE; Schema: public; Owner: apple
--

CREATE SEQUENCE public.active_storage_variant_records_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.active_storage_variant_records_id_seq OWNER TO apple;

--
-- Name: active_storage_variant_records_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: apple
--

ALTER SEQUENCE public.active_storage_variant_records_id_seq OWNED BY public.active_storage_variant_records.id;


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: apple
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.ar_internal_metadata OWNER TO apple;

--
-- Name: cart_items; Type: TABLE; Schema: public; Owner: apple
--

CREATE TABLE public.cart_items (
    id bigint NOT NULL,
    cart_id bigint NOT NULL,
    menu_id bigint NOT NULL,
    item_count integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.cart_items OWNER TO apple;

--
-- Name: cart_items_id_seq; Type: SEQUENCE; Schema: public; Owner: apple
--

CREATE SEQUENCE public.cart_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.cart_items_id_seq OWNER TO apple;

--
-- Name: cart_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: apple
--

ALTER SEQUENCE public.cart_items_id_seq OWNED BY public.cart_items.id;


--
-- Name: carts; Type: TABLE; Schema: public; Owner: apple
--

CREATE TABLE public.carts (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.carts OWNER TO apple;

--
-- Name: carts_id_seq; Type: SEQUENCE; Schema: public; Owner: apple
--

CREATE SEQUENCE public.carts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.carts_id_seq OWNER TO apple;

--
-- Name: carts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: apple
--

ALTER SEQUENCE public.carts_id_seq OWNED BY public.carts.id;


--
-- Name: categories; Type: TABLE; Schema: public; Owner: apple
--

CREATE TABLE public.categories (
    id bigint NOT NULL,
    category_name character varying DEFAULT ''::character varying NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.categories OWNER TO apple;

--
-- Name: categories_id_seq; Type: SEQUENCE; Schema: public; Owner: apple
--

CREATE SEQUENCE public.categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.categories_id_seq OWNER TO apple;

--
-- Name: categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: apple
--

ALTER SEQUENCE public.categories_id_seq OWNED BY public.categories.id;


--
-- Name: completed_menus; Type: TABLE; Schema: public; Owner: apple
--

CREATE TABLE public.completed_menus (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    menu_id bigint NOT NULL,
    menu_count integer NOT NULL,
    is_completed boolean DEFAULT false NOT NULL,
    date_completed date,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.completed_menus OWNER TO apple;

--
-- Name: completed_menus_id_seq; Type: SEQUENCE; Schema: public; Owner: apple
--

CREATE SEQUENCE public.completed_menus_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.completed_menus_id_seq OWNER TO apple;

--
-- Name: completed_menus_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: apple
--

ALTER SEQUENCE public.completed_menus_id_seq OWNED BY public.completed_menus.id;


--
-- Name: ingredients; Type: TABLE; Schema: public; Owner: apple
--

CREATE TABLE public.ingredients (
    id bigint NOT NULL,
    material_name character varying NOT NULL,
    material_id bigint NOT NULL,
    unit_id bigint NOT NULL,
    quantity numeric(4,1),
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.ingredients OWNER TO apple;

--
-- Name: ingredients_id_seq; Type: SEQUENCE; Schema: public; Owner: apple
--

CREATE SEQUENCE public.ingredients_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ingredients_id_seq OWNER TO apple;

--
-- Name: ingredients_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: apple
--

ALTER SEQUENCE public.ingredients_id_seq OWNED BY public.ingredients.id;


--
-- Name: material_units; Type: TABLE; Schema: public; Owner: apple
--

CREATE TABLE public.material_units (
    id bigint NOT NULL,
    material_id bigint NOT NULL,
    unit_id bigint NOT NULL,
    conversion_factor integer NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.material_units OWNER TO apple;

--
-- Name: material_units_id_seq; Type: SEQUENCE; Schema: public; Owner: apple
--

CREATE SEQUENCE public.material_units_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.material_units_id_seq OWNER TO apple;

--
-- Name: material_units_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: apple
--

ALTER SEQUENCE public.material_units_id_seq OWNED BY public.material_units.id;


--
-- Name: materials; Type: TABLE; Schema: public; Owner: apple
--

CREATE TABLE public.materials (
    id bigint NOT NULL,
    material_name character varying NOT NULL,
    category_id bigint NOT NULL,
    default_unit_id integer NOT NULL,
    hiragana character varying NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.materials OWNER TO apple;

--
-- Name: materials_id_seq; Type: SEQUENCE; Schema: public; Owner: apple
--

CREATE SEQUENCE public.materials_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.materials_id_seq OWNER TO apple;

--
-- Name: materials_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: apple
--

ALTER SEQUENCE public.materials_id_seq OWNED BY public.materials.id;


--
-- Name: menu_ingredients; Type: TABLE; Schema: public; Owner: apple
--

CREATE TABLE public.menu_ingredients (
    id bigint NOT NULL,
    menu_id bigint NOT NULL,
    ingredient_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.menu_ingredients OWNER TO apple;

--
-- Name: menu_ingredients_id_seq; Type: SEQUENCE; Schema: public; Owner: apple
--

CREATE SEQUENCE public.menu_ingredients_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.menu_ingredients_id_seq OWNER TO apple;

--
-- Name: menu_ingredients_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: apple
--

ALTER SEQUENCE public.menu_ingredients_id_seq OWNED BY public.menu_ingredients.id;


--
-- Name: menus; Type: TABLE; Schema: public; Owner: apple
--

CREATE TABLE public.menus (
    id bigint NOT NULL,
    menu_name character varying DEFAULT ''::character varying NOT NULL,
    menu_contents text DEFAULT ''::text NOT NULL,
    contents character varying DEFAULT ''::character varying NOT NULL,
    image_meta_data text DEFAULT ''::text NOT NULL,
    image character varying DEFAULT ''::character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.menus OWNER TO apple;

--
-- Name: menus_id_seq; Type: SEQUENCE; Schema: public; Owner: apple
--

CREATE SEQUENCE public.menus_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.menus_id_seq OWNER TO apple;

--
-- Name: menus_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: apple
--

ALTER SEQUENCE public.menus_id_seq OWNED BY public.menus.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: apple
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


ALTER TABLE public.schema_migrations OWNER TO apple;

--
-- Name: shopping_list_items; Type: TABLE; Schema: public; Owner: apple
--

CREATE TABLE public.shopping_list_items (
    id bigint NOT NULL,
    shopping_list_id bigint NOT NULL,
    material_id bigint NOT NULL,
    quantity numeric,
    unit_id bigint NOT NULL,
    category_id bigint NOT NULL,
    is_checked boolean,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.shopping_list_items OWNER TO apple;

--
-- Name: shopping_list_items_id_seq; Type: SEQUENCE; Schema: public; Owner: apple
--

CREATE SEQUENCE public.shopping_list_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.shopping_list_items_id_seq OWNER TO apple;

--
-- Name: shopping_list_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: apple
--

ALTER SEQUENCE public.shopping_list_items_id_seq OWNED BY public.shopping_list_items.id;


--
-- Name: shopping_list_menus; Type: TABLE; Schema: public; Owner: apple
--

CREATE TABLE public.shopping_list_menus (
    id bigint NOT NULL,
    shopping_list_id bigint NOT NULL,
    menu_id bigint NOT NULL,
    menu_count integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.shopping_list_menus OWNER TO apple;

--
-- Name: shopping_list_menus_id_seq; Type: SEQUENCE; Schema: public; Owner: apple
--

CREATE SEQUENCE public.shopping_list_menus_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.shopping_list_menus_id_seq OWNER TO apple;

--
-- Name: shopping_list_menus_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: apple
--

ALTER SEQUENCE public.shopping_list_menus_id_seq OWNED BY public.shopping_list_menus.id;


--
-- Name: shopping_lists; Type: TABLE; Schema: public; Owner: apple
--

CREATE TABLE public.shopping_lists (
    id bigint NOT NULL,
    cart_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.shopping_lists OWNER TO apple;

--
-- Name: shopping_lists_id_seq; Type: SEQUENCE; Schema: public; Owner: apple
--

CREATE SEQUENCE public.shopping_lists_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.shopping_lists_id_seq OWNER TO apple;

--
-- Name: shopping_lists_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: apple
--

ALTER SEQUENCE public.shopping_lists_id_seq OWNED BY public.shopping_lists.id;


--
-- Name: units; Type: TABLE; Schema: public; Owner: apple
--

CREATE TABLE public.units (
    id bigint NOT NULL,
    unit_name character varying DEFAULT ''::character varying NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.units OWNER TO apple;

--
-- Name: units_id_seq; Type: SEQUENCE; Schema: public; Owner: apple
--

CREATE SEQUENCE public.units_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.units_id_seq OWNER TO apple;

--
-- Name: units_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: apple
--

ALTER SEQUENCE public.units_id_seq OWNED BY public.units.id;


--
-- Name: user_menus; Type: TABLE; Schema: public; Owner: apple
--

CREATE TABLE public.user_menus (
    id bigint NOT NULL,
    user_id bigint,
    menu_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.user_menus OWNER TO apple;

--
-- Name: user_menus_id_seq; Type: SEQUENCE; Schema: public; Owner: apple
--

CREATE SEQUENCE public.user_menus_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_menus_id_seq OWNER TO apple;

--
-- Name: user_menus_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: apple
--

ALTER SEQUENCE public.user_menus_id_seq OWNED BY public.user_menus.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: apple
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    name character varying DEFAULT ''::character varying NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp(6) without time zone,
    remember_created_at timestamp(6) without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.users OWNER TO apple;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: apple
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO apple;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: apple
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: active_storage_attachments id; Type: DEFAULT; Schema: public; Owner: apple
--

ALTER TABLE ONLY public.active_storage_attachments ALTER COLUMN id SET DEFAULT nextval('public.active_storage_attachments_id_seq'::regclass);


--
-- Name: active_storage_blobs id; Type: DEFAULT; Schema: public; Owner: apple
--

ALTER TABLE ONLY public.active_storage_blobs ALTER COLUMN id SET DEFAULT nextval('public.active_storage_blobs_id_seq'::regclass);


--
-- Name: active_storage_variant_records id; Type: DEFAULT; Schema: public; Owner: apple
--

ALTER TABLE ONLY public.active_storage_variant_records ALTER COLUMN id SET DEFAULT nextval('public.active_storage_variant_records_id_seq'::regclass);


--
-- Name: cart_items id; Type: DEFAULT; Schema: public; Owner: apple
--

ALTER TABLE ONLY public.cart_items ALTER COLUMN id SET DEFAULT nextval('public.cart_items_id_seq'::regclass);


--
-- Name: carts id; Type: DEFAULT; Schema: public; Owner: apple
--

ALTER TABLE ONLY public.carts ALTER COLUMN id SET DEFAULT nextval('public.carts_id_seq'::regclass);


--
-- Name: categories id; Type: DEFAULT; Schema: public; Owner: apple
--

ALTER TABLE ONLY public.categories ALTER COLUMN id SET DEFAULT nextval('public.categories_id_seq'::regclass);


--
-- Name: completed_menus id; Type: DEFAULT; Schema: public; Owner: apple
--

ALTER TABLE ONLY public.completed_menus ALTER COLUMN id SET DEFAULT nextval('public.completed_menus_id_seq'::regclass);


--
-- Name: ingredients id; Type: DEFAULT; Schema: public; Owner: apple
--

ALTER TABLE ONLY public.ingredients ALTER COLUMN id SET DEFAULT nextval('public.ingredients_id_seq'::regclass);


--
-- Name: material_units id; Type: DEFAULT; Schema: public; Owner: apple
--

ALTER TABLE ONLY public.material_units ALTER COLUMN id SET DEFAULT nextval('public.material_units_id_seq'::regclass);


--
-- Name: materials id; Type: DEFAULT; Schema: public; Owner: apple
--

ALTER TABLE ONLY public.materials ALTER COLUMN id SET DEFAULT nextval('public.materials_id_seq'::regclass);


--
-- Name: menu_ingredients id; Type: DEFAULT; Schema: public; Owner: apple
--

ALTER TABLE ONLY public.menu_ingredients ALTER COLUMN id SET DEFAULT nextval('public.menu_ingredients_id_seq'::regclass);


--
-- Name: menus id; Type: DEFAULT; Schema: public; Owner: apple
--

ALTER TABLE ONLY public.menus ALTER COLUMN id SET DEFAULT nextval('public.menus_id_seq'::regclass);


--
-- Name: shopping_list_items id; Type: DEFAULT; Schema: public; Owner: apple
--

ALTER TABLE ONLY public.shopping_list_items ALTER COLUMN id SET DEFAULT nextval('public.shopping_list_items_id_seq'::regclass);


--
-- Name: shopping_list_menus id; Type: DEFAULT; Schema: public; Owner: apple
--

ALTER TABLE ONLY public.shopping_list_menus ALTER COLUMN id SET DEFAULT nextval('public.shopping_list_menus_id_seq'::regclass);


--
-- Name: shopping_lists id; Type: DEFAULT; Schema: public; Owner: apple
--

ALTER TABLE ONLY public.shopping_lists ALTER COLUMN id SET DEFAULT nextval('public.shopping_lists_id_seq'::regclass);


--
-- Name: units id; Type: DEFAULT; Schema: public; Owner: apple
--

ALTER TABLE ONLY public.units ALTER COLUMN id SET DEFAULT nextval('public.units_id_seq'::regclass);


--
-- Name: user_menus id; Type: DEFAULT; Schema: public; Owner: apple
--

ALTER TABLE ONLY public.user_menus ALTER COLUMN id SET DEFAULT nextval('public.user_menus_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: apple
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: active_storage_attachments; Type: TABLE DATA; Schema: public; Owner: apple
--

COPY public.active_storage_attachments (id, name, record_type, record_id, blob_id, created_at) FROM stdin;
407	image	Menu	99	407	2023-12-07 04:47:38.200719
408	image	ActiveStorage::VariantRecord	238	408	2023-12-07 04:47:43.14111
409	image	Menu	100	409	2023-12-07 04:49:58.26245
410	image	ActiveStorage::VariantRecord	239	410	2023-12-07 04:50:03.996679
411	image	Menu	101	411	2023-12-07 04:51:24.612791
412	image	ActiveStorage::VariantRecord	240	412	2023-12-07 04:51:33.251035
413	image	Menu	102	413	2023-12-07 04:55:25.422442
414	image	ActiveStorage::VariantRecord	241	414	2023-12-07 04:55:35.865888
425	image	Menu	103	425	2023-12-07 08:30:49.288767
426	image	ActiveStorage::VariantRecord	247	426	2023-12-07 08:30:50.545211
431	image	Menu	105	431	2023-12-07 08:46:02.981944
432	image	ActiveStorage::VariantRecord	250	432	2023-12-07 08:46:04.367442
433	image	Menu	104	433	2023-12-07 11:13:25.146601
434	image	ActiveStorage::VariantRecord	251	434	2023-12-07 11:13:25.726554
435	image	Menu	106	435	2023-12-07 12:15:57.198043
436	image	ActiveStorage::VariantRecord	252	436	2023-12-07 12:16:02.064239
437	image	ActiveStorage::VariantRecord	253	437	2023-12-08 07:33:34.09389
438	image	ActiveStorage::VariantRecord	254	438	2023-12-08 07:33:34.136288
439	image	ActiveStorage::VariantRecord	255	439	2023-12-08 07:33:34.193012
440	image	ActiveStorage::VariantRecord	256	440	2023-12-08 07:36:34.880436
441	image	ActiveStorage::VariantRecord	257	441	2023-12-08 07:36:35.367558
442	image	ActiveStorage::VariantRecord	258	442	2023-12-08 07:36:35.442775
443	image	ActiveStorage::VariantRecord	259	443	2023-12-08 07:42:39.948319
444	image	ActiveStorage::VariantRecord	260	444	2023-12-08 07:42:40.167337
445	image	ActiveStorage::VariantRecord	261	445	2023-12-08 07:42:40.282852
446	image	ActiveStorage::VariantRecord	262	446	2023-12-08 10:39:02.145581
447	image	ActiveStorage::VariantRecord	263	447	2023-12-08 10:39:02.166024
448	image	ActiveStorage::VariantRecord	264	448	2023-12-08 10:39:02.194703
449	image	Menu	107	449	2023-12-08 11:01:26.730343
450	image	ActiveStorage::VariantRecord	265	450	2023-12-08 11:01:27.42035
451	image	Menu	108	451	2023-12-08 11:02:50.513969
452	image	ActiveStorage::VariantRecord	266	452	2023-12-08 11:02:51.291458
453	image	ActiveStorage::VariantRecord	267	453	2023-12-08 11:02:58.32409
454	image	Menu	109	454	2023-12-08 11:47:07.301008
455	image	ActiveStorage::VariantRecord	268	455	2023-12-08 11:47:08.146568
456	image	Menu	110	456	2023-12-08 11:49:16.736201
457	image	ActiveStorage::VariantRecord	269	457	2023-12-08 11:49:17.361304
458	image	Menu	111	458	2023-12-08 11:49:43.978815
459	image	ActiveStorage::VariantRecord	270	459	2023-12-08 11:49:44.581071
460	image	ActiveStorage::VariantRecord	272	460	2023-12-08 13:33:46.435324
461	image	ActiveStorage::VariantRecord	271	461	2023-12-08 13:33:46.438816
462	image	ActiveStorage::VariantRecord	273	462	2023-12-10 05:00:51.904053
463	image	ActiveStorage::VariantRecord	274	463	2023-12-10 08:16:32.107049
464	image	ActiveStorage::VariantRecord	275	464	2023-12-13 03:20:06.947455
465	image	ActiveStorage::VariantRecord	276	465	2023-12-13 03:20:17.124423
466	image	Menu	112	466	2023-12-13 06:45:16.220147
467	image	ActiveStorage::VariantRecord	277	467	2023-12-13 06:45:16.905271
468	image	ActiveStorage::VariantRecord	279	468	2023-12-13 08:16:01.550968
469	image	ActiveStorage::VariantRecord	278	469	2023-12-13 08:16:01.55552
470	image	ActiveStorage::VariantRecord	280	470	2023-12-14 11:16:21.259433
471	image	Menu	113	471	2023-12-18 06:38:25.499999
472	image	ActiveStorage::VariantRecord	281	472	2023-12-18 06:38:26.208019
473	image	ActiveStorage::VariantRecord	282	473	2023-12-18 10:50:34.249504
\.


--
-- Data for Name: active_storage_blobs; Type: TABLE DATA; Schema: public; Owner: apple
--

COPY public.active_storage_blobs (id, key, filename, content_type, metadata, service_name, byte_size, checksum, created_at) FROM stdin;
55	ngir1rr1h7doup21ddzzp88mxsno	user_1の献立の画像	image/jpeg	{"identified":true,"width":500,"height":500,"analyzed":true}	local	90449	TChT2dbbAsoeaLkq7XGY5g==	2023-11-14 03:18:53.872983
56	3cex2ceb8p8z5bndibw4cchbr7kb	user_1の献立の画像.jpeg	image/jpeg	{"identified":true,"width":200,"height":200,"analyzed":true}	local	51640	MOkJuUnXXNW9LhuZGvCNWg==	2023-11-14 03:18:54.37064
60	urlvi19hgwwva0h0t1zbss891u7s	default-menu-icon.jpeg	image/jpeg	{"identified":true,"width":200,"height":200,"analyzed":true}	local	5325	F69I7PzWOKio6t6FZdQ2nQ==	2023-11-14 04:38:09.750354
63	2rdz1fsp18pyed0rj1jpcmctzelb	default-menu-icon.png	image/jpeg	{"identified":true,"width":1080,"height":1080,"analyzed":true}	local	42433	Bos7l7mcbGNOGZPbRzeoWw==	2023-11-14 07:36:50.518028
68	1vbk1ra1lcwtzyqoyxve4xldzy0d	default-menu-icon.jpeg	image/jpeg	{"identified":true,"width":200,"height":200,"analyzed":true}	local	5325	F69I7PzWOKio6t6FZdQ2nQ==	2023-11-14 07:53:19.468328
71	xofm0z50va5ccdg4go7k4pjbccz8	default-menu-icon.png	image/jpeg	{"identified":true,"width":1080,"height":1080,"analyzed":true}	local	42433	Bos7l7mcbGNOGZPbRzeoWw==	2023-11-14 13:31:59.583511
72	gn1kp0dovyo9cxvk8xhzrl0oco0l	default-menu-icon.jpeg	image/jpeg	{"identified":true,"width":200,"height":200,"analyzed":true}	local	5325	F69I7PzWOKio6t6FZdQ2nQ==	2023-11-14 13:32:47.457132
73	zt8b9mo25hyd5nbac0ol5v4mf4d0	default-menu-icon.png	image/jpeg	{"identified":true,"width":1080,"height":1080,"analyzed":true}	local	42433	Bos7l7mcbGNOGZPbRzeoWw==	2023-11-14 13:34:29.266177
77	h26czn9njad5qbwxt30ney3mol9t	default-menu-icon.png	image/jpeg	{"identified":true,"width":1080,"height":1080,"analyzed":true}	local	42433	Bos7l7mcbGNOGZPbRzeoWw==	2023-11-14 13:36:11.123274
78	bjh8y0aacqnokgcovzvrrut9omfz	default-menu-icon.jpeg	image/jpeg	{"identified":true,"width":200,"height":200,"analyzed":true}	local	5325	F69I7PzWOKio6t6FZdQ2nQ==	2023-11-14 13:36:12.459862
80	ffzne0wtspxevys3ku6s1wzr624g	default-menu-icon.jpeg	image/jpeg	{"identified":true,"width":200,"height":200,"analyzed":true}	local	5325	F69I7PzWOKio6t6FZdQ2nQ==	2023-11-14 13:42:33.598555
81	l3mx4hvkzu9pwds0mgwamuk542j7	user_1の献立の画像	image/jpeg	{"identified":true,"width":500,"height":500,"analyzed":true}	local	90449	TChT2dbbAsoeaLkq7XGY5g==	2023-11-14 13:42:58.420629
82	ddvr6b50yodnq9gmzxkepsgi3uxi	user_1の献立の画像.jpeg	image/jpeg	{"identified":true,"width":200,"height":200,"analyzed":true}	local	51640	MOkJuUnXXNW9LhuZGvCNWg==	2023-11-14 13:42:59.73365
85	0187zyzhzohh7aiqa0iec4jrrp52	user_1の献立の画像	image/jpeg	{"identified":true,"width":252,"height":200,"analyzed":true}	local	6920	NlQsV7EhgTVs6AS0lVEOtg==	2023-11-14 14:23:22.644833
86	7i9nu3laaixz0ct3vhntke8id40w	user_1の献立の画像.jpeg	image/jpeg	{"identified":true,"width":200,"height":159,"analyzed":true}	local	5129	7j6Ouo1leXfOM9U0Go2KcA==	2023-11-14 14:23:23.244116
89	zgt2o7vqs6m9s5ey0bzxllj8iwwi	user_1の献立の画像.jpeg	image/jpeg	{"identified":true,"width":300,"height":300,"analyzed":true}	local	73433	U2PIrNzyxstFcHGdo6vk2A==	2023-11-14 14:30:35.218473
97	5ml37igzaxesqwcfe9pf238jrl7b	user_1の献立の画像.jpeg	image/jpeg	{"identified":true,"width":300,"height":300,"analyzed":true}	local	73433	U2PIrNzyxstFcHGdo6vk2A==	2023-11-14 14:30:37.135512
102	66peadyh1s8lhwjqt9nzvv7nhd6k	default-menu-icon.jpeg	image/jpeg	{"identified":true,"width":300,"height":300,"analyzed":true}	local	7610	NDQFalTsfJNYTMWxAEWGfQ==	2023-11-14 14:30:38.202524
107	9vtnxuktkk7xguqgbybfgx6lh966	default-menu-icon.jpeg	image/jpeg	{"identified":true,"width":250,"height":250,"analyzed":true}	local	6597	npCDEnudEjFTQeXvUwVQ7A==	2023-11-14 14:31:02.890386
111	b694lpg93v8on9oxmcvl4snr1cp1	default-menu-icon.jpeg	image/jpeg	{"identified":true,"width":250,"height":250,"analyzed":true}	local	6597	npCDEnudEjFTQeXvUwVQ7A==	2023-11-14 14:31:04.016713
115	hpdqo2k6zfz448jmba214guzxq5z	default-menu-icon.jpeg	image/jpeg	{"identified":true,"width":250,"height":250,"analyzed":true}	local	6597	npCDEnudEjFTQeXvUwVQ7A==	2023-11-14 14:31:04.775708
121	8kt4q2nuhl6r0m92ftz5qrv8aklq	default-menu-icon.png	image/jpeg	{"identified":true,"width":1080,"height":1080,"analyzed":true}	local	42433	Bos7l7mcbGNOGZPbRzeoWw==	2023-11-14 14:40:30.159389
123	6vz3cxyh8g35v5vmgvle946gv85s	default-menu-icon.png	image/jpeg	{"identified":true,"width":1080,"height":1080,"analyzed":true}	local	42433	Bos7l7mcbGNOGZPbRzeoWw==	2023-11-15 07:32:35.040501
124	dkbl9safp8n6rs4bycbudfb2csl6	default-menu-icon.jpeg	image/jpeg	{"identified":true,"width":200,"height":200,"analyzed":true}	local	5325	F69I7PzWOKio6t6FZdQ2nQ==	2023-11-15 07:32:36.112852
128	8q3ku0yuu9ggvzqnaff2f3ny4770	default-menu-icon.jpeg	image/jpeg	{"identified":true,"width":200,"height":200,"analyzed":true}	local	5325	F69I7PzWOKio6t6FZdQ2nQ==	2023-11-16 03:47:45.423399
129	r6o69h28acnplv1j9ltti86c7ypn	default-menu-icon.png	image/jpeg	{"identified":true,"width":1080,"height":1080,"analyzed":true}	local	42433	Bos7l7mcbGNOGZPbRzeoWw==	2023-11-16 03:49:34.621665
135	drjb0mk5tg4zv4th521vcl14nel0	user_1の献立の画像	image/jpeg	{"identified":true,"width":500,"height":500,"analyzed":true}	local	90449	TChT2dbbAsoeaLkq7XGY5g==	2023-11-16 05:54:21.940088
139	36pl6403ae72s6xdjlncogzg2smv	user_1の献立の画像	image/jpeg	{"identified":true,"width":500,"height":500,"analyzed":true}	local	90449	TChT2dbbAsoeaLkq7XGY5g==	2023-11-23 03:54:09.245251
141	yf3ghchxjbjv6q5hq4n0qyuznfga	user_1の献立の画像	image/jpeg	{"identified":true,"width":500,"height":500,"analyzed":true}	local	90449	TChT2dbbAsoeaLkq7XGY5g==	2023-11-24 06:39:29.75575
145	3urnad7fh987dbhwurjezhd75e2h	default-menu-icon.png	image/jpeg	{"identified":true,"width":1080,"height":1080,"analyzed":true}	local	42433	Bos7l7mcbGNOGZPbRzeoWw==	2023-11-24 06:42:28.247642
147	7u7xd65f86wi2hdixbiri9ctw4ve	default-menu-icon.png	image/jpeg	{"identified":true,"width":1080,"height":1080,"analyzed":true}	local	42433	Bos7l7mcbGNOGZPbRzeoWw==	2023-11-24 06:43:07.783049
149	7h2ejpdb93ug950p4l68rpik6g22	default-menu-icon.png	image/jpeg	{"identified":true,"width":1080,"height":1080,"analyzed":true}	local	42433	Bos7l7mcbGNOGZPbRzeoWw==	2023-11-24 06:43:45.983018
151	4pmjl7vv83b234vvw15htregcmrz	user_1の献立の画像	image/jpeg	{"identified":true,"width":500,"height":500,"analyzed":true}	local	90449	TChT2dbbAsoeaLkq7XGY5g==	2023-11-24 08:55:26.504492
152	sddfsgiunrlqucztfj6i9fnz8bb8	default-menu-icon.png	image/jpeg	{"identified":true,"width":1080,"height":1080,"analyzed":true}	local	42433	Bos7l7mcbGNOGZPbRzeoWw==	2023-11-24 08:57:07.094493
154	ft7h0ihfi1nerw9e02pq884551ny	default-menu-icon.jpeg	image/jpeg	{"identified":true,"width":200,"height":200,"analyzed":true}	local	5325	F69I7PzWOKio6t6FZdQ2nQ==	2023-11-24 08:57:08.784391
155	hfryg9okj094li715p87dvto7ioe	default-menu-icon.png	image/jpeg	{"identified":true,"width":1080,"height":1080,"analyzed":true}	local	42433	Bos7l7mcbGNOGZPbRzeoWw==	2023-11-24 09:05:44.934935
57	r54cgni837wjp22dlvjtp3dkf32f	user_1の献立の画像	image/jpeg	{"identified":true,"width":800,"height":800,"analyzed":true}	local	126363	1dvgOsPJPFWVidUZCA4/uw==	2023-11-14 04:24:15.376721
58	zkgausokzjrfayjhimhhnfei99sn	user_1の献立の画像.jpeg	image/jpeg	{"identified":true,"width":200,"height":200,"analyzed":true}	local	16844	CiebfGapgfuPRCKK9vJLHA==	2023-11-14 04:24:15.780851
61	21gyplhkbg9yjca873f786om5wcz	default-menu-icon.png	image/jpeg	{"identified":true,"width":1080,"height":1080,"analyzed":true}	local	42433	Bos7l7mcbGNOGZPbRzeoWw==	2023-11-14 07:02:38.507154
64	7vvf3o76zz3sih8kgjhuur3fs3np	default-menu-icon.png	image/jpeg	{"identified":true,"width":1080,"height":1080,"analyzed":true}	local	42433	Bos7l7mcbGNOGZPbRzeoWw==	2023-11-14 07:47:40.916725
67	2n9tkm8oolvnskq73xc4dgplq5yj	default-menu-icon.jpeg	image/jpeg	{"identified":true,"width":200,"height":200,"analyzed":true}	local	5325	F69I7PzWOKio6t6FZdQ2nQ==	2023-11-14 07:53:19.048083
69	6xnjawuc0rrq1ifgozufmx699bry	default-menu-icon.png	image/jpeg	{"identified":true,"width":1080,"height":1080,"analyzed":true}	local	42433	Bos7l7mcbGNOGZPbRzeoWw==	2023-11-14 09:17:13.502648
74	5qntgzfyncoj09flzi561hotf8b9	default-menu-icon.jpeg	image/jpeg	{"identified":true,"width":200,"height":200,"analyzed":true}	local	5325	F69I7PzWOKio6t6FZdQ2nQ==	2023-11-14 13:34:29.898216
75	cx7lm0nm3z6rev5s9qoa479hvj81	default-menu-icon.png	image/jpeg	{"identified":true,"width":1080,"height":1080,"analyzed":true}	local	42433	Bos7l7mcbGNOGZPbRzeoWw==	2023-11-14 13:34:56.483958
76	trhaktm05cb8kac3qwm0bdppkcju	default-menu-icon.jpeg	image/jpeg	{"identified":true,"width":200,"height":200,"analyzed":true}	local	5325	F69I7PzWOKio6t6FZdQ2nQ==	2023-11-14 13:34:57.11394
83	eqxq02s8fzsh1aajyor1mbby7v5o	user_1の献立の画像	image/jpeg	{"identified":true,"width":500,"height":500,"analyzed":true}	local	90449	TChT2dbbAsoeaLkq7XGY5g==	2023-11-14 13:45:12.635545
87	uz86k7rj3rzekbtguxi8sg9k5qvt	default-menu-icon.jpeg	image/jpeg	{"identified":true,"width":300,"height":300,"analyzed":true}	local	7610	NDQFalTsfJNYTMWxAEWGfQ==	2023-11-14 14:30:35.05933
90	nhe3xhkq0siq5x43ustu426s4lnp	user_1の献立の画像.jpeg	image/jpeg	{"identified":true,"width":300,"height":300,"analyzed":true}	local	31405	SkC+6r/pA5Mpx7KxyLhHmQ==	2023-11-14 14:30:35.259385
94	yrmnojz125v3poy7t5onnelizdcz	default-menu-icon.jpeg	image/jpeg	{"identified":true,"width":300,"height":300,"analyzed":true}	local	7610	NDQFalTsfJNYTMWxAEWGfQ==	2023-11-14 14:30:36.547058
99	i8knz3b4qpqj6m0y6owf4r0fcslu	default-menu-icon.jpeg	image/jpeg	{"identified":true,"width":300,"height":300,"analyzed":true}	local	7610	NDQFalTsfJNYTMWxAEWGfQ==	2023-11-14 14:30:37.557048
104	1m9tt19r34bil9e9xutb6u02l1ii	user_1の献立の画像.jpeg	image/jpeg	{"identified":true,"width":250,"height":250,"analyzed":true}	local	62020	sWt0jLStB8KiFHMTCb5NOA==	2023-11-14 14:31:02.652214
106	ac4co8jcbcvm14b9xc2u7zvc81h7	user_1の献立の画像.jpeg	image/jpeg	{"identified":true,"width":250,"height":250,"analyzed":true}	local	62020	sWt0jLStB8KiFHMTCb5NOA==	2023-11-14 14:31:02.749131
109	260z9jiy811nakjrptzuhck99g22	user_1の献立の画像.jpeg	image/jpeg	{"identified":true,"width":250,"height":250,"analyzed":true}	local	62020	sWt0jLStB8KiFHMTCb5NOA==	2023-11-14 14:31:03.522522
113	qsvpr67zwyrddcpil9fb1outnfdg	user_1の献立の画像.jpeg	image/jpeg	{"identified":true,"width":250,"height":250,"analyzed":true}	local	62020	sWt0jLStB8KiFHMTCb5NOA==	2023-11-14 14:31:04.091414
116	vpmh16iznk4y7v9dkzum817o7wq7	default-menu-icon.jpeg	image/jpeg	{"identified":true,"width":250,"height":250,"analyzed":true}	local	6597	npCDEnudEjFTQeXvUwVQ7A==	2023-11-14 14:31:05.04227
119	7jwwpvo8a6vnyfnul92w1y99owio	default-menu-icon.jpeg	image/jpeg	{"identified":true,"width":250,"height":250,"analyzed":true}	local	6597	npCDEnudEjFTQeXvUwVQ7A==	2023-11-14 14:31:05.721137
122	15umu6x3d9dq0xqsir66s5lgmuta	default-menu-icon.jpeg	image/jpeg	{"identified":true,"width":200,"height":200,"analyzed":true}	local	5325	F69I7PzWOKio6t6FZdQ2nQ==	2023-11-14 14:40:30.775204
125	w3em7lt6q4s3ob1kzhyvt29dnjhn	user_1の献立の画像	image/jpeg	{"identified":true,"width":252,"height":200,"analyzed":true}	local	6920	NlQsV7EhgTVs6AS0lVEOtg==	2023-11-16 03:29:33.565091
126	7txmfpvrhiv6ofnhrrd83pwg4tk1	user_1の献立の画像.jpeg	image/jpeg	{"identified":true,"width":200,"height":159,"analyzed":true}	local	5129	7j6Ouo1leXfOM9U0Go2KcA==	2023-11-16 03:29:34.12619
131	gkwraglfn6fxbf4hpsy4aqust5xh	user_1の献立の画像	image/jpeg	{"identified":true,"width":294,"height":293,"analyzed":true}	local	12647	ZPNzZDD8Cx21tL2M3zyTJQ==	2023-11-16 04:23:33.474172
132	0bb8hs66ipfsi6i2z533x55mqdxf	user_1の献立の画像.jpeg	image/jpeg	{"identified":true,"width":200,"height":199,"analyzed":true}	local	10190	+M9iiJrcxRHADSneVmnpbQ==	2023-11-16 04:23:34.036408
136	vu4f4cumiowe1fno1z8igrchaokh	user_1の献立の画像.jpeg	image/jpeg	{"identified":true,"width":200,"height":200,"analyzed":true}	local	51640	MOkJuUnXXNW9LhuZGvCNWg==	2023-11-16 05:54:23.02777
140	mt3bnh5p9n9d9gwmckreirltb5i3	user_1の献立の画像.jpeg	image/jpeg	{"identified":true,"width":200,"height":200,"analyzed":true}	local	51640	MOkJuUnXXNW9LhuZGvCNWg==	2023-11-23 03:54:10.523254
142	jfkj1gv5z8wid6sycfihcvv4swa3	default-menu-icon.png	image/jpeg	{"identified":true,"width":1080,"height":1080,"analyzed":true}	local	42433	Bos7l7mcbGNOGZPbRzeoWw==	2023-11-24 06:40:47.629873
143	ww6eq7yo7dwwegw36f9de5lmidza	default-menu-icon.jpeg	image/jpeg	{"identified":true,"width":200,"height":200,"analyzed":true}	local	5325	F69I7PzWOKio6t6FZdQ2nQ==	2023-11-24 06:40:48.590937
148	19st3yde873gke6f7nil0dmq3cdk	default-menu-icon.jpeg	image/jpeg	{"identified":true,"width":200,"height":200,"analyzed":true}	local	5325	F69I7PzWOKio6t6FZdQ2nQ==	2023-11-24 06:43:08.858901
150	pqx6sdinmz5wt7rgmfl21ytov2e1	default-menu-icon.jpeg	image/jpeg	{"identified":true,"width":200,"height":200,"analyzed":true}	local	5325	F69I7PzWOKio6t6FZdQ2nQ==	2023-11-24 06:43:47.175898
153	qf9mgqqt9khgwjolyknc3q5sdqvh	user_1の献立の画像.jpeg	image/jpeg	{"identified":true,"width":200,"height":200,"analyzed":true}	local	51640	MOkJuUnXXNW9LhuZGvCNWg==	2023-11-24 08:57:08.642579
156	pq9oj0q2stxs3g3yc1j7p87g8076	default-menu-icon.jpeg	image/jpeg	{"identified":true,"width":200,"height":200,"analyzed":true}	local	5325	F69I7PzWOKio6t6FZdQ2nQ==	2023-11-24 09:05:46.552837
157	h9ghd4mrvkofsw8cpbp1uo0md89t	user_1の献立の画像	image/jpeg	{"identified":true,"width":252,"height":200,"analyzed":true}	local	6920	NlQsV7EhgTVs6AS0lVEOtg==	2023-11-24 09:06:13.954839
158	jntgmo0550e2bujt364ewpf1fa8p	user_1の献立の画像.jpeg	image/jpeg	{"identified":true,"width":200,"height":159,"analyzed":true}	local	5129	7j6Ouo1leXfOM9U0Go2KcA==	2023-11-24 09:06:15.168932
59	yqu19q7ugyxbhihwjvnnax0wyfhy	default-menu-icon.png	image/jpeg	{"identified":true,"width":1080,"height":1080,"analyzed":true}	local	42433	Bos7l7mcbGNOGZPbRzeoWw==	2023-11-14 04:38:09.013698
62	o0ssxzk6cm8r7qcsa7htp6kfzfo3	default-menu-icon.jpeg	image/jpeg	{"identified":true,"width":200,"height":200,"analyzed":true}	local	5325	F69I7PzWOKio6t6FZdQ2nQ==	2023-11-14 07:02:39.620416
65	klrqqgzzu2v6qtn93djnicmfkws4	default-menu-icon.png	image/jpeg	{"identified":true,"width":1080,"height":1080,"analyzed":true}	local	42433	Bos7l7mcbGNOGZPbRzeoWw==	2023-11-14 07:53:18.083623
66	kffu7to2ds6ywlttcsh8ih2ssz48	default-menu-icon.jpeg	image/jpeg	{"identified":true,"width":200,"height":200,"analyzed":true}	local	5325	F69I7PzWOKio6t6FZdQ2nQ==	2023-11-14 07:53:19.002283
70	47jjaorkl9dibxkepu4tqz4d98zn	default-menu-icon.jpeg	image/jpeg	{"identified":true,"width":200,"height":200,"analyzed":true}	local	5325	F69I7PzWOKio6t6FZdQ2nQ==	2023-11-14 09:17:15.085548
79	o73j3kz5ps3ohpivvrr74k0g8lst	default-menu-icon.png	image/jpeg	{"identified":true,"width":1080,"height":1080,"analyzed":true}	local	42433	Bos7l7mcbGNOGZPbRzeoWw==	2023-11-14 13:42:31.37209
84	t9rr86fvu2rzgoxojvbnrs7zfccj	user_1の献立の画像.jpeg	image/jpeg	{"identified":true,"width":200,"height":200,"analyzed":true}	local	51640	MOkJuUnXXNW9LhuZGvCNWg==	2023-11-14 13:45:15.019735
88	4dd9jyo6vtk6z3un076rivgj3zef	default-menu-icon.jpeg	image/jpeg	{"identified":true,"width":300,"height":300,"analyzed":true}	local	7610	NDQFalTsfJNYTMWxAEWGfQ==	2023-11-14 14:30:35.112232
91	jl0h6nm373qomeqlxuz8yeudjngm	user_1の献立の画像.jpeg	image/jpeg	{"identified":true,"width":300,"height":300,"analyzed":true}	local	73433	U2PIrNzyxstFcHGdo6vk2A==	2023-11-14 14:30:35.569009
92	oqsr0piylzxikuys3kar9f9sj8dm	default-menu-icon.jpeg	image/jpeg	{"identified":true,"width":300,"height":300,"analyzed":true}	local	7610	NDQFalTsfJNYTMWxAEWGfQ==	2023-11-14 14:30:35.836751
93	vaj83qa73a66ueq36wfiaral92i8	default-menu-icon.jpeg	image/jpeg	{"identified":true,"width":300,"height":300,"analyzed":true}	local	7610	NDQFalTsfJNYTMWxAEWGfQ==	2023-11-14 14:30:36.379768
95	1i8rd4gim54unibb5rcj1wuxppi3	default-menu-icon.jpeg	image/jpeg	{"identified":true,"width":300,"height":300,"analyzed":true}	local	7610	NDQFalTsfJNYTMWxAEWGfQ==	2023-11-14 14:30:36.58369
96	fcffx1aifuj01qhmp4xlckgd99wf	default-menu-icon.jpeg	image/jpeg	{"identified":true,"width":300,"height":300,"analyzed":true}	local	7610	NDQFalTsfJNYTMWxAEWGfQ==	2023-11-14 14:30:36.985996
98	1dxfvvhhvgmoxdfb8wigfyx5l0qz	default-menu-icon.jpeg	image/jpeg	{"identified":true,"width":300,"height":300,"analyzed":true}	local	7610	NDQFalTsfJNYTMWxAEWGfQ==	2023-11-14 14:30:37.461462
53	fwzs9t16i3gp5z1zny34xtq5yeh1	user_1の献立の画像	image/jpeg	{"identified":true,"width":500,"height":500,"analyzed":true}	local	90449	TChT2dbbAsoeaLkq7XGY5g==	2023-11-14 02:51:20.265985
54	n451cwu9l5ulon7qaezrw9cfd27d	user_1の献立の画像.jpeg	image/jpeg	{"identified":true,"width":200,"height":200,"analyzed":true}	local	51640	MOkJuUnXXNW9LhuZGvCNWg==	2023-11-14 02:51:21.009162
100	up33zgzxfa8xpt9cxbx94dpcsfaq	user_1の献立の画像.jpeg	image/jpeg	{"identified":true,"width":252,"height":200,"analyzed":true}	local	7422	SiR2BCesW8pR8zNWipE62A==	2023-11-14 14:30:37.584938
101	y8m7t32quw9u0m93wx5t1ztbg2bu	user_1の献立の画像.jpeg	image/jpeg	{"identified":true,"width":300,"height":300,"analyzed":true}	local	73433	U2PIrNzyxstFcHGdo6vk2A==	2023-11-14 14:30:38.005046
103	7s5oqdl42qlwpktigm23rrbauhl3	default-menu-icon.jpeg	image/jpeg	{"identified":true,"width":300,"height":300,"analyzed":true}	local	7610	NDQFalTsfJNYTMWxAEWGfQ==	2023-11-14 14:30:39.414375
105	b38qdrizl1s5cg74od7ran4d7kj3	default-menu-icon.jpeg	image/jpeg	{"identified":true,"width":250,"height":250,"analyzed":true}	local	6597	npCDEnudEjFTQeXvUwVQ7A==	2023-11-14 14:31:02.669075
108	u2xtvdui5aelao6l12mcyquucx6s	default-menu-icon.jpeg	image/jpeg	{"identified":true,"width":250,"height":250,"analyzed":true}	local	6597	npCDEnudEjFTQeXvUwVQ7A==	2023-11-14 14:31:02.922522
110	jhimew0uc11ozbhwtz2ew0enxge0	default-menu-icon.jpeg	image/jpeg	{"identified":true,"width":250,"height":250,"analyzed":true}	local	6597	npCDEnudEjFTQeXvUwVQ7A==	2023-11-14 14:31:03.808372
114	88d2c5k8lddhuhp8srwlo27afgpw	user_1の献立の画像.jpeg	image/jpeg	{"identified":true,"width":250,"height":198,"analyzed":true}	local	7122	kpnbmmbsxHruKT6Rqf6K1g==	2023-11-14 14:31:04.677848
112	px0uhetjic1exvj3inzn09c18rhb	default-menu-icon.jpeg	image/jpeg	{"identified":true,"width":250,"height":250,"analyzed":true}	local	6597	npCDEnudEjFTQeXvUwVQ7A==	2023-11-14 14:31:04.028194
117	9650rtkvm40464rcnewuuozqntgx	default-menu-icon.jpeg	image/jpeg	{"identified":true,"width":250,"height":250,"analyzed":true}	local	6597	npCDEnudEjFTQeXvUwVQ7A==	2023-11-14 14:31:05.273451
118	5apna9r9omyofl8tnc4ayuwdp6gj	default-menu-icon.jpeg	image/jpeg	{"identified":true,"width":250,"height":250,"analyzed":true}	local	6597	npCDEnudEjFTQeXvUwVQ7A==	2023-11-14 14:31:05.346608
120	qfpep4pwg396kg3sndgd3k6ysrme	user_1の献立の画像.jpeg	image/jpeg	{"identified":true,"width":250,"height":250,"analyzed":true}	local	23618	yYsHUk6nHu8xNjkyAeQWCA==	2023-11-14 14:31:07.118048
127	hcj3c40aasl7oannztxhoa7h8pnw	default-menu-icon.png	image/jpeg	{"identified":true,"width":1080,"height":1080,"analyzed":true}	local	42433	Bos7l7mcbGNOGZPbRzeoWw==	2023-11-16 03:47:44.38942
130	2c41s92u3bey3wlbtw7t45jbrapj	default-menu-icon.jpeg	image/jpeg	{"identified":true,"width":200,"height":200,"analyzed":true}	local	5325	F69I7PzWOKio6t6FZdQ2nQ==	2023-11-16 03:49:35.510224
133	8wnhuz7u611hwmpuqsmgimpsk51n	default-menu-icon.png	image/jpeg	{"identified":true,"width":1080,"height":1080,"analyzed":true}	local	42433	Bos7l7mcbGNOGZPbRzeoWw==	2023-11-16 05:41:23.564367
134	tra9yr6vps2z29euedee1rne2ytj	default-menu-icon.jpeg	image/jpeg	{"identified":true,"width":200,"height":200,"analyzed":true}	local	5325	F69I7PzWOKio6t6FZdQ2nQ==	2023-11-16 05:41:24.349276
137	ev8qxvqa9fyopkxepfyrs6qtxfpy	user_1の献立の画像	image/jpeg	{"identified":true,"width":294,"height":293,"analyzed":true}	local	12647	ZPNzZDD8Cx21tL2M3zyTJQ==	2023-11-16 06:01:40.308303
138	5kyk57yivkrfp9tmrmgz5prr0cf7	user_1の献立の画像.jpeg	image/jpeg	{"identified":true,"width":200,"height":199,"analyzed":true}	local	10190	+M9iiJrcxRHADSneVmnpbQ==	2023-11-16 06:01:40.998924
144	1ta5801r94941tclnsa6v9xayds6	user_1の献立の画像.jpeg	image/jpeg	{"identified":true,"width":200,"height":200,"analyzed":true}	local	51640	MOkJuUnXXNW9LhuZGvCNWg==	2023-11-24 06:40:48.599225
146	05zay2b26trrn7kf5a5v6ic13h8s	default-menu-icon.jpeg	image/jpeg	{"identified":true,"width":200,"height":200,"analyzed":true}	local	5325	F69I7PzWOKio6t6FZdQ2nQ==	2023-11-24 06:42:28.833614
387	acc0iix2d90sjymbdfzssnarwo9l	user_1の献立の画像	image/png	{"identified":true,"width":1778,"height":486,"analyzed":true}	local	886522	ApjEN1ogx9CTUvIiHXwfQg==	2023-12-06 07:40:04.287923
159	xgiqevffzdlu2sd1lm377k5xaw5p	user_1の献立の画像	image/jpeg	{"identified":true,"width":500,"height":500,"analyzed":true}	local	90449	TChT2dbbAsoeaLkq7XGY5g==	2023-11-24 09:06:50.262423
160	t6eawmenn8o249ce5f8t9wdwcvxm	user_1の献立の画像.jpeg	image/jpeg	{"identified":true,"width":200,"height":200,"analyzed":true}	local	51640	MOkJuUnXXNW9LhuZGvCNWg==	2023-11-24 09:06:51.007833
388	ftyuhdoo13poyjluwhflb5227u64	user_1の献立の画像.png	image/png	{"identified":true,"width":220,"height":190,"analyzed":true}	local	48992	Z9DP+KpZngaJiNutUgjoCg==	2023-12-06 07:40:05.524775
449	vty1kesxwde1bvt39jrzn7ky2pyp	default-menu-icon.png	image/jpeg	{"identified":true,"width":1080,"height":1080,"analyzed":true}	local	42433	Bos7l7mcbGNOGZPbRzeoWw==	2023-12-08 11:01:26.726187
315	ho20h4ad5e7f7eeox93sstdt0bi5	user_1の献立の画像	image/jpeg	{"identified":true,"width":1080,"height":1080,"analyzed":true}	local	42433	Bos7l7mcbGNOGZPbRzeoWw==	2023-12-01 09:43:50.355837
317	9tapog4vzki572jb1pysmfpnu4u0	user_1の献立の画像.jpeg	image/jpeg	{"identified":true,"width":220,"height":190,"analyzed":true}	local	17865	dD3Ch+Sv8O8mewqjvVRPkA==	2023-12-01 09:49:44.060934
354	w9tpro0s29zckui8acg9ckl8rqnp	user_1の献立の画像	image/jpeg	{"identified":true,"width":1080,"height":1080,"analyzed":true}	local	42433	Bos7l7mcbGNOGZPbRzeoWw==	2023-12-01 10:56:08.09812
425	g2lpgxdn1qlzu8x0hzojh6vz80yv	user_1の献立の画像	image/png	{"identified":true,"width":996,"height":670,"analyzed":true}	local	1114933	BuTF6lvIQBMBV/pNI8/xAQ==	2023-12-07 08:30:49.284936
450	mtdvnnwqeupobm3dzljulpg83xf4	default-menu-icon.jpeg	image/jpeg	{"identified":true,"width":220,"height":190,"analyzed":true}	local	5788	9u+BOZk1TP9Q4XPrVg83gQ==	2023-12-08 11:01:27.412203
451	38jltybzrlear2t93mcu4en82p04	default-menu-icon.png	image/jpeg	{"identified":true,"width":1080,"height":1080,"analyzed":true}	local	42433	Bos7l7mcbGNOGZPbRzeoWw==	2023-12-08 11:02:50.510615
444	125gmrn3h65fysauxfbzawkrug58	user_1の献立の画像.png	image/png	{"identified":true,"width":80,"height":80,"analyzed":true}	local	22702	hcaZRm7/zeXgDkjm5pG8yQ==	2023-12-08 07:42:40.143165
369	bljdcyeaankz0eb7p78vj0xgb8g7	YATsan1203428.jpg	image/jpeg	{"identified":true,"width":6299,"height":3724,"analyzed":true}	local	6805613	UePRjF2129qY4I+tuL/dIA==	2023-12-01 13:07:00.956829
370	t1wbpd2w6b7hbs1uqdmxtx9mm9l4	YATsan1203428.jpg	image/jpeg	{"identified":true,"width":220,"height":190,"analyzed":true}	local	67396	wmH5QZAfVR1iMQ48Cj8cyg==	2023-12-01 13:07:03.752029
371	vqb8250eme1o2xi1gmaxktphyyxv	user_1の献立の画像	image/jpeg	{"identified":true,"width":6000,"height":4000,"analyzed":true}	local	1371786	KJjx+Dy5JGahBRDKkzd/rA==	2023-12-01 13:07:49.635413
384	4xro504jvam4jyn8cclvagf6cmpa	default-menu-icon.jpeg	image/jpeg	{"identified":true,"width":220,"height":190,"analyzed":true}	local	5788	9u+BOZk1TP9Q4XPrVg83gQ==	2023-12-06 06:09:08.766229
389	w396x2z9yfxnhyouf6mbki25nv9g	user_1の献立の画像	image/png	{"identified":true,"width":786,"height":714,"analyzed":true}	local	719892	q5nhzBxdJZV2nxR+wt3uLA==	2023-12-06 07:58:36.196217
452	6zl6o2zpg036st5qq4jsqhwg6xew	default-menu-icon.jpeg	image/jpeg	{"identified":true,"width":220,"height":190,"analyzed":true}	local	5788	9u+BOZk1TP9Q4XPrVg83gQ==	2023-12-08 11:02:51.28635
405	xqs2tn262axfj3suy4u87oeh28wp	user_1の献立の画像.png	image/png	{"identified":true,"width":220,"height":190,"analyzed":true}	local	92983	qHLYWY4wMmU/881bJXnBXQ==	2023-12-07 04:34:16.892425
316	7okv0t1ggs7k6i1lenuj4m9ounau	user_1の献立の画像	image/jpeg	{"identified":true,"width":800,"height":800,"analyzed":true}	local	126363	1dvgOsPJPFWVidUZCA4/uw==	2023-12-01 09:49:42.953385
453	e5e4v717kbca3rik48trswbnc7f6	default-menu-icon.jpeg	image/jpeg	{"identified":true,"width":80,"height":80,"analyzed":true}	local	2667	PHwLt3MUTvlYSYFk3Ggj8w==	2023-12-08 11:02:58.312199
322	6skef31cyhfg41dk3ucvnwc48snv	user_1の献立の画像	image/jpeg	{"identified":true,"width":1920,"height":1440,"analyzed":true}	local	1579696	rjseNombSA8+IQ1SNGyoTg==	2023-12-01 09:52:25.468755
323	f7ogya8mb6h1ebd4s9a5eczk6d7b	user_1の献立の画像.jpeg	image/jpeg	{"identified":true,"width":220,"height":190,"analyzed":true}	local	41437	ahCglUxyU0jUg0QNkxOzQw==	2023-12-01 09:52:27.005486
445	u2qc4pljwy6myhqqdxt57h9lssxq	user_1の献立の画像.png	image/png	{"identified":true,"width":80,"height":80,"analyzed":true}	local	23457	T6zENQqEZKl33vbOsKF0ww==	2023-12-08 07:42:40.262843
372	2s6eh86qowb5bw6hcl3vip1rw2tf	user_1の献立の画像.jpeg	image/jpeg	{"identified":true,"width":220,"height":190,"analyzed":true}	local	5866	kHEEOzkQluzdJPuDcLPMJA==	2023-12-01 13:07:57.110653
385	1c6f62dqopw6wmxcvh4xyyaf7p2m	user_1の献立の画像	image/png	{"identified":true,"width":838,"height":198,"analyzed":true}	local	19959	tnqJAShOSBvokxwmS2pVNw==	2023-12-06 06:44:59.737406
390	efqrdt23irwsun3djtd6leelz37i	user_1の献立の画像.png	image/png	{"identified":true,"width":220,"height":190,"analyzed":true}	local	63381	v99ANnG+24eC9oogjSMrWg==	2023-12-06 07:58:37.383078
373	q89r6nsvxuof7lcpig9mtkr6sh4m	user_1の献立の画像	image/png	{"identified":true,"width":410,"height":640,"analyzed":true}	local	188194	pvDhVwkEWVGove4YfVfq6g==	2023-12-01 13:34:56.478106
386	rhidnik6kqd4yzz3l8h85yx8k5yn	user_1の献立の画像.png	image/png	{"identified":true,"width":220,"height":190,"analyzed":true}	local	6556	BrKe9GN9MHmDtE/+9wsLwg==	2023-12-06 06:45:01.603835
454	zxcvg7q002syangi4wpnk6pk0wz4	default-menu-icon.png	image/jpeg	{"identified":true,"width":1080,"height":1080,"analyzed":true}	local	42433	Bos7l7mcbGNOGZPbRzeoWw==	2023-12-08 11:47:07.295049
402	876ics97kqcsc0d3tojghtq2bjvv	user_1の献立の画像	image/png	{"identified":true,"width":994,"height":654,"analyzed":true}	local	1068415	Kt9gHQlqwKyvy2aEEOrP/g==	2023-12-07 04:33:36.794979
403	0qbl0awx6dar552wsok8mah6toum	user_1の献立の画像.png	image/png	{"identified":true,"width":220,"height":190,"analyzed":true}	local	88353	gW0v2VtASvIAA47vxYJw/Q==	2023-12-07 04:33:37.329696
404	qzckxtjh4l0houqc573yggei43ih	user_1の献立の画像	image/png	{"identified":true,"width":1070,"height":668,"analyzed":true}	local	1199398	eCF8ZnmulWk6z+fZviXTvw==	2023-12-07 04:34:15.815562
455	uo2r7fkm9xjtlzh7tgtk9jbk5ch9	default-menu-icon.jpeg	image/jpeg	{"identified":true,"width":220,"height":190,"analyzed":true}	local	5788	9u+BOZk1TP9Q4XPrVg83gQ==	2023-12-08 11:47:08.141586
431	0xl7gpnji52g0bbhii1kb0nu1tv9	user_1の献立の画像	image/png	{"identified":true,"width":1070,"height":668,"analyzed":true}	local	1199398	eCF8ZnmulWk6z+fZviXTvw==	2023-12-07 08:46:02.979096
446	esupetkxbqfmi9ls723lbk1q1hhn	user_1の献立の画像.jpeg	image/jpeg	{"identified":true,"width":80,"height":80,"analyzed":true}	local	2667	PHwLt3MUTvlYSYFk3Ggj8w==	2023-12-08 10:39:02.131365
462	f9e7q95zyvjwutqn3vhf55gx9wmp	user_1の献立の画像.png	image/png	{"identified":true,"width":80,"height":80,"analyzed":true}	local	22702	x2V1575FjqjezSIvw8Msfw==	2023-12-10 05:00:51.895171
464	iiczr02qybu9ms8kr6tjel25n0w6	user_1の献立の画像.png	image/png	{"identified":true,"width":200,"height":190,"analyzed":true}	local	85174	2OvzMM3UorsYtJTvd4S7bQ==	2023-12-13 03:20:06.933854
465	s4mspitxk2e7m6o18kw40uqjycti	user_1の献立の画像.png	image/png	{"identified":true,"width":220,"height":150,"analyzed":true}	local	77287	q5o6uOTH/B4Dxn8rmQQ2yQ==	2023-12-13 03:20:17.11764
471	ychhbnmxzqgnrevw7atrucdw4yx4	user_1の献立の画像	image/png	{"identified":true,"width":888,"height":716,"analyzed":true}	local	1117813	DNU8cKA9OcV3tIUDIzXMcA==	2023-12-18 06:38:25.489652
472	jea6nbpoa9w6xo5smm20fwlce8qx	user_1の献立の画像.png	image/png	{"identified":true,"width":220,"height":190,"analyzed":true}	local	94089	DXrR5kZjWkBwCswi61KjDw==	2023-12-18 06:38:26.202409
345	5donmqu0ygmwf91rh3tytnib13bk	user_1の献立の画像.jpeg	image/jpeg	{"identified":true,"width":220,"height":190,"analyzed":true}	local	6672	4YSkGFXvpjUHNo6/XFv03Q==	2023-12-01 10:05:04.529313
324	hx7uulpd54d2hkwmahu0jr4m38lz	user_1の献立の画像	image/jpeg	{"identified":true,"width":3357,"height":3024,"analyzed":true}	local	3913253	Bm5G+Jvk4eCcpDij7K4SrA==	2023-12-01 09:53:07.093483
325	pdjo3veujoxgusrphb23qwkbilzm	user_1の献立の画像.jpeg	image/jpeg	{"identified":true,"width":220,"height":190,"analyzed":true}	local	32390	p+GroA6p4m1yCqyF3hcbgA==	2023-12-01 09:53:10.292813
355	0i55gvao8370mowfm6j9bbm07x5v	user_1の献立の画像.jpeg	image/jpeg	{"identified":true,"width":220,"height":190,"analyzed":true}	local	5788	9u+BOZk1TP9Q4XPrVg83gQ==	2023-12-01 10:56:08.858753
391	4mtxgh7v4jswldtz5q06eomx64yb	user_1の献立の画像	image/png	{"identified":true,"width":2782,"height":1106,"analyzed":true}	local	4068888	gQIiygFZb/uIBrwXyAqyQA==	2023-12-06 08:06:12.700831
406	by5r2srcfdh1mpffvakmww8tkkz1	user_1の献立の画像	image/png	{"identified":true,"width":936,"height":740,"analyzed":true}	local	1133185	o9tHA24VJEfrl8nd9QNovQ==	2023-12-07 04:38:11.973176
330	zjshvinjqfg39za6wage7c9k0x0v	user_1の献立の画像.png	image/png	{"identified":true,"width":220,"height":190,"analyzed":true}	local	2764	8pHxHARnrz1MjcEI/fuFYg==	2023-12-01 09:56:37.297055
331	bo3or4i5jtpxjwng36lse2d53m64	user_1の献立の画像	image/jpeg	{"identified":true,"width":2959,"height":2448,"analyzed":true}	local	2267067	Vu0WzWlbegV2H8xkRDpX/g==	2023-12-01 09:57:16.692331
432	taf73y4h9u0lulg2p4pmsdyrrwkw	user_1の献立の画像.png	image/png	{"identified":true,"width":220,"height":190,"analyzed":true}	local	92983	LxYM/ZZ+BxCQcOz+gY83qQ==	2023-12-07 08:46:04.362231
374	2ytbov6jq09g0crihzqzxvh4r4ui	user_1の献立の画像.png	image/png	{"identified":true,"width":220,"height":190,"analyzed":true}	local	24545	oLLiUnTuIQe3XinbA06OPQ==	2023-12-01 13:35:02.624651
342	b7sw8h7qlqcnqihh843i5keo6pcr	user_1の献立の画像.jpeg	image/jpeg	{"identified":true,"width":220,"height":190,"analyzed":true}	local	22885	xKt12YtvI2eMYkH+I3dPjg==	2023-12-01 10:04:48.475471
344	afsbha7liurt4kpycd5bx5c627re	user_1の献立の画像	image/jpeg	{"identified":true,"width":252,"height":200,"analyzed":true}	local	6920	NlQsV7EhgTVs6AS0lVEOtg==	2023-12-01 10:05:03.375854
447	qrty8hclvpdk2iggo3pm1bxgd4lo	user_1の献立の画像.png	image/png	{"identified":true,"width":80,"height":80,"analyzed":true}	local	22391	AGnPujaUfZyuO4Kx19NfSw==	2023-12-08 10:39:02.151498
456	471qpowdqf22x5na39826zxv29kx	default-menu-icon.png	image/jpeg	{"identified":true,"width":1080,"height":1080,"analyzed":true}	local	42433	Bos7l7mcbGNOGZPbRzeoWw==	2023-12-08 11:49:16.731056
458	2lmuujxjzzrteyhvy9v0pnfhh2q5	default-menu-icon.png	image/jpeg	{"identified":true,"width":1080,"height":1080,"analyzed":true}	local	42433	Bos7l7mcbGNOGZPbRzeoWw==	2023-12-08 11:49:43.974495
463	g2ddgn60yl581xsz61oaub2bgo04	user_1の献立の画像.png	image/png	{"identified":true,"width":80,"height":80,"analyzed":true}	local	22368	BVLYxuPwkNhF6Ri3xdRokQ==	2023-12-10 08:16:32.09962
466	riyoy6pchwpupwvhp31gbi5uzsaw	user_1の献立の画像	image/png	{"identified":true,"width":1028,"height":780,"analyzed":true}	local	1787261	Gumc92E1cgameN2eEhD7RA==	2023-12-13 06:45:16.216194
467	zhzew7nmbktabah0sftb4ympa2p3	user_1の献立の画像.png	image/png	{"identified":true,"width":220,"height":190,"analyzed":true}	local	101995	r6suiTz2UtKgQhUQj0wN2g==	2023-12-13 06:45:16.901374
473	y46yehwu4z9mwdotkzrc4i0l2huc	user_1の献立の画像.png	image/png	{"identified":true,"width":80,"height":80,"analyzed":true}	local	22368	4wcoAoU8oyh2jO0k7qazog==	2023-12-18 10:50:34.243441
392	4h4774tthnsiwwvj5x6auliiz16b	user_1の献立の画像.png	image/png	{"identified":true,"width":220,"height":190,"analyzed":true}	local	61645	PcNjGyoGWPZFhEyRWJlNEA==	2023-12-06 08:06:14.009717
375	lirgsnevr9k3kjkwunhkuzn9bbes	user_1の献立の画像	image/jpeg	{"identified":true,"width":3357,"height":3024,"analyzed":true}	local	3913253	Bm5G+Jvk4eCcpDij7K4SrA==	2023-12-04 08:42:16.908423
393	xah8f8lfadkqhswrtxvrvgbpus7r	user_1の献立の画像	image/png	{"identified":true,"width":922,"height":478,"analyzed":true}	local	408841	vukfonrd9YdcOzfXMnkJdA==	2023-12-06 08:14:46.204591
329	ifzm0i9wnf40j4i48t9g8dqrpwzp	user_1の献立の画像	image/png	{"identified":true,"width":1080,"height":1080,"analyzed":true}	local	19971	ioUsdNqP2osHwAd6S1mT0Q==	2023-12-01 09:56:36.657466
407	d6wf9rs1h46ukm93q0jrjoxlmozv	user_1の献立の画像	image/png	{"identified":true,"width":1070,"height":668,"analyzed":true}	local	1199398	eCF8ZnmulWk6z+fZviXTvw==	2023-12-07 04:47:38.197461
410	u5ld7bz60uiewheceefy0usq96cu	user_1の献立の画像.png	image/png	{"identified":true,"width":220,"height":190,"analyzed":true}	local	88353	7LpTZn9+mkehrj1qDbIifA==	2023-12-07 04:50:03.993193
411	ddsmxj6rm0b7wlyhkwkecy7rgzuh	user_1の献立の画像	image/png	{"identified":true,"width":996,"height":670,"analyzed":true}	local	1114933	BuTF6lvIQBMBV/pNI8/xAQ==	2023-12-07 04:51:24.60714
413	cfw7o7kx9jixxhduwb8w71ueq6qv	user_1の献立の画像	image/png	{"identified":true,"width":888,"height":716,"analyzed":true}	local	1117813	DNU8cKA9OcV3tIUDIzXMcA==	2023-12-07 04:55:25.417007
414	98gdb4vqfyzx3df7n1i6dwt6m6uh	user_1の献立の画像.png	image/png	{"identified":true,"width":220,"height":190,"analyzed":true}	local	94089	PJLHDTlfmf+3JfSfD3SwQA==	2023-12-07 04:55:35.859971
457	8wxdir7h4947h41fdz5qp3z2f5y6	default-menu-icon.jpeg	image/jpeg	{"identified":true,"width":220,"height":190,"analyzed":true}	local	5788	9u+BOZk1TP9Q4XPrVg83gQ==	2023-12-08 11:49:17.355514
459	e2d5li4rx0874nd8njr075vr571g	default-menu-icon.jpeg	image/jpeg	{"identified":true,"width":220,"height":190,"analyzed":true}	local	5788	9u+BOZk1TP9Q4XPrVg83gQ==	2023-12-08 11:49:44.576928
468	hryim1ajzhzuqwlv0z9m08w52zaw	user_1の献立の画像.png	image/png	{"identified":true,"width":80,"height":80,"analyzed":true}	local	23262	QidJV086Nx9ceCOGlsbLPQ==	2023-12-13 08:16:01.54076
433	u1r2rgeb7cdfktkk6ugosuk1u9th	user_1の献立の画像	image/jpeg	{"identified":true,"width":1080,"height":1080,"analyzed":true}	local	42433	Bos7l7mcbGNOGZPbRzeoWw==	2023-12-07 11:13:25.142596
448	i5zek10103u8w6mthgno07j93y2v	user_1の献立の画像.png	image/png	{"identified":true,"width":80,"height":80,"analyzed":true}	local	23457	VQ6RkAJX8yicluMpnMUVsQ==	2023-12-08 10:39:02.18366
332	v4yynpsi7xlwbj9agz01pq0zm4of	user_1の献立の画像.jpeg	image/jpeg	{"identified":true,"width":220,"height":190,"analyzed":true}	local	32218	ZuM8KFXFBuq0vFvLiQapgw==	2023-12-01 09:57:18.918918
394	udmf2ll5t9vofb8ws8l7e3oe6vev	user_1の献立の画像.png	image/png	{"identified":true,"width":220,"height":190,"analyzed":true}	local	41596	NkE+XLNfMPVoqmJSjTvesw==	2023-12-06 08:14:47.183629
333	ba9kiuxrogokb5jzcjdbtlodlj5v	user_1の献立の画像	image/jpeg	{"identified":true,"width":1080,"height":1080,"analyzed":true}	local	42433	Bos7l7mcbGNOGZPbRzeoWw==	2023-12-01 09:58:22.936991
334	e3t5lus54rsfz5k3u2a6ect0hlpf	user_1の献立の画像.jpeg	image/jpeg	{"identified":true,"width":220,"height":190,"analyzed":true}	local	5788	9u+BOZk1TP9Q4XPrVg83gQ==	2023-12-01 09:58:23.483973
338	0doqt2u58gsb4f2h1rxqy20f7xe5	user_1の献立の画像	image/jpeg	{"identified":true,"width":1080,"height":1080,"analyzed":true}	local	42433	Bos7l7mcbGNOGZPbRzeoWw==	2023-12-01 10:03:00.503205
339	zd59j4e571xj8y0shzny7aa870fo	user_1の献立の画像.jpeg	image/jpeg	{"identified":true,"width":220,"height":190,"analyzed":true}	local	5788	9u+BOZk1TP9Q4XPrVg83gQ==	2023-12-01 10:03:21.17573
340	rmowe4a0aj9fisqkww9g11tc8gnq	user_1の献立の画像	image/jpeg	{"identified":true,"width":1080,"height":1080,"analyzed":true}	local	42433	Bos7l7mcbGNOGZPbRzeoWw==	2023-12-01 10:04:13.937014
341	5suiaudxt8h0mpshdkcainkbh6y8	user_1の献立の画像.jpeg	image/jpeg	{"identified":true,"width":220,"height":190,"analyzed":true}	local	5788	9u+BOZk1TP9Q4XPrVg83gQ==	2023-12-01 10:04:14.591781
408	pu7ykzd7rrd9imjmiw0uox69vkpz	user_1の献立の画像.png	image/png	{"identified":true,"width":220,"height":190,"analyzed":true}	local	92983	eq1zqwfLcT/msBuRZwi7dA==	2023-12-07 04:47:43.137376
376	i7sc7j18pxf33jevdei58ks91v0q	user_1の献立の画像.jpeg	image/jpeg	{"identified":true,"width":220,"height":190,"analyzed":true}	local	32390	p+GroA6p4m1yCqyF3hcbgA==	2023-12-04 13:59:37.086442
409	0lir0z6qanp1jls7vxgqdkjiojim	user_1の献立の画像	image/png	{"identified":true,"width":994,"height":654,"analyzed":true}	local	1068415	Kt9gHQlqwKyvy2aEEOrP/g==	2023-12-07 04:49:58.258347
412	183vschkhyq6azljs0ebn3v9eccy	user_1の献立の画像.png	image/png	{"identified":true,"width":220,"height":190,"analyzed":true}	local	95980	xEI1hkDVNq6FVWG6nHc+AQ==	2023-12-07 04:51:33.245683
434	s8walw2x7angpib60wrpt27dd1pf	user_1の献立の画像.jpeg	image/jpeg	{"identified":true,"width":220,"height":190,"analyzed":true}	local	5788	9u+BOZk1TP9Q4XPrVg83gQ==	2023-12-07 11:13:25.722281
460	7yb0gtbq4ihxciq4squkj6f2jvky	default-menu-icon.jpeg	image/jpeg	{"identified":true,"width":80,"height":80,"analyzed":true}	local	2667	PHwLt3MUTvlYSYFk3Ggj8w==	2023-12-08 13:33:46.426625
469	8nrm50gcxgbiojgmtsdj45ckutft	default-menu-icon.jpeg	image/jpeg	{"identified":true,"width":80,"height":80,"analyzed":true}	local	2667	PHwLt3MUTvlYSYFk3Ggj8w==	2023-12-13 08:16:01.545593
395	dsqub2xts7wlweszmnlit5avi1ke	user_1の献立の画像	image/jpeg	{"identified":true,"width":252,"height":200,"analyzed":true}	local	6920	NlQsV7EhgTVs6AS0lVEOtg==	2023-12-06 09:44:29.768597
343	iwxshatw0ei2zsi2t718x3kzoy64	user_1の献立の画像.jpeg	image/jpeg	{"identified":true,"width":220,"height":190,"analyzed":true}	local	5788	9u+BOZk1TP9Q4XPrVg83gQ==	2023-12-01 10:04:49.520653
377	xqkpg169mf7zomp3qhxudyz8k0jb	user_1の献立の画像	image/jpeg	{"identified":true,"width":500,"height":500,"analyzed":true}	local	90449	TChT2dbbAsoeaLkq7XGY5g==	2023-12-06 01:31:31.340087
380	mvku66dnlsy93brl65qff2b9jbg7	user_1の献立の画像.jpeg	image/jpeg	{"identified":true,"width":220,"height":190,"analyzed":true}	local	53017	9b9kDe3X9pzkyjExTvVNHQ==	2023-12-06 01:35:24.35671
396	qq6o90q1qxts9k9xqmegt2rwr686	user_1の献立の画像.jpeg	image/jpeg	{"identified":true,"width":220,"height":190,"analyzed":true}	local	6672	4YSkGFXvpjUHNo6/XFv03Q==	2023-12-06 09:44:30.808663
461	010u5f9ib7eo807g9cf7x5t17inv	default-menu-icon.jpeg	image/jpeg	{"identified":true,"width":80,"height":80,"analyzed":true}	local	2667	PHwLt3MUTvlYSYFk3Ggj8w==	2023-12-08 13:33:46.431552
435	0wg0jrfddsqest51dm6yrb0wojhk	default-menu-icon.png	image/jpeg	{"identified":true,"width":1080,"height":1080,"analyzed":true}	local	42433	Bos7l7mcbGNOGZPbRzeoWw==	2023-12-07 12:15:57.194298
436	1gg84kozb241u4rk58x5ffl731my	default-menu-icon.jpeg	image/jpeg	{"identified":true,"width":220,"height":190,"analyzed":true}	local	5788	9u+BOZk1TP9Q4XPrVg83gQ==	2023-12-07 12:16:02.059051
470	s1sgsv9961crgrnyp4js5sthchdw	default-menu-icon.jpeg	image/jpeg	{"identified":true,"width":80,"height":80,"analyzed":true}	local	2667	PHwLt3MUTvlYSYFk3Ggj8w==	2023-12-14 11:16:21.251047
397	jpg34kvb1w2pfont3kmbe9vakqcu	user_1の献立の画像	image/png	{"identified":true,"width":786,"height":714,"analyzed":true}	local	719892	q5nhzBxdJZV2nxR+wt3uLA==	2023-12-06 09:56:48.866896
378	ddq2hx9aggjhl0wterxq1bhje9do	user_1の献立の画像	image/jpeg	{"identified":true,"width":500,"height":500,"analyzed":true}	local	90449	TChT2dbbAsoeaLkq7XGY5g==	2023-12-06 01:35:21.221865
379	60gc1ygwytkr38f8t5ucdoj70qiz	user_1の献立の画像.jpeg	image/jpeg	{"identified":true,"width":220,"height":190,"analyzed":true}	local	53017	9b9kDe3X9pzkyjExTvVNHQ==	2023-12-06 01:35:23.955722
437	k0erfn1wgimw8w2q9roxbdj2l44e	user_1の献立の画像.png	image/png	{"identified":true,"width":100,"height":100,"analyzed":true}	local	31868	ydzbJMsSJ5b7pkghLX6utw==	2023-12-08 07:33:34.079506
440	psa7e9xdeh48qd25gl6btovf6fm1	default-menu-icon.jpeg	image/jpeg	{"identified":true,"width":60,"height":60,"analyzed":true}	local	2407	n0Zdv5xdEsOp6lVhfLIPnA==	2023-12-08 07:36:34.872424
367	61ge1lzbp9nsix7w9bfi11d22020	89CBBE63-E34D-4797-88DD-8CE7FFA7E9B5 2.JPG	image/jpeg	{"identified":true,"width":3357,"height":3024,"analyzed":true}	local	3913253	Bm5G+Jvk4eCcpDij7K4SrA==	2023-12-01 12:02:59.440167
381	ne1tky2nuhn5cd44af9ilkabcfgj	default-menu-icon.png	image/jpeg	{"identified":true,"width":1080,"height":1080,"analyzed":true}	local	42433	Bos7l7mcbGNOGZPbRzeoWw==	2023-12-06 05:30:04.322756
382	x93ngpiylhr93r0nvmygt4y76t07	default-menu-icon.jpeg	image/jpeg	{"identified":true,"width":220,"height":190,"analyzed":true}	local	5788	9u+BOZk1TP9Q4XPrVg83gQ==	2023-12-06 05:30:09.872261
398	co10wb1kzuw0xuplel59rqcfhygf	user_1の献立の画像	image/jpeg	{"identified":true,"width":800,"height":800,"analyzed":true}	local	126363	1dvgOsPJPFWVidUZCA4/uw==	2023-12-06 10:07:00.839843
399	oflliglabwq2wd2cei1qg64v9eeb	user_1の献立の画像.jpeg	image/jpeg	{"identified":true,"width":220,"height":190,"analyzed":true}	local	17865	dD3Ch+Sv8O8mewqjvVRPkA==	2023-12-06 10:07:01.617042
438	dv7r4qllrc26ybf1sbv64couk72p	default-menu-icon.jpeg	image/jpeg	{"identified":true,"width":100,"height":100,"analyzed":true}	local	3229	54dNyUbU6PNxcpBuNLj77w==	2023-12-08 07:33:34.124508
442	m1xb32esvpmimjshc6us98y3l5gz	user_1の献立の画像.png	image/png	{"identified":true,"width":60,"height":60,"analyzed":true}	local	16268	fBe36ImiC57MgLv61P1jGw==	2023-12-08 07:36:35.432441
443	5kdp9bo26ghz8y59w2ktv3vp9e6v	default-menu-icon.jpeg	image/jpeg	{"identified":true,"width":80,"height":80,"analyzed":true}	local	2667	PHwLt3MUTvlYSYFk3Ggj8w==	2023-12-08 07:42:39.93771
280	fj10nn05ud9dyh02bh66drys53i3	user_1の献立の画像	image/jpeg	{"identified":true,"width":1440,"height":1436,"analyzed":true}	local	328087	BpLYJv0tCZsyv6e/49fwVg==	2023-11-29 10:18:35.989227
281	522jbyu1tzo7yh9uyp5wzozpf3qm	user_1の献立の画像.jpeg	image/jpeg	{"identified":true,"width":220,"height":190,"analyzed":true}	local	19237	r2HIk6L2mTxpRkbLzdXgdg==	2023-11-29 10:18:48.886399
282	y4twm2pmvsks4yvg2q55obaw7m7d	user_1の献立の画像	image/jpeg	{"identified":true,"width":640,"height":427,"analyzed":true}	local	246912	E+yM6wCg1ZGAI8hQNdPX7g==	2023-11-30 11:07:36.405157
283	2ul0reat71y877tgjozdt1i614m7	user_1の献立の画像.jpeg	image/jpeg	{"identified":true,"width":220,"height":190,"analyzed":true}	local	41821	PPzvwf1qYyxq6wk+SJBGGQ==	2023-11-30 11:07:43.031396
284	4kmcdfqpnopixocsuv1okhg55yef	user_1の献立の画像	image/jpeg	{"identified":true,"width":1280,"height":1280,"analyzed":true}	local	550364	juhjVGkwcS46vjamlnYtjA==	2023-11-30 11:25:26.253289
285	anrzkwgzvr3luyemmf1q0rhrqs75	user_1の献立の画像	image/jpeg	{"identified":true,"width":1600,"height":1200,"analyzed":true}	local	1091855	NWpGMdnQdJT5Jc+aLc+a2A==	2023-11-30 11:26:27.358454
426	t4hzz6j14js06paqcw59thqncxlb	user_1の献立の画像.png	image/png	{"identified":true,"width":220,"height":190,"analyzed":true}	local	95980	3SOHEfyVzN+BtP+KsaVIrA==	2023-12-07 08:30:50.541427
288	vldxnb8uaqdftwtfyp1hjtnoeczo	user_1の献立の画像.jpeg	image/jpeg	{"identified":true,"width":220,"height":190,"analyzed":true}	local	22885	xKt12YtvI2eMYkH+I3dPjg==	2023-11-30 11:39:57.674376
289	89ps5as76wwuaocn7x02hvmt1eq6	user_1の献立の画像.jpeg	image/jpeg	{"identified":true,"width":220,"height":190,"analyzed":true}	local	51315	U1uGQGQQDqvhKOtUjyYcQA==	2023-11-30 11:39:57.827504
290	epfh8h492055hl87nr9rggbm05ch	user_1の献立の画像	image/jpeg	{"identified":true,"width":1280,"height":1280,"analyzed":true}	local	436386	zRr2vHCMhMAL+uom63Clqw==	2023-12-01 04:05:02.886361
291	r0uwju2dvrnw5ebc2e3ooijjw8wp	user_1の献立の画像.jpeg	image/jpeg	{"identified":true,"width":220,"height":190,"analyzed":true}	local	41163	XjNdHicceeFE8x2+RvztaQ==	2023-12-01 04:05:07.791155
292	74a57tu75lqdz91r2jmxz2krpnlp	user_1の献立の画像	image/jpeg	{"identified":true,"width":252,"height":200,"analyzed":true}	local	6920	NlQsV7EhgTVs6AS0lVEOtg==	2023-12-01 04:05:49.137997
293	to2vrooh8qfft9l3hebbx9y4fzvn	user_1の献立の画像.jpeg	image/jpeg	{"identified":true,"width":220,"height":190,"analyzed":true}	local	6672	4YSkGFXvpjUHNo6/XFv03Q==	2023-12-01 04:05:53.206413
368	xgxtqjh6q3lyiog8c1jah75j155m	89CBBE63-E34D-4797-88DD-8CE7FFA7E9B5 2.jpg	image/jpeg	{"identified":true,"width":220,"height":190,"analyzed":true}	local	32390	p+GroA6p4m1yCqyF3hcbgA==	2023-12-01 12:03:00.8388
383	slhgzsgajjsbj3qem18sc99xqa8u	default-menu-icon.png	image/jpeg	{"identified":true,"width":1080,"height":1080,"analyzed":true}	local	42433	Bos7l7mcbGNOGZPbRzeoWw==	2023-12-06 06:08:56.989113
439	r2ruo425lc107iia7hv4x3jw196c	user_1の献立の画像.png	image/png	{"identified":true,"width":100,"height":100,"analyzed":true}	local	30594	GGlVwETMj01rTQYJ8qmoLg==	2023-12-08 07:33:34.17397
441	12jggwqaup3rmqmcpjx02avqvhu7	user_1の献立の画像.png	image/png	{"identified":true,"width":60,"height":60,"analyzed":true}	local	16592	kJNNdPtjfvXpWqOlt2YG0g==	2023-12-08 07:36:35.355252
309	nbrooim5mhpbwax21wbg7u5t825d	user_1の献立の画像	image/png	{"identified":true,"width":2754,"height":1260,"analyzed":true}	local	1611903	ma/VdUBeDsaspEqVRjU3YA==	2023-12-01 09:19:39.700827
310	ghwekpq5cimdauzarx7mj92owkjh	user_1の献立の画像	image/jpeg	{"identified":true,"width":1280,"height":1280,"analyzed":true}	local	550364	juhjVGkwcS46vjamlnYtjA==	2023-12-01 09:21:35.421068
311	899cjje0x6ac7nyazwyasa6aghsk	user_1の献立の画像.png	image/png	{"identified":true,"width":220,"height":190,"analyzed":true}	local	21493	af4D1REkXsq1SdL88Z6dbQ==	2023-12-01 09:22:14.45368
\.


--
-- Data for Name: active_storage_variant_records; Type: TABLE DATA; Schema: public; Owner: apple
--

COPY public.active_storage_variant_records (id, blob_id, variation_digest) FROM stdin;
250	431	4mLDSEtCH5uxE6l0a2qasK0Q5S4=
251	433	jtK5AuqHjFeieYAj0zq4uLRIyP0=
252	435	jtK5AuqHjFeieYAj0zq4uLRIyP0=
253	425	H37FtJrB1nSjfQ+AtTqgXoHvg+M=
254	435	zb4vCT5wC8085pi3RzGKpLqHkaA=
255	431	H37FtJrB1nSjfQ+AtTqgXoHvg+M=
256	435	ebqUw1kcIyoyBE6xcc+ldXCmWrc=
257	425	9d68qSqY/fqYe/E4K8qZX0gZePA=
258	431	9d68qSqY/fqYe/E4K8qZX0gZePA=
259	435	DLhFTxNDPGq3bFmwae0BOGojwsY=
260	431	Ne8iZ/34JGhsEPKDfO4+gm/X7bE=
261	425	Ne8iZ/34JGhsEPKDfO4+gm/X7bE=
262	433	DLhFTxNDPGq3bFmwae0BOGojwsY=
263	409	Ne8iZ/34JGhsEPKDfO4+gm/X7bE=
264	411	Ne8iZ/34JGhsEPKDfO4+gm/X7bE=
265	449	jtK5AuqHjFeieYAj0zq4uLRIyP0=
266	451	jtK5AuqHjFeieYAj0zq4uLRIyP0=
267	451	DLhFTxNDPGq3bFmwae0BOGojwsY=
268	454	jtK5AuqHjFeieYAj0zq4uLRIyP0=
269	456	jtK5AuqHjFeieYAj0zq4uLRIyP0=
270	458	jtK5AuqHjFeieYAj0zq4uLRIyP0=
271	456	DLhFTxNDPGq3bFmwae0BOGojwsY=
272	458	DLhFTxNDPGq3bFmwae0BOGojwsY=
273	407	Ne8iZ/34JGhsEPKDfO4+gm/X7bE=
274	413	Ne8iZ/34JGhsEPKDfO4+gm/X7bE=
275	431	0l2t/FNzsBGZ2hH7QmkEjA9GhbA=
276	431	8vIIQ1H2aokUttxqVKBd2xZhvpM=
277	466	4mLDSEtCH5uxE6l0a2qasK0Q5S4=
278	454	DLhFTxNDPGq3bFmwae0BOGojwsY=
279	466	Ne8iZ/34JGhsEPKDfO4+gm/X7bE=
280	449	DLhFTxNDPGq3bFmwae0BOGojwsY=
281	471	4mLDSEtCH5uxE6l0a2qasK0Q5S4=
282	471	Ne8iZ/34JGhsEPKDfO4+gm/X7bE=
238	407	4mLDSEtCH5uxE6l0a2qasK0Q5S4=
239	409	4mLDSEtCH5uxE6l0a2qasK0Q5S4=
240	411	4mLDSEtCH5uxE6l0a2qasK0Q5S4=
241	413	4mLDSEtCH5uxE6l0a2qasK0Q5S4=
247	425	4mLDSEtCH5uxE6l0a2qasK0Q5S4=
\.


--
-- Data for Name: ar_internal_metadata; Type: TABLE DATA; Schema: public; Owner: apple
--

COPY public.ar_internal_metadata (key, value, created_at, updated_at) FROM stdin;
environment	development	2023-12-07 14:37:12.928678	2023-12-07 14:37:12.928678
\.


--
-- Data for Name: cart_items; Type: TABLE DATA; Schema: public; Owner: apple
--

COPY public.cart_items (id, cart_id, menu_id, item_count, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: carts; Type: TABLE DATA; Schema: public; Owner: apple
--

COPY public.carts (id, user_id, created_at, updated_at) FROM stdin;
4	1	2023-12-14 03:57:17.031608	2023-12-14 03:57:17.031608
\.


--
-- Data for Name: categories; Type: TABLE DATA; Schema: public; Owner: apple
--

COPY public.categories (id, category_name, created_at, updated_at) FROM stdin;
1	肉類	2023-10-23 19:30:32.95884	2023-10-23 19:30:32.95884
2	野菜・果物	2023-10-23 19:30:32.95884	2023-10-23 19:30:32.95884
3	魚介類	2023-10-23 19:30:32.95884	2023-10-23 19:30:32.95884
4	きのこ・山菜	2023-10-23 19:30:32.95884	2023-10-23 19:30:32.95884
5	調味料	2023-10-23 19:30:32.95884	2023-10-23 19:30:32.95884
6	牛乳、卵、大豆製品	2023-10-23 19:30:32.95884	2023-10-23 19:30:32.95884
7	米・麺・粉類・パン	2023-10-23 19:30:32.95884	2023-10-23 19:30:32.95884
8	乾物・海藻	2023-10-23 19:30:32.95884	2023-10-23 19:30:32.95884
9	その他	2023-10-23 19:30:32.95884	2023-10-23 19:30:32.95884
\.


--
-- Data for Name: completed_menus; Type: TABLE DATA; Schema: public; Owner: apple
--

COPY public.completed_menus (id, user_id, menu_id, menu_count, is_completed, date_completed, created_at, updated_at) FROM stdin;
55	1	112	1	t	2023-12-17	2023-12-17 05:47:56.408312	2023-12-17 05:47:56.408312
54	1	112	1	t	2023-12-17	2023-12-17 05:45:22.132031	2023-12-17 05:48:36.191012
57	1	112	1	t	2023-12-17	2023-12-17 06:06:10.285278	2023-12-17 06:06:10.285278
56	1	112	1	t	2023-12-17	2023-12-17 05:55:54.725443	2023-12-17 06:06:15.069221
59	1	112	1	t	2023-12-17	2023-12-17 07:35:08.659158	2023-12-17 07:35:08.659158
58	1	112	1	t	2023-12-17	2023-12-17 06:41:08.114972	2023-12-17 07:38:14.465939
60	1	112	1	t	2023-12-17	2023-12-17 07:39:48.899776	2023-12-17 07:39:53.484672
61	1	112	1	t	2023-12-17	2023-12-17 07:41:05.134439	2023-12-17 07:41:10.222618
64	1	112	1	t	2023-12-17	2023-12-17 10:32:54.915414	2023-12-17 10:32:54.915414
63	1	103	1	t	2023-12-17	2023-12-17 10:32:46.629136	2023-12-17 10:33:24.047649
66	1	105	1	t	2023-12-17	2023-12-17 11:20:43.073785	2023-12-17 11:20:43.073785
67	1	112	1	t	2023-12-18	2023-12-18 10:06:01.671274	2023-12-18 10:06:01.671274
62	1	112	4	f	\N	2023-12-17 10:29:46.784341	2023-12-18 10:50:38.804272
68	1	113	1	f	\N	2023-12-18 10:50:38.812469	2023-12-18 10:50:38.812469
65	1	105	2	f	\N	2023-12-17 11:16:10.551429	2023-12-18 11:02:54.071674
\.


--
-- Data for Name: ingredients; Type: TABLE DATA; Schema: public; Owner: apple
--

COPY public.ingredients (id, material_name, material_id, unit_id, quantity, created_at, updated_at) FROM stdin;
7	赤味噌	269	16	1.0	2023-12-07 08:30:49.919789	2023-12-07 08:30:49.919789
11	ウスターソース	237	1	10.0	2023-12-07 08:46:03.599602	2023-12-07 08:46:03.599602
12	ごま	292	16	1.0	2023-12-07 08:46:03.794996	2023-12-07 08:46:03.794996
13	切り餅	274	5	1.0	2023-12-07 08:46:03.829093	2023-12-07 08:46:03.829093
14	ウスターソース	237	1	0.5	2023-12-07 11:13:25.234383	2023-12-07 11:13:25.234383
15	赤味噌	269	16	1.0	2023-12-07 12:15:57.22547	2023-12-07 12:15:57.22547
16	アオサ	284	1	1.0	2023-12-07 12:15:57.256361	2023-12-07 12:15:57.256361
17	赤味噌	269	16	1.0	2023-12-08 11:01:26.789413	2023-12-08 11:01:26.789413
18	強力粉	278	1	1.0	2023-12-08 11:02:50.56695	2023-12-08 11:02:50.56695
19	ウスターソース	237	1	1.0	2023-12-08 11:47:07.4163	2023-12-08 11:47:07.4163
20	オリーブオイル	253	16	1.0	2023-12-08 11:47:07.502794	2023-12-08 11:47:07.502794
21	こしょう	248	16	1.0	2023-12-08 11:47:07.567281	2023-12-08 11:47:07.567281
22	ウスターソース	237	1	1.0	2023-12-08 11:49:16.784167	2023-12-08 11:49:16.784167
23	オリーブオイル	253	16	1.0	2023-12-08 11:49:16.813028	2023-12-08 11:49:16.813028
24	砂糖	241	1	1.0	2023-12-08 11:49:16.88846	2023-12-08 11:49:16.88846
25	ウスターソース	237	1	1.0	2023-12-08 11:49:44.022466	2023-12-08 11:49:44.022466
26	オリーブオイル	253	16	1.0	2023-12-08 11:49:44.040975	2023-12-08 11:49:44.040975
27	砂糖	241	1	1.0	2023-12-08 11:49:44.107883	2023-12-08 11:49:44.107883
28	エビ	205	7	10.0	2023-12-13 06:45:16.313482	2023-12-13 06:45:16.313482
29	ピーマン	139	5	2.0	2023-12-13 06:45:16.401014	2023-12-13 06:45:16.401014
30	水煮れんこん	165	1	10.0	2023-12-13 06:45:16.42296	2023-12-13 06:45:16.42296
31	強力粉	278	1	1.0	2023-12-18 06:38:25.644392	2023-12-18 06:38:25.644392
\.


--
-- Data for Name: material_units; Type: TABLE DATA; Schema: public; Owner: apple
--

COPY public.material_units (id, material_id, unit_id, conversion_factor, created_at, updated_at) FROM stdin;
1	86	1	1	2023-10-27 18:42:24.582899	2023-10-27 18:42:24.582899
2	87	1	1	2023-10-27 18:42:24.582899	2023-10-27 18:42:24.582899
3	88	1	1	2023-10-27 18:42:24.582899	2023-10-27 18:42:24.582899
4	89	1	1	2023-10-27 18:42:24.582899	2023-10-27 18:42:24.582899
5	87	6	250	2023-10-27 18:42:24.582899	2023-10-27 18:42:24.582899
6	88	6	250	2023-10-27 18:42:24.582899	2023-10-27 18:42:24.582899
7	89	6	55	2023-10-27 18:42:24.582899	2023-10-27 18:42:24.582899
8	90	1	1	2023-10-27 18:42:24.582899	2023-10-27 18:42:24.582899
9	91	1	1	2023-10-27 18:42:24.582899	2023-10-27 18:42:24.582899
10	92	1	1	2023-10-27 18:42:24.582899	2023-10-27 18:42:24.582899
11	93	1	1	2023-10-27 18:42:24.582899	2023-10-27 18:42:24.582899
12	94	1	1	2023-10-27 18:42:24.582899	2023-10-27 18:42:24.582899
13	95	1	1	2023-10-27 18:42:24.582899	2023-10-27 18:42:24.582899
14	96	1	1	2023-10-27 18:42:24.582899	2023-10-27 18:42:24.582899
15	97	1	1	2023-10-27 18:42:35.873727	2023-10-27 18:42:35.873727
16	98	1	1	2023-10-27 18:42:35.873727	2023-10-27 18:42:35.873727
17	99	1	1	2023-10-27 18:42:35.873727	2023-10-27 18:42:35.873727
18	100	1	1	2023-10-27 18:42:35.873727	2023-10-27 18:42:35.873727
19	101	1	1	2023-10-27 18:42:35.873727	2023-10-27 18:42:35.873727
20	101	6	100	2023-10-27 18:42:35.873727	2023-10-27 18:42:35.873727
21	102	1	1	2023-10-27 18:42:35.873727	2023-10-27 18:42:35.873727
22	103	1	1	2023-10-27 18:42:35.873727	2023-10-27 18:42:35.873727
23	104	1	1	2023-10-27 18:42:35.873727	2023-10-27 18:42:35.873727
24	105	1	1	2023-10-27 18:42:35.873727	2023-10-27 18:42:35.873727
25	106	1	1	2023-10-27 18:42:35.873727	2023-10-27 18:42:35.873727
26	107	1	1	2023-10-27 18:42:35.873727	2023-10-27 18:42:35.873727
27	108	1	1	2023-10-27 18:42:35.873727	2023-10-27 18:42:35.873727
28	109	1	1	2023-10-27 18:42:35.873727	2023-10-27 18:42:35.873727
29	109	1	10	2023-10-27 18:42:35.873727	2023-10-27 18:42:35.873727
30	110	1	1	2023-10-27 18:42:35.873727	2023-10-27 18:42:35.873727
31	111	1	1	2023-10-27 18:44:01.180582	2023-10-27 18:44:01.180582
32	112	1	1	2023-10-27 18:44:01.180582	2023-10-27 18:44:01.180582
33	113	11	1	2023-10-27 18:44:01.180582	2023-10-27 18:44:01.180582
34	114	11	1	2023-10-27 18:44:01.180582	2023-10-27 18:44:01.180582
35	115	5	1	2023-10-27 18:44:01.180582	2023-10-27 18:44:01.180582
36	116	5	1	2023-10-27 18:44:01.180582	2023-10-27 18:44:01.180582
37	117	5	1	2023-10-27 18:44:01.180582	2023-10-27 18:44:01.180582
38	118	5	1	2023-10-27 18:44:01.180582	2023-10-27 18:44:01.180582
39	119	5	1	2023-10-27 18:44:01.180582	2023-10-27 18:44:01.180582
40	120	5	1	2023-10-27 18:44:01.180582	2023-10-27 18:44:01.180582
41	121	5	1	2023-10-27 18:44:01.180582	2023-10-27 18:44:01.180582
42	122	11	1	2023-10-27 18:44:01.180582	2023-10-27 18:44:01.180582
43	123	5	1	2023-10-27 18:44:01.180582	2023-10-27 18:44:01.180582
44	124	5	1	2023-10-27 18:44:12.349914	2023-10-27 18:44:12.349914
45	125	5	1	2023-10-27 18:44:12.349914	2023-10-27 18:44:12.349914
46	126	5	1	2023-10-27 18:44:12.349914	2023-10-27 18:44:12.349914
47	127	23	1	2023-10-27 18:44:12.349914	2023-10-27 18:44:12.349914
48	127	13	10	2023-10-27 18:44:12.349914	2023-10-27 18:44:12.349914
49	128	11	1	2023-10-27 18:44:12.349914	2023-10-27 18:44:12.349914
50	129	12	1	2023-10-27 18:44:12.349914	2023-10-27 18:44:12.349914
51	130	13	1	2023-10-27 18:44:12.349914	2023-10-27 18:44:12.349914
52	131	11	7	2023-10-27 18:44:12.349914	2023-10-27 18:44:12.349914
53	131	22	60	2023-10-27 18:44:12.349914	2023-10-27 18:44:12.349914
54	131	12	200	2023-10-27 18:44:12.349914	2023-10-27 18:44:12.349914
55	132	11	6	2023-10-27 18:44:12.349914	2023-10-27 18:44:12.349914
56	132	22	170	2023-10-27 18:44:12.349914	2023-10-27 18:44:12.349914
57	133	23	24	2023-10-27 18:44:19.242282	2023-10-27 18:44:19.242282
58	133	12	230	2023-10-27 18:44:19.242282	2023-10-27 18:44:19.242282
59	134	11	1	2023-10-27 18:44:19.242282	2023-10-27 18:44:19.242282
60	135	5	1	2023-10-27 18:44:19.242282	2023-10-27 18:44:19.242282
61	136	5	19	2023-10-27 18:44:19.242282	2023-10-27 18:44:19.242282
62	136	25	190	2023-10-27 18:44:19.242282	2023-10-27 18:44:19.242282
63	137	1	1	2023-10-27 18:44:19.242282	2023-10-27 18:44:19.242282
64	137	5	645	2023-10-27 18:44:19.242282	2023-10-27 18:44:19.242282
65	137	5	300	2023-10-27 18:44:19.242282	2023-10-27 18:44:19.242282
66	137	6	49	2023-10-27 18:44:19.242282	2023-10-27 18:44:19.242282
67	138	5	1	2023-10-27 18:44:19.242282	2023-10-27 18:44:19.242282
68	139	5	1	2023-10-27 18:44:19.242282	2023-10-27 18:44:19.242282
69	140	25	1	2023-10-27 18:44:19.242282	2023-10-27 18:44:19.242282
70	141	11	100	2023-10-27 18:44:19.242282	2023-10-27 18:44:19.242282
71	141	22	1000	2023-10-27 18:44:19.242282	2023-10-27 18:44:19.242282
72	142	22	1	2023-10-27 18:44:29.077471	2023-10-27 18:44:29.077471
73	143	22	1	2023-10-27 18:44:29.077471	2023-10-27 18:44:29.077471
74	144	11	1	2023-10-27 18:44:29.077471	2023-10-27 18:44:29.077471
75	145	12	1	2023-10-27 18:44:29.077471	2023-10-27 18:44:29.077471
76	146	5	1	2023-10-27 18:44:29.077471	2023-10-27 18:44:29.077471
77	147	5	1	2023-10-27 18:44:29.077471	2023-10-27 18:44:29.077471
78	148	6	18	2023-10-27 18:44:29.077471	2023-10-27 18:44:29.077471
79	148	23	180	2023-10-27 18:44:29.077471	2023-10-27 18:44:29.077471
80	149	11	1	2023-10-27 18:44:29.077471	2023-10-27 18:44:29.077471
81	150	11	1	2023-10-27 18:44:29.077471	2023-10-27 18:44:29.077471
82	151	11	1	2023-10-27 18:44:29.077471	2023-10-27 18:44:29.077471
83	152	5	1	2023-10-27 18:44:29.077471	2023-10-27 18:44:29.077471
84	153	5	1	2023-10-27 18:44:29.077471	2023-10-27 18:44:29.077471
85	154	11	1	2023-10-27 18:44:29.077471	2023-10-27 18:44:29.077471
86	155	11	1	2023-10-27 18:44:29.077471	2023-10-27 18:44:29.077471
87	156	11	1	2023-10-27 18:44:37.189707	2023-10-27 18:44:37.189707
88	157	5	1	2023-10-27 18:44:37.189707	2023-10-27 18:44:37.189707
89	158	5	1	2023-10-27 18:44:37.189707	2023-10-27 18:44:37.189707
90	159	11	1	2023-10-27 18:44:37.189707	2023-10-27 18:44:37.189707
91	160	11	1	2023-10-27 18:44:37.189707	2023-10-27 18:44:37.189707
92	161	11	1	2023-10-27 18:44:37.189707	2023-10-27 18:44:37.189707
93	162	5	1	2023-10-27 18:44:37.189707	2023-10-27 18:44:37.189707
94	163	11	1	2023-10-27 18:44:37.189707	2023-10-27 18:44:37.189707
95	164	11	1	2023-10-27 18:44:37.189707	2023-10-27 18:44:37.189707
96	165	1	1	2023-10-27 18:44:37.189707	2023-10-27 18:44:37.189707
97	166	5	1	2023-10-27 18:44:37.189707	2023-10-27 18:44:37.189707
98	167	6	1	2023-10-27 18:44:37.189707	2023-10-27 18:44:37.189707
99	168	27	1	2023-10-27 18:44:37.189707	2023-10-27 18:44:37.189707
100	169	11	1	2023-10-27 18:44:47.763835	2023-10-27 18:44:47.763835
101	170	19	1	2023-10-27 18:44:47.763835	2023-10-27 18:44:47.763835
102	171	1	1	2023-10-27 18:44:47.763835	2023-10-27 18:44:47.763835
103	172	5	1	2023-10-27 18:44:47.763835	2023-10-27 18:44:47.763835
104	173	5	1	2023-10-27 18:44:47.763835	2023-10-27 18:44:47.763835
105	174	11	1	2023-10-27 18:44:47.763835	2023-10-27 18:44:47.763835
106	175	1	1	2023-10-27 18:44:47.763835	2023-10-27 18:44:47.763835
107	176	1	1	2023-10-27 18:44:47.763835	2023-10-27 18:44:47.763835
108	177	1	1	2023-10-27 18:44:47.763835	2023-10-27 18:44:47.763835
109	178	1	1	2023-10-27 18:44:47.763835	2023-10-27 18:44:47.763835
110	179	1	1	2023-10-27 18:44:47.763835	2023-10-27 18:44:47.763835
111	180	1	1	2023-10-27 18:44:47.763835	2023-10-27 18:44:47.763835
112	181	1	1	2023-10-27 18:44:47.763835	2023-10-27 18:44:47.763835
113	181	12	200	2023-10-27 18:44:47.763835	2023-10-27 18:44:47.763835
114	182	8	1	2023-10-27 18:44:47.763835	2023-10-27 18:44:47.763835
115	183	8	1	2023-10-27 18:44:56.538724	2023-10-27 18:44:56.538724
116	184	6	1	2023-10-27 18:44:56.538724	2023-10-27 18:44:56.538724
117	185	28	1	2023-10-27 18:44:56.538724	2023-10-27 18:44:56.538724
118	186	28	1	2023-10-27 18:44:56.538724	2023-10-27 18:44:56.538724
119	187	7	1	2023-10-27 18:44:56.538724	2023-10-27 18:44:56.538724
120	188	8	1	2023-10-27 18:44:56.538724	2023-10-27 18:44:56.538724
121	189	7	1	2023-10-27 18:44:56.538724	2023-10-27 18:44:56.538724
122	190	8	1	2023-10-27 18:44:56.538724	2023-10-27 18:44:56.538724
123	191	7	1	2023-10-27 18:44:56.538724	2023-10-27 18:44:56.538724
124	192	8	1	2023-10-27 18:44:56.538724	2023-10-27 18:44:56.538724
125	193	7	1	2023-10-27 18:44:56.538724	2023-10-27 18:44:56.538724
126	194	8	1	2023-10-27 18:44:56.538724	2023-10-27 18:44:56.538724
127	195	7	1	2023-10-27 18:44:56.538724	2023-10-27 18:44:56.538724
128	196	8	1	2023-10-27 18:44:56.538724	2023-10-27 18:44:56.538724
129	197	7	1	2023-10-27 18:44:56.538724	2023-10-27 18:44:56.538724
130	198	8	1	2023-10-27 18:45:06.41398	2023-10-27 18:45:06.41398
131	199	7	1	2023-10-27 18:45:06.41398	2023-10-27 18:45:06.41398
132	200	8	1	2023-10-27 18:45:06.41398	2023-10-27 18:45:06.41398
133	201	7	1	2023-10-27 18:45:06.41398	2023-10-27 18:45:06.41398
134	202	8	1	2023-10-27 18:45:06.41398	2023-10-27 18:45:06.41398
135	203	9	1	2023-10-27 18:45:06.41398	2023-10-27 18:45:06.41398
136	204	1	1	2023-10-27 18:45:06.41398	2023-10-27 18:45:06.41398
137	205	7	1	2023-10-27 18:45:06.41398	2023-10-27 18:45:06.41398
138	206	1	1	2023-10-27 18:45:06.41398	2023-10-27 18:45:06.41398
139	207	1	1	2023-10-27 18:45:06.41398	2023-10-27 18:45:06.41398
140	207	9	300	2023-10-27 18:45:06.41398	2023-10-27 18:45:06.41398
141	208	1	1	2023-10-27 18:45:06.41398	2023-10-27 18:45:06.41398
142	209	28	1	2023-10-27 18:45:06.41398	2023-10-27 18:45:06.41398
143	210	1	1	2023-10-27 18:45:06.41398	2023-10-27 18:45:06.41398
144	211	1	1	2023-10-27 18:45:06.41398	2023-10-27 18:45:06.41398
145	212	1	30	2023-10-27 18:45:14.904173	2023-10-27 18:45:14.904173
146	212	5	1	2023-10-27 18:45:14.904173	2023-10-27 18:45:14.904173
147	213	1	30	2023-10-27 18:45:14.904173	2023-10-27 18:45:14.904173
148	213	5	1	2023-10-27 18:45:14.904173	2023-10-27 18:45:14.904173
149	214	5	1	2023-10-27 18:45:14.904173	2023-10-27 18:45:14.904173
150	215	29	1	2023-10-27 18:45:14.904173	2023-10-27 18:45:14.904173
151	216	29	1	2023-10-27 18:45:14.904173	2023-10-27 18:45:14.904173
152	217	15	15	2023-10-27 18:45:14.904173	2023-10-27 18:45:14.904173
153	217	1	1	2023-10-27 18:45:14.904173	2023-10-27 18:45:14.904173
154	218	1	1	2023-10-27 18:45:14.904173	2023-10-27 18:45:14.904173
155	219	1	1	2023-10-27 18:45:14.904173	2023-10-27 18:45:14.904173
156	220	25	1	2023-10-27 18:45:14.904173	2023-10-27 18:45:14.904173
157	221	1	1	2023-10-27 18:45:14.904173	2023-10-27 18:45:14.904173
158	222	25	1	2023-10-27 18:45:14.904173	2023-10-27 18:45:14.904173
159	223	25	1	2023-10-27 18:45:14.904173	2023-10-27 18:45:14.904173
160	224	25	1	2023-10-27 18:45:14.904173	2023-10-27 18:45:14.904173
161	225	25	1	2023-10-27 18:45:23.068163	2023-10-27 18:45:23.068163
162	226	25	1	2023-10-27 18:45:23.068163	2023-10-27 18:45:23.068163
163	227	23	1	2023-10-27 18:45:23.068163	2023-10-27 18:45:23.068163
164	228	23	1	2023-10-27 18:45:23.068163	2023-10-27 18:45:23.068163
165	229	1	1	2023-10-27 18:45:23.068163	2023-10-27 18:45:23.068163
166	230	1	1	2023-10-27 18:45:23.068163	2023-10-27 18:45:23.068163
167	230	25	100	2023-10-27 18:45:23.068163	2023-10-27 18:45:23.068163
168	231	11	1	2023-10-27 18:45:23.068163	2023-10-27 18:45:23.068163
169	232	11	40	2023-10-27 18:45:23.068163	2023-10-27 18:45:23.068163
170	232	25	100	2023-10-27 18:45:23.068163	2023-10-27 18:45:23.068163
171	233	1	20	2023-10-27 18:45:23.068163	2023-10-27 18:45:23.068163
172	233	25	100	2023-10-27 18:45:23.068163	2023-10-27 18:45:23.068163
173	234	1	1	2023-10-27 18:45:23.068163	2023-10-27 18:45:23.068163
174	235	1	1	2023-10-27 18:45:23.068163	2023-10-27 18:45:23.068163
175	236	16	5	2023-10-27 18:45:30.068303	2023-10-27 18:45:30.068303
176	236	15	14	2023-10-27 18:45:30.068303	2023-10-27 18:45:30.068303
177	237	1	1	2023-10-27 18:45:30.068303	2023-10-27 18:45:30.068303
178	237	16	6	2023-10-27 18:45:30.068303	2023-10-27 18:45:30.068303
179	237	15	18	2023-10-27 18:45:30.068303	2023-10-27 18:45:30.068303
180	238	30	3	2023-10-27 18:45:30.068303	2023-10-27 18:45:30.068303
181	238	16	5	2023-10-27 18:45:30.068303	2023-10-27 18:45:30.068303
182	238	15	13	2023-10-27 18:45:30.068303	2023-10-27 18:45:30.068303
183	239	30	3	2023-10-27 18:45:30.068303	2023-10-27 18:45:30.068303
184	239	16	5	2023-10-27 18:45:30.068303	2023-10-27 18:45:30.068303
185	239	15	13	2023-10-27 18:45:30.068303	2023-10-27 18:45:30.068303
186	240	1	1	2023-10-27 18:45:30.068303	2023-10-27 18:45:30.068303
187	240	16	6	2023-10-27 18:45:30.068303	2023-10-27 18:45:30.068303
188	240	15	18	2023-10-27 18:45:30.068303	2023-10-27 18:45:30.068303
189	240	17	1	2023-10-27 18:45:30.068303	2023-10-27 18:45:30.068303
190	241	1	1	2023-10-27 18:45:38.012963	2023-10-27 18:45:38.012963
191	241	16	3	2023-10-27 18:45:38.012963	2023-10-27 18:45:38.012963
192	241	15	9	2023-10-27 18:45:38.012963	2023-10-27 18:45:38.012963
193	241	17	1	2023-10-27 18:45:38.012963	2023-10-27 18:45:38.012963
194	242	1	1	2023-10-27 18:45:38.012963	2023-10-27 18:45:38.012963
195	242	16	5	2023-10-27 18:45:38.012963	2023-10-27 18:45:38.012963
196	242	15	15	2023-10-27 18:45:38.012963	2023-10-27 18:45:38.012963
197	243	1	1	2023-10-27 18:45:38.012963	2023-10-27 18:45:38.012963
198	243	16	5	2023-10-27 18:45:38.012963	2023-10-27 18:45:38.012963
199	243	15	15	2023-10-27 18:45:38.012963	2023-10-27 18:45:38.012963
200	244	1	1	2023-10-27 18:45:38.012963	2023-10-27 18:45:38.012963
201	244	16	6	2023-10-27 18:45:38.012963	2023-10-27 18:45:38.012963
202	244	15	18	2023-10-27 18:45:38.012963	2023-10-27 18:45:38.012963
203	245	1	1	2023-10-27 18:45:38.012963	2023-10-27 18:45:38.012963
204	245	16	6	2023-10-27 18:45:38.012963	2023-10-27 18:45:38.012963
205	245	15	18	2023-10-27 18:45:49.279425	2023-10-27 18:45:49.279425
206	246	1	1	2023-10-27 18:45:49.279425	2023-10-27 18:45:49.279425
207	246	16	6	2023-10-27 18:45:49.279425	2023-10-27 18:45:49.279425
208	246	15	18	2023-10-27 18:45:49.279425	2023-10-27 18:45:49.279425
209	247	1	1	2023-10-27 18:45:49.279425	2023-10-27 18:45:49.279425
210	247	16	4	2023-10-27 18:45:49.279425	2023-10-27 18:45:49.279425
211	247	15	12	2023-10-27 18:45:49.279425	2023-10-27 18:45:49.279425
212	248	1	1	2023-10-27 18:45:49.279425	2023-10-27 18:45:49.279425
213	248	16	2	2023-10-27 18:45:49.279425	2023-10-27 18:45:49.279425
214	248	15	6	2023-10-27 18:45:49.279425	2023-10-27 18:45:49.279425
215	248	17	1	2023-10-27 18:45:49.279425	2023-10-27 18:45:49.279425
216	249	1	1	2023-10-27 18:45:49.279425	2023-10-27 18:45:49.279425
217	249	16	5	2023-10-27 18:45:49.279425	2023-10-27 18:45:49.279425
218	249	15	15	2023-10-27 18:45:49.279425	2023-10-27 18:45:49.279425
219	250	1	1	2023-10-27 18:45:49.279425	2023-10-27 18:45:49.279425
220	250	16	6	2023-10-27 18:45:49.279425	2023-10-27 18:45:49.279425
221	250	15	18	2023-10-27 18:46:12.610669	2023-10-27 18:46:12.610669
222	251	16	3	2023-10-27 18:46:12.610669	2023-10-27 18:46:12.610669
223	251	15	8	2023-10-27 18:46:12.610669	2023-10-27 18:46:12.610669
224	252	1	1	2023-10-27 18:46:12.610669	2023-10-27 18:46:12.610669
225	253	16	4	2023-10-27 18:46:12.610669	2023-10-27 18:46:12.610669
226	253	15	12	2023-10-27 18:46:12.610669	2023-10-27 18:46:12.610669
227	254	30	3	2023-10-27 18:46:12.610669	2023-10-27 18:46:12.610669
228	254	16	5	2023-10-27 18:46:12.610669	2023-10-27 18:46:12.610669
229	254	15	15	2023-10-27 18:46:12.610669	2023-10-27 18:46:12.610669
230	255	16	7	2023-10-27 18:46:12.610669	2023-10-27 18:46:12.610669
231	255	15	21	2023-10-27 18:46:12.610669	2023-10-27 18:46:12.610669
232	256	1	1	2023-10-27 18:46:12.610669	2023-10-27 18:46:12.610669
233	256	31	1	2023-10-27 18:46:12.610669	2023-10-27 18:46:12.610669
234	257	1	1	2023-10-27 18:46:12.610669	2023-10-27 18:46:12.610669
235	241	1	1	2023-10-27 18:46:22.490384	2023-10-27 18:46:22.490384
236	242	1	1	2023-10-27 18:46:22.490384	2023-10-27 18:46:22.490384
237	243	16	5	2023-10-27 18:46:22.490384	2023-10-27 18:46:22.490384
238	244	15	15	2023-10-27 18:46:22.490384	2023-10-27 18:46:22.490384
239	245	1	1	2023-10-27 18:46:22.490384	2023-10-27 18:46:22.490384
240	246	31	1	2023-10-27 18:46:22.490384	2023-10-27 18:46:22.490384
241	247	5	1	2023-10-27 18:46:22.490384	2023-10-27 18:46:22.490384
242	248	32	1	2023-10-27 18:46:22.490384	2023-10-27 18:46:22.490384
243	249	32	1	2023-10-27 18:46:22.490384	2023-10-27 18:46:22.490384
244	250	1	1	2023-10-27 18:46:22.490384	2023-10-27 18:46:22.490384
245	251	31	1	2023-10-27 18:46:22.490384	2023-10-27 18:46:22.490384
246	252	3	1	2023-10-27 18:46:22.490384	2023-10-27 18:46:22.490384
247	265	25	55	2023-10-27 18:46:29.543167	2023-10-27 18:46:29.543167
248	266	6	1	2023-10-27 18:46:29.543167	2023-10-27 18:46:29.543167
249	267	16	6	2023-10-27 18:46:29.543167	2023-10-27 18:46:29.543167
250	267	15	18	2023-10-27 18:46:29.543167	2023-10-27 18:46:29.543167
251	268	16	6	2023-10-27 18:46:29.543167	2023-10-27 18:46:29.543167
252	268	15	18	2023-10-27 18:46:29.543167	2023-10-27 18:46:29.543167
253	269	16	6	2023-10-27 18:46:29.543167	2023-10-27 18:46:29.543167
254	269	15	18	2023-10-27 18:46:29.543167	2023-10-27 18:46:29.543167
255	270	1	1	2023-10-27 18:46:29.543167	2023-10-27 18:46:29.543167
256	270	14	150	2023-10-27 18:46:29.543167	2023-10-27 18:46:29.543167
257	271	1	1	2023-10-27 18:46:29.543167	2023-10-27 18:46:29.543167
258	271	14	150	2023-10-27 18:46:29.543167	2023-10-27 18:46:29.543167
259	272	1	1	2023-10-27 18:46:29.543167	2023-10-27 18:46:29.543167
260	272	14	150	2023-10-27 18:46:29.543167	2023-10-27 18:46:29.543167
261	273	1	1	2023-10-27 18:46:29.543167	2023-10-27 18:46:29.543167
262	273	14	150	2023-10-27 18:46:29.543167	2023-10-27 18:46:29.543167
263	274	5	1	2023-10-27 18:46:29.543167	2023-10-27 18:46:29.543167
264	275	33	1	2023-10-27 18:46:36.155752	2023-10-27 18:46:36.155752
265	276	1	1	2023-10-27 18:46:36.155752	2023-10-27 18:46:36.155752
266	277	1	1	2023-10-27 18:46:36.155752	2023-10-27 18:46:36.155752
267	278	1	1	2023-10-27 18:46:36.155752	2023-10-27 18:46:36.155752
268	279	1	1	2023-10-27 18:46:36.155752	2023-10-27 18:46:36.155752
269	280	6	1	2023-10-27 18:46:36.155752	2023-10-27 18:46:36.155752
270	281	1	1	2023-10-27 18:46:36.155752	2023-10-27 18:46:36.155752
271	281	16	3	2023-10-27 18:46:36.155752	2023-10-27 18:46:36.155752
272	281	15	9	2023-10-27 18:46:36.155752	2023-10-27 18:46:36.155752
273	282	1	1	2023-10-27 18:46:36.155752	2023-10-27 18:46:36.155752
274	283	1	1	2023-10-27 18:46:36.155752	2023-10-27 18:46:36.155752
275	284	1	1	2023-10-27 18:46:36.155752	2023-10-27 18:46:36.155752
276	285	1	1	2023-10-27 18:46:36.155752	2023-10-27 18:46:36.155752
277	286	1	1	2023-10-27 18:46:43.854238	2023-10-27 18:46:43.854238
278	287	6	1	2023-10-27 18:46:43.854238	2023-10-27 18:46:43.854238
279	288	16	1	2023-10-27 18:46:43.854238	2023-10-27 18:46:43.854238
280	288	15	3	2023-10-27 18:46:43.854238	2023-10-27 18:46:43.854238
281	289	16	2	2023-10-27 18:46:43.854238	2023-10-27 18:46:43.854238
282	289	15	6	2023-10-27 18:46:43.854238	2023-10-27 18:46:43.854238
283	290	34	1	2023-10-27 18:46:43.854238	2023-10-27 18:46:43.854238
284	291	33	1	2023-10-27 18:46:43.854238	2023-10-27 18:46:43.854238
285	292	16	3	2023-10-27 18:46:43.854238	2023-10-27 18:46:43.854238
286	292	15	8	2023-10-27 18:46:43.854238	2023-10-27 18:46:43.854238
287	293	16	3	2023-10-27 18:46:43.854238	2023-10-27 18:46:43.854238
288	295	11	1	2023-10-27 18:46:50.053997	2023-10-27 18:46:50.053997
289	295	12	5	2023-10-27 18:46:50.053997	2023-10-27 18:46:50.053997
\.


--
-- Data for Name: materials; Type: TABLE DATA; Schema: public; Owner: apple
--

COPY public.materials (id, material_name, category_id, default_unit_id, hiragana, created_at, updated_at) FROM stdin;
86	鶏肉	1	1	とりにく	2023-10-27 16:57:58.781219	2023-10-27 16:57:58.781219
87	鶏むね肉	1	1	とりむねにく	2023-10-27 16:57:58.781219	2023-10-27 16:57:58.781219
88	鶏もも肉	1	1	とりももにく	2023-10-27 16:57:58.781219	2023-10-27 16:57:58.781219
89	鶏ささみ	1	1	とりささみ	2023-10-27 16:57:58.781219	2023-10-27 16:57:58.781219
90	鶏むねひき肉	1	1	とりむねひきにく	2023-10-27 16:57:58.781219	2023-10-27 16:57:58.781219
91	鶏ももひき肉	1	1	とりももひきにく	2023-10-27 16:57:58.781219	2023-10-27 16:57:58.781219
92	牛肉	1	1	ぎゅうにく	2023-10-27 16:57:58.781219	2023-10-27 16:57:58.781219
93	牛ひき肉	1	1	ぎゅうひきにく	2023-10-27 16:57:58.781219	2023-10-27 16:57:58.781219
94	牛切り落し	1	1	ぎゅうきりおとし	2023-10-27 16:57:58.781219	2023-10-27 16:57:58.781219
95	牛ステーキ肉	1	1	ぎゅうすてーきにく	2023-10-27 16:57:58.781219	2023-10-27 16:57:58.781219
96	牛しゃぶ肉	1	1	ぎゅうしゃぶにく	2023-10-27 16:57:58.781219	2023-10-27 16:57:58.781219
97	牛豚合い挽き	1	1	ぎゅうぶたあいびき	2023-10-27 16:58:05.518763	2023-10-27 16:58:05.518763
98	牛すき焼き肉	1	1	ぎゅうすきやきにく	2023-10-27 16:58:05.518763	2023-10-27 16:58:05.518763
99	牛もも肉	1	1	ぎゅうももにく	2023-10-27 16:58:05.518763	2023-10-27 16:58:05.518763
100	豚肉	1	1	ぶたにく	2023-10-27 16:58:05.518763	2023-10-27 16:58:05.518763
101	豚ロース	1	1	ぶたろーす	2023-10-27 16:58:05.518763	2023-10-27 16:58:05.518763
102	豚コマ	1	1	ぶたこま	2023-10-27 16:58:05.518763	2023-10-27 16:58:05.518763
103	豚バラ	1	1	ぶたばら	2023-10-27 16:58:05.518763	2023-10-27 16:58:05.518763
104	豚しゃぶ肉	1	1	ぶたしゃぶにく	2023-10-27 16:58:05.518763	2023-10-27 16:58:05.518763
105	ジンギスカン	1	1	じんぎすかん	2023-10-27 16:58:05.518763	2023-10-27 16:58:05.518763
106	牛レバー	1	1	ぎゅうればー	2023-10-27 16:58:05.518763	2023-10-27 16:58:05.518763
107	豚レバー	1	1	ぶたればー	2023-10-27 16:58:05.518763	2023-10-27 16:58:05.518763
108	鶏レバー	1	1	とりればー	2023-10-27 16:58:05.518763	2023-10-27 16:58:05.518763
109	ハム	1	1	はむ	2023-10-27 16:58:05.518763	2023-10-27 16:58:05.518763
110	生ハム	1	1	なまはむ	2023-10-27 16:58:05.518763	2023-10-27 16:58:05.518763
111	サラミ	1	1	さらみ	2023-10-27 16:58:14.548388	2023-10-27 16:58:14.548388
112	ベーコン	1	1	べーこん	2023-10-27 16:58:14.548388	2023-10-27 16:58:14.548388
113	ソーセージ	1	11	そーせーじ	2023-10-27 16:58:14.548388	2023-10-27 16:58:14.548388
114	ウインナー	1	11	ういんなー	2023-10-27 16:58:14.548388	2023-10-27 16:58:14.548388
115	りんご	2	5	りんご	2023-10-27 16:58:14.548388	2023-10-27 16:58:14.548388
116	梨	2	5	なし	2023-10-27 16:58:14.548388	2023-10-27 16:58:14.548388
117	みかん	2	5	みかん	2023-10-27 16:58:14.548388	2023-10-27 16:58:14.548388
118	グレープフルーツ	2	5	ぐれーぷふるーつ	2023-10-27 16:58:14.548388	2023-10-27 16:58:14.548388
119	レモン	2	5	れもん	2023-10-27 16:58:14.548388	2023-10-27 16:58:14.548388
120	いちご	2	5	いちご	2023-10-27 16:58:14.548388	2023-10-27 16:58:14.548388
121	キウイ	2	5	きうい	2023-10-27 16:58:14.548388	2023-10-27 16:58:14.548388
122	バナナ	2	11	ばなな	2023-10-27 16:58:14.548388	2023-10-27 16:58:14.548388
123	桃	2	5	もも	2023-10-27 16:58:14.548388	2023-10-27 16:58:14.548388
124	マンゴー	2	5	まんごー	2023-10-27 16:58:22.045582	2023-10-27 16:58:22.045582
125	栗	2	5	くり	2023-10-27 16:58:22.045582	2023-10-27 16:58:22.045582
126	さくらんぼ	2	5	さくらんぼ	2023-10-27 16:58:22.045582	2023-10-27 16:58:22.045582
127	ほうれん草	2	23	ほうれんそう	2023-10-27 16:58:22.045582	2023-10-27 16:58:22.045582
128	ニラ	2	11	にら	2023-10-27 16:58:22.045582	2023-10-27 16:58:22.045582
129	みつば	2	12	みつば	2023-10-27 16:58:22.045582	2023-10-27 16:58:22.045582
130	春菊	2	1	しゅんぎく	2023-10-27 16:58:22.045582	2023-10-27 16:58:22.045582
131	小松菜	2	1	こまつな	2023-10-27 16:58:22.045582	2023-10-27 16:58:22.045582
132	菜の花	2	1	なのはな	2023-10-27 16:58:22.045582	2023-10-27 16:58:22.045582
133	水菜	2	1	みずな	2023-10-27 16:58:28.996931	2023-10-27 16:58:28.996931
134	きゅうり	2	11	きゅうり	2023-10-27 16:58:28.996931	2023-10-27 16:58:28.996931
135	トマト	2	5	とまと	2023-10-27 16:58:28.996931	2023-10-27 16:58:28.996931
136	プチトマト	2	1	ぷちとまと	2023-10-27 16:58:28.996931	2023-10-27 16:58:28.996931
137	レタス	2	1	れたす	2023-10-27 16:58:28.996931	2023-10-27 16:58:28.996931
138	パプリカ	2	5	ぱぷりか	2023-10-27 16:58:28.996931	2023-10-27 16:58:28.996931
139	ピーマン	2	5	ぴーまん	2023-10-27 16:58:28.996931	2023-10-27 16:58:28.996931
140	貝割れ大根	2	1	かいわれだいこん	2023-10-27 16:58:28.996931	2023-10-27 16:58:28.996931
141	セロリ	2	1	せろり	2023-10-27 16:58:28.996931	2023-10-27 16:58:28.996931
142	ブロッコリー	2	22	ぶろっこりー	2023-10-27 16:58:36.288885	2023-10-27 16:58:36.288885
143	カリフラワー	2	22	かりふらわー	2023-10-27 16:58:36.288885	2023-10-27 16:58:36.288885
144	アスパラガス	2	11	あすぱらがす	2023-10-27 16:58:36.288885	2023-10-27 16:58:36.288885
145	豆苗	2	12	とうみょう	2023-10-27 16:58:36.288885	2023-10-27 16:58:36.288885
146	アボカド	2	5	あぼかど	2023-10-27 16:58:36.288885	2023-10-27 16:58:36.288885
147	キャベツ	2	5	きゃべつ	2023-10-27 16:58:36.288885	2023-10-27 16:58:36.288885
148	チンゲンサイ	2	1	ちんげんさい	2023-10-27 16:58:36.288885	2023-10-27 16:58:36.288885
149	茄子	2	11	なすび	2023-10-27 16:58:36.288885	2023-10-27 16:58:36.288885
150	ししとう	2	11	ししとう	2023-10-27 16:58:36.288885	2023-10-27 16:58:36.288885
151	オクラ	2	11	おくら	2023-10-27 16:58:36.288885	2023-10-27 16:58:36.288885
152	かぼちゃ	2	5	かぼちゃ	2023-10-27 16:58:36.288885	2023-10-27 16:58:36.288885
153	白菜	2	5	はくさい	2023-10-27 16:58:36.288885	2023-10-27 16:58:36.288885
154	ねぎ	2	11	ねぎ	2023-10-27 16:58:36.288885	2023-10-27 16:58:36.288885
155	小ねぎ	2	11	こねぎ	2023-10-27 16:58:36.288885	2023-10-27 16:58:36.288885
156	大根	2	11	だいこん	2023-10-27 16:58:45.868777	2023-10-27 16:58:45.868777
157	玉ねぎ	2	5	たまねぎ	2023-10-27 16:58:45.868777	2023-10-27 16:58:45.868777
158	じゃがいも	2	5	じゃがいも	2023-10-27 16:58:45.868777	2023-10-27 16:58:45.868777
159	にんじん	2	11	にんじん	2023-10-27 16:58:45.868777	2023-10-27 16:58:45.868777
160	長芋	2	11	ながいも	2023-10-27 16:58:45.868777	2023-10-27 16:58:45.868777
161	サツマイモ	2	11	さつまいも	2023-10-27 16:58:45.868777	2023-10-27 16:58:45.868777
162	里芋	2	11	さといも	2023-10-27 16:58:45.868777	2023-10-27 16:58:45.868777
163	ごぼう	2	11	ごぼう	2023-10-27 16:58:45.868777	2023-10-27 16:58:45.868777
164	れんこん	2	11	れんこん	2023-10-27 16:58:45.868777	2023-10-27 16:58:45.868777
165	水煮れんこん	2	1	みずにれんこん	2023-10-27 16:58:45.868777	2023-10-27 16:58:45.868777
166	かぶ	2	5	かぶ	2023-10-27 16:58:45.868777	2023-10-27 16:58:45.868777
167	大葉	2	6	おおば	2023-10-27 16:58:45.868777	2023-10-27 16:58:45.868777
168	しょうが	2	27	しょうが	2023-10-27 16:58:45.868777	2023-10-27 16:58:45.868777
169	みょうが	2	11	みょうが	2023-10-27 16:58:52.236685	2023-10-27 16:58:52.236685
170	にんにく	2	19	にんにく	2023-10-27 16:58:52.236685	2023-10-27 16:58:52.236685
171	わさび	2	1	わさび	2023-10-27 16:58:52.236685	2023-10-27 16:58:52.236685
172	ゆず	2	5	ゆず	2023-10-27 16:58:52.236685	2023-10-27 16:58:52.236685
173	カボス	2	5	かぼす	2023-10-27 16:58:52.236685	2023-10-27 16:58:52.236685
174	さやえんどう	2	11	さやえんどう	2023-10-27 16:58:52.236685	2023-10-27 16:58:52.236685
175	いんげん	2	1	いんげん	2023-10-27 16:58:52.236685	2023-10-27 16:58:52.236685
176	枝豆	2	1	えだまめ	2023-10-27 16:58:52.236685	2023-10-27 16:58:52.236685
177	たけのこ	2	1	たけのこ	2023-10-27 16:58:52.236685	2023-10-27 16:58:52.236685
178	生たけのこ	2	1	なまたけのこ	2023-10-27 16:58:52.236685	2023-10-27 16:58:52.236685
179	水煮たけのこ	2	1	みずにたけのこ	2023-10-27 16:58:52.236685	2023-10-27 16:58:52.236685
180	細切りたけのこ	2	1	こまぎりたけのこ	2023-10-27 16:58:52.236685	2023-10-27 16:58:52.236685
181	もやし	2	1	もやし	2023-10-27 16:58:52.236685	2023-10-27 16:58:52.236685
182	生サバの切り身	3	8	なまさばのきりみ	2023-10-27 16:58:52.236685	2023-10-27 16:58:52.236685
183	塩サバの切り身	3	8	しおさばのきりみ	2023-10-27 16:59:00.991914	2023-10-27 16:59:00.991914
184	アジの切り身	3	6	あじのきりみ	2023-10-27 16:59:00.991914	2023-10-27 16:59:00.991914
185	鰯	3	28	いわし	2023-10-27 16:59:00.991914	2023-10-27 16:59:00.991914
186	秋刀魚	3	28	さんま	2023-10-27 16:59:00.991914	2023-10-27 16:59:00.991914
187	カレイ	3	7	かれい	2023-10-27 16:59:00.991914	2023-10-27 16:59:00.991914
188	カレイの切り身	3	8	かれいのきりみ	2023-10-27 16:59:00.991914	2023-10-27 16:59:00.991914
189	ヒラメ	3	7	ひらめ	2023-10-27 16:59:00.991914	2023-10-27 16:59:00.991914
190	ヒラメの切り身	3	8	ひらめのきりみ	2023-10-27 16:59:00.991914	2023-10-27 16:59:00.991914
191	ぶり	3	7	ぶり	2023-10-27 16:59:00.991914	2023-10-27 16:59:00.991914
192	ぶりの切り身	3	8	ぶりのきりみ	2023-10-27 16:59:00.991914	2023-10-27 16:59:00.991914
193	さわら	3	7	さわら	2023-10-27 16:59:00.991914	2023-10-27 16:59:00.991914
194	さわらの切り身	3	8	さわらのきりみ	2023-10-27 16:59:00.991914	2023-10-27 16:59:00.991914
195	ほっけ	3	7	ほっけ	2023-10-27 16:59:00.991914	2023-10-27 16:59:00.991914
196	ほっけ	3	8	ほっけ	2023-10-27 16:59:00.991914	2023-10-27 16:59:00.991914
197	鯛	3	7	たい	2023-10-27 16:59:00.991914	2023-10-27 16:59:00.991914
198	鯛	3	8	たい	2023-10-27 16:59:15.338232	2023-10-27 16:59:15.338232
199	シャケ	3	7	しゃけ	2023-10-27 16:59:15.338232	2023-10-27 16:59:15.338232
200	シャケ	3	8	しゃけ	2023-10-27 16:59:15.338232	2023-10-27 16:59:15.338232
201	銀ダラ	3	7	ぎんだら	2023-10-27 16:59:15.338232	2023-10-27 16:59:15.338232
202	銀ダラ	3	8	ぎんだら	2023-10-27 16:59:15.338232	2023-10-27 16:59:15.338232
203	カニ	3	9	かに	2023-10-27 16:59:15.338232	2023-10-27 16:59:15.338232
204	カニ足	3	1	かにあし	2023-10-27 16:59:15.338232	2023-10-27 16:59:15.338232
205	エビ	3	7	えび	2023-10-27 16:59:15.338232	2023-10-27 16:59:15.338232
206	タコ	3	1	たこ	2023-10-27 16:59:15.338232	2023-10-27 16:59:15.338232
207	イカ	3	1	いか	2023-10-27 16:59:15.338232	2023-10-27 16:59:15.338232
208	しらす	3	1	しらす	2023-10-27 16:59:15.338232	2023-10-27 16:59:15.338232
209	キス	3	28	きす	2023-10-27 16:59:15.338232	2023-10-27 16:59:15.338232
210	しじみ	3	1	しじみ	2023-10-27 16:59:15.338232	2023-10-27 16:59:15.338232
211	あさり	3	1	あさり	2023-10-27 16:59:15.338232	2023-10-27 16:59:15.338232
212	はまぐり	3	5	はまぐり	2023-10-27 16:59:25.709247	2023-10-27 16:59:25.709247
213	ホタテ	3	5	ほたて	2023-10-27 16:59:25.709247	2023-10-27 16:59:25.709247
214	牡蠣	3	5	かき	2023-10-27 16:59:25.709247	2023-10-27 16:59:25.709247
215	たらこ	3	29	たらこ	2023-10-27 16:59:25.709247	2023-10-27 16:59:25.709247
216	明太子	3	29	めんたいこ	2023-10-27 16:59:25.709247	2023-10-27 16:59:25.709247
217	いくら	3	1	いくら	2023-10-27 16:59:25.709247	2023-10-27 16:59:25.709247
218	うに	3	1	うに	2023-10-27 16:59:25.709247	2023-10-27 16:59:25.709247
219	数の子	3	1	かずのこ	2023-10-27 16:59:25.709247	2023-10-27 16:59:25.709247
220	マグロ 刺身	3	25	まぐろさしみ	2023-10-27 16:59:25.709247	2023-10-27 16:59:25.709247
221	ネギトロ	3	1	ねぎとろ	2023-10-27 16:59:25.709247	2023-10-27 16:59:25.709247
222	サーモン 刺身	3	25	さーもんさしみ	2023-10-27 16:59:25.709247	2023-10-27 16:59:25.709247
223	鯛 刺身	3	25	たいさしみ	2023-10-27 16:59:25.709247	2023-10-27 16:59:25.709247
224	カンパチ 刺身	3	25	かんぱちさしみ	2023-10-27 16:59:25.709247	2023-10-27 16:59:25.709247
225	ぶり 刺身	3	25	ぶりさしみ	2023-10-27 16:59:32.990579	2023-10-27 16:59:32.990579
226	カツオ 刺身	3	25	かつおさしみ	2023-10-27 16:59:32.990579	2023-10-27 16:59:32.990579
227	えのき	4	23	えのき	2023-10-27 16:59:32.990579	2023-10-27 16:59:32.990579
228	しめじ	4	23	しめじ	2023-10-27 16:59:32.990579	2023-10-27 16:59:32.990579
229	なめこ	4	1	なめこ	2023-10-27 16:59:32.990579	2023-10-27 16:59:32.990579
230	まいたけ	4	1	まいたけ	2023-10-27 16:59:32.990579	2023-10-27 16:59:32.990579
231	松茸	4	11	まつたけ	2023-10-27 16:59:32.990579	2023-10-27 16:59:32.990579
232	エリンギ	4	1	えりんぎ	2023-10-27 16:59:32.990579	2023-10-27 16:59:32.990579
233	マシュルーム	4	1	ましゅるーむ	2023-10-27 16:59:32.990579	2023-10-27 16:59:32.990579
234	わらび	4	1	わらび	2023-10-27 16:59:32.990579	2023-10-27 16:59:32.990579
235	ぜんまい	4	1	ぜんまい	2023-10-27 16:59:32.990579	2023-10-27 16:59:32.990579
236	マヨネーズ	5	1	まよねーず	2023-10-27 17:00:54.15869	2023-10-27 17:00:54.15869
237	ウスターソース	5	1	うすたーそーす	2023-10-27 17:00:54.15869	2023-10-27 17:00:54.15869
238	生姜チューブ	5	1	しょうがちゅーぶ	2023-10-27 17:00:54.15869	2023-10-27 17:00:54.15869
239	にんにくチューブ	5	1	にんにくちゅーぶ	2023-10-27 17:00:54.15869	2023-10-27 17:00:54.15869
240	塩	5	1	しお	2023-10-27 17:00:54.15869	2023-10-27 17:00:54.15869
241	砂糖	5	1	さとう	2023-10-27 17:01:04.433476	2023-10-27 17:01:04.433476
242	酢	5	1	す	2023-10-27 17:01:04.433476	2023-10-27 17:01:04.433476
243	料理酒	5	1	りょうりしゅ	2023-10-27 17:01:04.433476	2023-10-27 17:01:04.433476
244	みりん	5	1	みりん	2023-10-27 17:01:04.433476	2023-10-27 17:01:04.433476
245	醤油	5	1	しょうゆ	2023-10-27 17:18:36.594025	2023-10-27 17:18:36.594025
246	味噌	5	1	みそ	2023-10-27 17:18:36.594025	2023-10-27 17:18:36.594025
247	サラダ油	5	1	さらだあぶら	2023-10-27 17:18:36.594025	2023-10-27 17:18:36.594025
248	こしょう	5	1	こしょう	2023-10-27 17:18:36.594025	2023-10-27 17:18:36.594025
249	トマトケチャップ	5	1	とまとけちゃっぷ	2023-10-27 17:18:36.594025	2023-10-27 17:18:36.594025
250	ポン酢	5	1	ぽんず	2023-10-27 17:18:36.594025	2023-10-27 17:18:36.594025
251	一味唐辛子	5	1	いちみとうがらし	2023-10-27 17:18:44.553223	2023-10-27 17:18:44.553223
252	マーガリン	5	1	まーがりん	2023-10-27 17:18:44.553223	2023-10-27 17:18:44.553223
253	オリーブオイル	5	1	おりーぶおいる	2023-10-27 17:18:44.553223	2023-10-27 17:18:44.553223
254	練りからし	5	1	ねりからし	2023-10-27 17:18:44.553223	2023-10-27 17:18:44.553223
255	はちみつ	5	1	はちみつ	2023-10-27 17:18:44.553223	2023-10-27 17:18:44.553223
256	牛乳	6	1	ぎゅうにゅう	2023-10-27 17:18:44.553223	2023-10-27 17:18:44.553223
257	バター	6	1	ばたー	2023-10-27 17:18:44.553223	2023-10-27 17:18:44.553223
258	チーズ	6	1	ちーず	2023-10-27 17:18:51.730146	2023-10-27 17:18:51.730146
259	ヨーグルト	6	1	よーぐると	2023-10-27 17:18:51.730146	2023-10-27 17:18:51.730146
260	生クリーム	6	31	なまくりーむ	2023-10-27 17:18:51.730146	2023-10-27 17:18:51.730146
261	卵	6	5	たまご	2023-10-27 17:18:51.730146	2023-10-27 17:18:51.730146
262	豆腐	6	32	とうふ	2023-10-27 17:18:51.730146	2023-10-27 17:18:51.730146
263	木綿豆腐	6	32	もめんどうふ	2023-10-27 17:18:51.730146	2023-10-27 17:18:51.730146
264	豆乳	6	31	とうにゅう	2023-10-27 17:18:51.730146	2023-10-27 17:18:51.730146
265	納豆	6	1	なっとう	2023-10-27 17:18:58.679474	2023-10-27 17:18:58.679474
266	油揚げ	6	6	あぶらあげ	2023-10-27 17:18:58.679474	2023-10-27 17:18:58.679474
267	味噌	6	1	みそ	2023-10-27 17:18:58.679474	2023-10-27 17:18:58.679474
268	合わせ味噌	6	1	あわせみそ	2023-10-27 17:18:58.679474	2023-10-27 17:18:58.679474
269	赤味噌	6	1	あかみそ	2023-10-27 17:18:58.679474	2023-10-27 17:18:58.679474
270	米	7	1	こめ	2023-10-27 17:18:58.679474	2023-10-27 17:18:58.679474
271	玄米	7	1	げんまい	2023-10-27 17:18:58.679474	2023-10-27 17:18:58.679474
272	五穀米	7	1	ごこくまい	2023-10-27 17:18:58.679474	2023-10-27 17:18:58.679474
273	もち米	7	1	もちごめ	2023-10-27 17:18:58.679474	2023-10-27 17:18:58.679474
274	切り餅	7	1	きりもち	2023-10-27 17:18:58.679474	2023-10-27 17:18:58.679474
275	麺	7	1	めん	2023-10-27 17:19:32.371608	2023-10-27 17:19:32.371608
276	小麦粉	7	1	こむぎこ	2023-10-27 17:19:32.371608	2023-10-27 17:19:32.371608
277	薄力粉	7	1	はくりきこ	2023-10-27 17:19:32.371608	2023-10-27 17:19:32.371608
278	強力粉	7	1	きょうりきこ	2023-10-27 17:19:32.371608	2023-10-27 17:19:32.371608
279	全粒粉	7	1	ぜんりゅうこ	2023-10-27 17:19:32.371608	2023-10-27 17:19:32.371608
280	食パン	7	1	しょくぱん	2023-10-27 17:19:32.371608	2023-10-27 17:19:32.371608
281	片栗粉	5	1	かたくりこ	2023-10-27 17:19:32.371608	2023-10-27 17:19:32.371608
282	生わかめ	8	1	なまわかめ	2023-10-27 17:19:32.371608	2023-10-27 17:19:32.371608
283	乾燥わかめ	8	1	かんそうわかめ	2023-10-27 17:19:32.371608	2023-10-27 17:19:32.371608
284	アオサ	8	1	あおさ	2023-10-27 17:19:32.371608	2023-10-27 17:19:32.371608
285	生もずく	8	1	なまもずく	2023-10-27 17:19:32.371608	2023-10-27 17:19:32.371608
286	昆布	8	1	こんぶ	2023-10-27 17:19:46.265548	2023-10-27 17:19:46.265548
287	海苔 板のり	8	1	のり いたのり	2023-10-27 17:19:46.265548	2023-10-27 17:19:46.265548
288	青のり	8	1	あおのり	2023-10-27 17:19:46.265548	2023-10-27 17:19:46.265548
289	カレー粉	9	1	かれーこ	2023-10-27 17:19:46.265548	2023-10-27 17:19:46.265548
290	カレールー	9	1	かれーるー	2023-10-27 17:19:46.265548	2023-10-27 17:19:46.265548
291	冷凍うどん	9	1	れいとううどん	2023-10-27 17:19:46.265548	2023-10-27 17:19:46.265548
292	ごま	9	1	ごま	2023-10-27 17:19:46.265548	2023-10-27 17:19:46.265548
293	すりごま	9	1	すりごま	2023-10-27 17:19:46.265548	2023-10-27 17:19:46.265548
295	ちくわ	9	11	ちくわ	2023-10-27 17:20:00.640494	2023-10-27 17:20:00.640494
\.


--
-- Data for Name: menu_ingredients; Type: TABLE DATA; Schema: public; Owner: apple
--

COPY public.menu_ingredients (id, menu_id, ingredient_id, created_at, updated_at) FROM stdin;
276	97	1	2023-12-07 04:33:36.945782	2023-12-07 04:33:36.945782
277	96	2	2023-12-07 04:34:16.442092	2023-12-07 04:34:16.442092
282	103	7	2023-12-07 08:30:49.989204	2023-12-07 08:30:49.989204
286	105	11	2023-12-07 08:46:03.689921	2023-12-07 08:46:03.689921
287	105	12	2023-12-07 08:46:03.812431	2023-12-07 08:46:03.812431
288	105	13	2023-12-07 08:46:03.845687	2023-12-07 08:46:03.845687
289	104	14	2023-12-07 11:13:25.249611	2023-12-07 11:13:25.249611
290	106	15	2023-12-07 12:15:57.24717	2023-12-07 12:15:57.24717
291	106	16	2023-12-07 12:15:57.264468	2023-12-07 12:15:57.264468
292	107	17	2023-12-08 11:01:26.85516	2023-12-08 11:01:26.85516
293	108	18	2023-12-08 11:02:50.640724	2023-12-08 11:02:50.640724
294	109	19	2023-12-08 11:47:07.489092	2023-12-08 11:47:07.489092
295	109	20	2023-12-08 11:47:07.513796	2023-12-08 11:47:07.513796
296	109	21	2023-12-08 11:47:07.581341	2023-12-08 11:47:07.581341
297	110	22	2023-12-08 11:49:16.79745	2023-12-08 11:49:16.79745
298	110	23	2023-12-08 11:49:16.873666	2023-12-08 11:49:16.873666
299	110	24	2023-12-08 11:49:16.898678	2023-12-08 11:49:16.898678
300	111	25	2023-12-08 11:49:44.032582	2023-12-08 11:49:44.032582
301	111	26	2023-12-08 11:49:44.052662	2023-12-08 11:49:44.052662
302	111	27	2023-12-08 11:49:44.117611	2023-12-08 11:49:44.117611
303	112	28	2023-12-13 06:45:16.357989	2023-12-13 06:45:16.357989
304	112	29	2023-12-13 06:45:16.413617	2023-12-13 06:45:16.413617
305	112	30	2023-12-13 06:45:16.432661	2023-12-13 06:45:16.432661
306	113	31	2023-12-18 06:38:25.688099	2023-12-18 06:38:25.688099
\.


--
-- Data for Name: menus; Type: TABLE DATA; Schema: public; Owner: apple
--

COPY public.menus (id, menu_name, menu_contents, contents, image_meta_data, image, created_at, updated_at) FROM stdin;
103	asdf	asdf	asdf			2023-12-07 04:56:15.615807	2023-12-07 08:30:49.291386
104	パスタ	asd	asd			2023-12-07 05:10:23.106471	2023-12-07 11:13:25.149521
106	あds	さdf	あsdf			2023-12-07 12:15:57.182877	2023-12-07 12:15:57.201157
109	asd	asd	asd			2023-12-08 11:47:07.276236	2023-12-08 11:47:07.304929
112	天ぷら	あsdsd	asだ			2023-12-13 06:45:16.203365	2023-12-13 06:45:16.223272
113	とんかつ	asd	asd			2023-12-18 06:38:25.47098	2023-12-18 06:38:25.508233
100	グラタン	あsdf	sdfあsdf			2023-12-07 04:49:58.251551	2023-12-07 04:49:58.265458
99	ハンバーグ	ご飯、スープ、ハンバーグ	１.加熱後に粗熱を取る必要があるので、玉ねぎ（小さめ1個分）をみじん切り\n\n2.フライパンにサラダ油大さじ1を入れて強めの中火で熱し、玉ねぎを加えます。時おり混ぜながら炒めます。軽く色づいてきたら、弱めの中火に火加減を落とし、合計8〜9分ほどじっくり炒めて甘みを引き出しましょう。\n\n3.玉ねぎの粗熱が取れたら、ボウルに合びき肉と合わせ、混ぜる前にAの材料（パン粉大さじ4、牛乳大さじ4～5、塩と砂糖各小さじ1/2、おろしにんにく1/2片分、コショウ少々）をすべて加えます。\n\n4.利き手でしっかり材料を練り混ぜ、ハンバーグのタネを作ります。はじめは手をグー、パー、グー、パーとひき肉と調味料を握るようにして全体を混ぜ、全体が混ざったらぐるぐるとかき混ぜるように練ってタネを作ります。\n\n5.タネが出来上がったら、作る個数にざっくりとボウルの中で切り分け、手に取って成形していきます。楕円形に軽くまとめたら表面をならして形を整え、片手から片手へ軽く投げるようにして空気を抜きます（10～20回くらい）。\n\n6.フライパンに薄く油をひいて（分量外）、中火にかけて熱くなったらハンバーグをそっと並べ入れます。まず、片面に焼き色をつけます。火加減は弱火を少し強くしたくらいにして2〜3分ほど焼きます。			2023-12-07 04:47:38.187188	2023-12-07 04:47:38.203537
101	和風パスタ	あsdc	あfヴァ			2023-12-07 04:51:24.564365	2023-12-07 04:51:24.617318
102	とんかつ	あsdf	あsdf			2023-12-07 04:55:25.404741	2023-12-07 04:55:25.429042
105	ハンバーグ	ご飯、スープ、ハンバーグ	１.加熱後に粗熱を取る必要があるので、玉ねぎ（小さめ1個分）をみじん切り\n\n2.フライパンにサラダ油大さじ1を入れて強めの中火で熱し、玉ねぎを加えます。時おり混ぜながら炒めます。軽く色づいてきたら、弱めの中火に火加減を落とし、合計8〜9分ほどじっくり炒めて甘みを引き出しましょう。\n\n3.玉ねぎの粗熱が取れたら、ボウルに合びき肉と合わせ、混ぜる前にAの材料（パン粉大さじ4、牛乳大さじ4～5、塩と砂糖各小さじ1/2、おろしにんにく1/2片分、コショウ少々）をすべて加えます。\n\n4.利き手でしっかり材料を練り混ぜ、ハンバーグのタネを作ります。はじめは手をグー、パー、グー、パーとひき肉と調味料を握るようにして全体を混ぜ、全体が混ざったらぐるぐるとかき混ぜるように練ってタネを作ります。\n\n5.タネが出来上がったら、作る個数にざっくりとボウルの中で切り分け、手に取って成形していきます。楕円形に軽くまとめたら表面をならして形を整え、片手から片手へ軽く投げるようにして空気を抜きます（10～20回くらい）。\n\n6.フライパンに薄く油をひいて（分量外）、中火にかけて熱くなったらハンバーグをそっと並べ入れます。まず、片面に焼き色をつけます。火加減は弱火を少し強くしたくらいにして2〜3分ほど焼きます。\n\n7.2〜3分焼いてこんがりと片面に焼き色がつけば裏返します。すべてを裏返したら弱火にして、蓋をして7〜9分ほどじっくり蒸し焼きにします。\n\n8.蒸し焼きが終わったら、いちばん厚みのあるハンバーグの中央に竹串を刺します。竹串を抜いた部分から透明な肉汁が出てくれば火が通っています。			2023-12-07 08:36:12.043533	2023-12-07 08:46:02.985137
107	ああああああああああああああああああああ	ああああああああああああああああああああ	ああああああああああああああああああああ			2023-12-08 11:01:26.712361	2023-12-08 11:01:26.733467
108	ああああああああああ	あsd	あsd			2023-12-08 11:02:50.499296	2023-12-08 11:02:50.517881
110	テスト	あsdf	あsdf			2023-12-08 11:49:16.719678	2023-12-08 11:49:16.73928
111	テスト２	あsf	あsdf			2023-12-08 11:49:43.964904	2023-12-08 11:49:43.981853
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: public; Owner: apple
--

COPY public.schema_migrations (version) FROM stdin;
20230628094149
20230908034052
20230929073545
20231013173246
20231014075814
20231017081956
20231017110904
20230906091255
20230908032753
20230906234713
20231204041537
20231207143617
20231211033342
20231211081014
20231204041549
20231215010902
\.


--
-- Data for Name: shopping_list_items; Type: TABLE DATA; Schema: public; Owner: apple
--

COPY public.shopping_list_items (id, shopping_list_id, material_id, quantity, unit_id, category_id, is_checked, created_at, updated_at) FROM stdin;
228	6	139	2.0	5	2	t	2023-12-18 11:05:29.617752	2023-12-18 11:05:31.495805
229	6	165	10.0	1	2	t	2023-12-18 11:05:29.629025	2023-12-18 11:05:32.521411
227	6	205	10.0	7	3	t	2023-12-18 11:05:29.606139	2023-12-18 11:05:33.205637
\.


--
-- Data for Name: shopping_list_menus; Type: TABLE DATA; Schema: public; Owner: apple
--

COPY public.shopping_list_menus (id, shopping_list_id, menu_id, menu_count, created_at, updated_at) FROM stdin;
91	6	112	1	2023-12-18 11:05:29.641985	2023-12-18 11:05:29.641985
\.


--
-- Data for Name: shopping_lists; Type: TABLE DATA; Schema: public; Owner: apple
--

COPY public.shopping_lists (id, cart_id, created_at, updated_at) FROM stdin;
6	4	2023-12-14 04:00:33.931911	2023-12-14 04:00:33.931911
\.


--
-- Data for Name: units; Type: TABLE DATA; Schema: public; Owner: apple
--

COPY public.units (id, unit_name, created_at, updated_at) FROM stdin;
1	g	2023-10-23 19:26:40.974037	2023-10-23 19:26:40.974037
2	kg	2023-10-23 19:26:40.974037	2023-10-23 19:26:40.974037
3	ml	2023-10-23 19:26:40.974037	2023-10-23 19:26:40.974037
4	L	2023-10-23 19:26:40.974037	2023-10-23 19:26:40.974037
5	個	2023-10-23 19:26:40.974037	2023-10-23 19:26:40.974037
6	枚	2023-10-23 19:26:40.974037	2023-10-23 19:26:40.974037
7	匹	2023-10-23 19:26:40.974037	2023-10-23 19:26:40.974037
8	切れ	2023-10-23 19:26:40.974037	2023-10-23 19:26:40.974037
9	杯	2023-10-23 19:26:40.974037	2023-10-23 19:26:40.974037
10	缶	2023-10-23 19:26:40.974037	2023-10-23 19:26:40.974037
11	本	2023-10-23 19:26:40.974037	2023-10-23 19:26:40.974037
12	袋	2023-10-23 19:26:40.974037	2023-10-23 19:26:40.974037
13	束	2023-10-23 19:26:40.974037	2023-10-23 19:26:40.974037
14	合	2023-10-23 19:26:40.974037	2023-10-23 19:26:40.974037
15	大さじ	2023-10-23 19:26:40.974037	2023-10-23 19:26:40.974037
16	小さじ	2023-10-23 19:26:40.974037	2023-10-23 19:26:40.974037
17	少々	2023-10-23 19:26:40.974037	2023-10-23 19:26:40.974037
18	カップ	2023-10-23 19:26:40.974037	2023-10-23 19:26:40.974037
19	片	2023-10-23 19:26:40.974037	2023-10-23 19:26:40.974037
20	房	2023-10-23 19:26:40.974037	2023-10-23 19:26:40.974037
21	粒	2023-10-23 19:26:40.974037	2023-10-23 19:26:40.974037
22	株	2023-10-23 19:26:40.974037	2023-10-23 19:26:40.974037
23	把	2023-10-23 19:26:40.974037	2023-10-23 19:26:40.974037
24	パック	2023-10-23 19:26:40.974037	2023-10-23 19:26:40.974037
25	節	2023-10-23 19:26:40.974037	2023-10-23 19:26:40.974037
26	かけ	2023-10-23 19:26:40.974037	2023-10-23 19:26:40.974037
27	尾	2023-10-23 19:26:40.974037	2023-10-23 19:26:40.974037
28	腹	2023-10-23 19:26:40.974037	2023-10-23 19:26:40.974037
29	cm	2023-10-23 19:26:40.974037	2023-10-23 19:26:40.974037
\.


--
-- Data for Name: user_menus; Type: TABLE DATA; Schema: public; Owner: apple
--

COPY public.user_menus (id, user_id, menu_id, created_at, updated_at) FROM stdin;
1	1	112	2023-12-13 06:45:16.285263	2023-12-13 06:45:16.285263
2	1	113	2023-12-18 06:38:25.596614	2023-12-18 06:38:25.596614
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: apple
--

COPY public.users (id, name, email, encrypted_password, reset_password_token, reset_password_sent_at, remember_created_at, created_at, updated_at) FROM stdin;
1	ユーザー１	sinke.niinomi0506@gmai.com	$2a$12$RFAObQZ97YMahv.ciqJyLOW5VJCHwbqAKy3ZnRmrb.FJtM5mT1f/i	\N	\N	\N	2023-10-23 11:14:02.534036	2023-10-23 11:14:02.534036
\.


--
-- Name: active_storage_attachments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: apple
--

SELECT pg_catalog.setval('public.active_storage_attachments_id_seq', 473, true);


--
-- Name: active_storage_blobs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: apple
--

SELECT pg_catalog.setval('public.active_storage_blobs_id_seq', 473, true);


--
-- Name: active_storage_variant_records_id_seq; Type: SEQUENCE SET; Schema: public; Owner: apple
--

SELECT pg_catalog.setval('public.active_storage_variant_records_id_seq', 282, true);


--
-- Name: cart_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: apple
--

SELECT pg_catalog.setval('public.cart_items_id_seq', 91, true);


--
-- Name: carts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: apple
--

SELECT pg_catalog.setval('public.carts_id_seq', 4, true);


--
-- Name: categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: apple
--

SELECT pg_catalog.setval('public.categories_id_seq', 9, true);


--
-- Name: completed_menus_id_seq; Type: SEQUENCE SET; Schema: public; Owner: apple
--

SELECT pg_catalog.setval('public.completed_menus_id_seq', 68, true);


--
-- Name: ingredients_id_seq; Type: SEQUENCE SET; Schema: public; Owner: apple
--

SELECT pg_catalog.setval('public.ingredients_id_seq', 31, true);


--
-- Name: material_units_id_seq; Type: SEQUENCE SET; Schema: public; Owner: apple
--

SELECT pg_catalog.setval('public.material_units_id_seq', 289, true);


--
-- Name: materials_id_seq; Type: SEQUENCE SET; Schema: public; Owner: apple
--

SELECT pg_catalog.setval('public.materials_id_seq', 295, true);


--
-- Name: menu_ingredients_id_seq; Type: SEQUENCE SET; Schema: public; Owner: apple
--

SELECT pg_catalog.setval('public.menu_ingredients_id_seq', 306, true);


--
-- Name: menus_id_seq; Type: SEQUENCE SET; Schema: public; Owner: apple
--

SELECT pg_catalog.setval('public.menus_id_seq', 113, true);


--
-- Name: shopping_list_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: apple
--

SELECT pg_catalog.setval('public.shopping_list_items_id_seq', 229, true);


--
-- Name: shopping_list_menus_id_seq; Type: SEQUENCE SET; Schema: public; Owner: apple
--

SELECT pg_catalog.setval('public.shopping_list_menus_id_seq', 91, true);


--
-- Name: shopping_lists_id_seq; Type: SEQUENCE SET; Schema: public; Owner: apple
--

SELECT pg_catalog.setval('public.shopping_lists_id_seq', 6, true);


--
-- Name: units_id_seq; Type: SEQUENCE SET; Schema: public; Owner: apple
--

SELECT pg_catalog.setval('public.units_id_seq', 29, true);


--
-- Name: user_menus_id_seq; Type: SEQUENCE SET; Schema: public; Owner: apple
--

SELECT pg_catalog.setval('public.user_menus_id_seq', 2, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: apple
--

SELECT pg_catalog.setval('public.users_id_seq', 1, true);


--
-- Name: active_storage_attachments active_storage_attachments_pkey; Type: CONSTRAINT; Schema: public; Owner: apple
--

ALTER TABLE ONLY public.active_storage_attachments
    ADD CONSTRAINT active_storage_attachments_pkey PRIMARY KEY (id);


--
-- Name: active_storage_blobs active_storage_blobs_pkey; Type: CONSTRAINT; Schema: public; Owner: apple
--

ALTER TABLE ONLY public.active_storage_blobs
    ADD CONSTRAINT active_storage_blobs_pkey PRIMARY KEY (id);


--
-- Name: active_storage_variant_records active_storage_variant_records_pkey; Type: CONSTRAINT; Schema: public; Owner: apple
--

ALTER TABLE ONLY public.active_storage_variant_records
    ADD CONSTRAINT active_storage_variant_records_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: apple
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: cart_items cart_items_pkey; Type: CONSTRAINT; Schema: public; Owner: apple
--

ALTER TABLE ONLY public.cart_items
    ADD CONSTRAINT cart_items_pkey PRIMARY KEY (id);


--
-- Name: carts carts_pkey; Type: CONSTRAINT; Schema: public; Owner: apple
--

ALTER TABLE ONLY public.carts
    ADD CONSTRAINT carts_pkey PRIMARY KEY (id);


--
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public; Owner: apple
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- Name: completed_menus completed_menus_pkey; Type: CONSTRAINT; Schema: public; Owner: apple
--

ALTER TABLE ONLY public.completed_menus
    ADD CONSTRAINT completed_menus_pkey PRIMARY KEY (id);


--
-- Name: ingredients ingredients_pkey; Type: CONSTRAINT; Schema: public; Owner: apple
--

ALTER TABLE ONLY public.ingredients
    ADD CONSTRAINT ingredients_pkey PRIMARY KEY (id);


--
-- Name: material_units material_units_pkey; Type: CONSTRAINT; Schema: public; Owner: apple
--

ALTER TABLE ONLY public.material_units
    ADD CONSTRAINT material_units_pkey PRIMARY KEY (id);


--
-- Name: materials materials_pkey; Type: CONSTRAINT; Schema: public; Owner: apple
--

ALTER TABLE ONLY public.materials
    ADD CONSTRAINT materials_pkey PRIMARY KEY (id);


--
-- Name: menu_ingredients menu_ingredients_pkey; Type: CONSTRAINT; Schema: public; Owner: apple
--

ALTER TABLE ONLY public.menu_ingredients
    ADD CONSTRAINT menu_ingredients_pkey PRIMARY KEY (id);


--
-- Name: menus menus_pkey; Type: CONSTRAINT; Schema: public; Owner: apple
--

ALTER TABLE ONLY public.menus
    ADD CONSTRAINT menus_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: apple
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: shopping_list_items shopping_list_items_pkey; Type: CONSTRAINT; Schema: public; Owner: apple
--

ALTER TABLE ONLY public.shopping_list_items
    ADD CONSTRAINT shopping_list_items_pkey PRIMARY KEY (id);


--
-- Name: shopping_list_menus shopping_list_menus_pkey; Type: CONSTRAINT; Schema: public; Owner: apple
--

ALTER TABLE ONLY public.shopping_list_menus
    ADD CONSTRAINT shopping_list_menus_pkey PRIMARY KEY (id);


--
-- Name: shopping_lists shopping_lists_pkey; Type: CONSTRAINT; Schema: public; Owner: apple
--

ALTER TABLE ONLY public.shopping_lists
    ADD CONSTRAINT shopping_lists_pkey PRIMARY KEY (id);


--
-- Name: units units_pkey; Type: CONSTRAINT; Schema: public; Owner: apple
--

ALTER TABLE ONLY public.units
    ADD CONSTRAINT units_pkey PRIMARY KEY (id);


--
-- Name: user_menus user_menus_pkey; Type: CONSTRAINT; Schema: public; Owner: apple
--

ALTER TABLE ONLY public.user_menus
    ADD CONSTRAINT user_menus_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: apple
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_active_storage_attachments_on_blob_id; Type: INDEX; Schema: public; Owner: apple
--

CREATE INDEX index_active_storage_attachments_on_blob_id ON public.active_storage_attachments USING btree (blob_id);


--
-- Name: index_active_storage_attachments_uniqueness; Type: INDEX; Schema: public; Owner: apple
--

CREATE UNIQUE INDEX index_active_storage_attachments_uniqueness ON public.active_storage_attachments USING btree (record_type, record_id, name, blob_id);


--
-- Name: index_active_storage_blobs_on_key; Type: INDEX; Schema: public; Owner: apple
--

CREATE UNIQUE INDEX index_active_storage_blobs_on_key ON public.active_storage_blobs USING btree (key);


--
-- Name: index_active_storage_variant_records_uniqueness; Type: INDEX; Schema: public; Owner: apple
--

CREATE UNIQUE INDEX index_active_storage_variant_records_uniqueness ON public.active_storage_variant_records USING btree (blob_id, variation_digest);


--
-- Name: index_cart_items_on_cart_id; Type: INDEX; Schema: public; Owner: apple
--

CREATE INDEX index_cart_items_on_cart_id ON public.cart_items USING btree (cart_id);


--
-- Name: index_cart_items_on_menu_id; Type: INDEX; Schema: public; Owner: apple
--

CREATE INDEX index_cart_items_on_menu_id ON public.cart_items USING btree (menu_id);


--
-- Name: index_carts_on_user_id; Type: INDEX; Schema: public; Owner: apple
--

CREATE INDEX index_carts_on_user_id ON public.carts USING btree (user_id);


--
-- Name: index_completed_menus_on_menu_id; Type: INDEX; Schema: public; Owner: apple
--

CREATE INDEX index_completed_menus_on_menu_id ON public.completed_menus USING btree (menu_id);


--
-- Name: index_completed_menus_on_user_id; Type: INDEX; Schema: public; Owner: apple
--

CREATE INDEX index_completed_menus_on_user_id ON public.completed_menus USING btree (user_id);


--
-- Name: index_ingredients_on_material_id; Type: INDEX; Schema: public; Owner: apple
--

CREATE INDEX index_ingredients_on_material_id ON public.ingredients USING btree (material_id);


--
-- Name: index_ingredients_on_unit_id; Type: INDEX; Schema: public; Owner: apple
--

CREATE INDEX index_ingredients_on_unit_id ON public.ingredients USING btree (unit_id);


--
-- Name: index_material_units_on_material_id; Type: INDEX; Schema: public; Owner: apple
--

CREATE INDEX index_material_units_on_material_id ON public.material_units USING btree (material_id);


--
-- Name: index_material_units_on_unit_id; Type: INDEX; Schema: public; Owner: apple
--

CREATE INDEX index_material_units_on_unit_id ON public.material_units USING btree (unit_id);


--
-- Name: index_materials_on_category_id; Type: INDEX; Schema: public; Owner: apple
--

CREATE INDEX index_materials_on_category_id ON public.materials USING btree (category_id);


--
-- Name: index_menu_ingredients_on_ingredient_id; Type: INDEX; Schema: public; Owner: apple
--

CREATE INDEX index_menu_ingredients_on_ingredient_id ON public.menu_ingredients USING btree (ingredient_id);


--
-- Name: index_menu_ingredients_on_menu_id; Type: INDEX; Schema: public; Owner: apple
--

CREATE INDEX index_menu_ingredients_on_menu_id ON public.menu_ingredients USING btree (menu_id);


--
-- Name: index_shopping_list_items_on_category_id; Type: INDEX; Schema: public; Owner: apple
--

CREATE INDEX index_shopping_list_items_on_category_id ON public.shopping_list_items USING btree (category_id);


--
-- Name: index_shopping_list_items_on_material_id; Type: INDEX; Schema: public; Owner: apple
--

CREATE INDEX index_shopping_list_items_on_material_id ON public.shopping_list_items USING btree (material_id);


--
-- Name: index_shopping_list_items_on_shopping_list_id; Type: INDEX; Schema: public; Owner: apple
--

CREATE INDEX index_shopping_list_items_on_shopping_list_id ON public.shopping_list_items USING btree (shopping_list_id);


--
-- Name: index_shopping_list_items_on_unit_id; Type: INDEX; Schema: public; Owner: apple
--

CREATE INDEX index_shopping_list_items_on_unit_id ON public.shopping_list_items USING btree (unit_id);


--
-- Name: index_shopping_list_menus_on_menu_id; Type: INDEX; Schema: public; Owner: apple
--

CREATE INDEX index_shopping_list_menus_on_menu_id ON public.shopping_list_menus USING btree (menu_id);


--
-- Name: index_shopping_list_menus_on_shopping_list_id; Type: INDEX; Schema: public; Owner: apple
--

CREATE INDEX index_shopping_list_menus_on_shopping_list_id ON public.shopping_list_menus USING btree (shopping_list_id);


--
-- Name: index_shopping_lists_on_cart_id; Type: INDEX; Schema: public; Owner: apple
--

CREATE INDEX index_shopping_lists_on_cart_id ON public.shopping_lists USING btree (cart_id);


--
-- Name: index_user_menus_on_menu_id; Type: INDEX; Schema: public; Owner: apple
--

CREATE INDEX index_user_menus_on_menu_id ON public.user_menus USING btree (menu_id);


--
-- Name: index_user_menus_on_user_id; Type: INDEX; Schema: public; Owner: apple
--

CREATE INDEX index_user_menus_on_user_id ON public.user_menus USING btree (user_id);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: apple
--

CREATE UNIQUE INDEX index_users_on_email ON public.users USING btree (email);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: apple
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON public.users USING btree (reset_password_token);


--
-- Name: shopping_list_menus fk_rails_3cda9e24eb; Type: FK CONSTRAINT; Schema: public; Owner: apple
--

ALTER TABLE ONLY public.shopping_list_menus
    ADD CONSTRAINT fk_rails_3cda9e24eb FOREIGN KEY (menu_id) REFERENCES public.menus(id);


--
-- Name: shopping_list_items fk_rails_403f569839; Type: FK CONSTRAINT; Schema: public; Owner: apple
--

ALTER TABLE ONLY public.shopping_list_items
    ADD CONSTRAINT fk_rails_403f569839 FOREIGN KEY (category_id) REFERENCES public.categories(id);


--
-- Name: cart_items fk_rails_6cdb1f0139; Type: FK CONSTRAINT; Schema: public; Owner: apple
--

ALTER TABLE ONLY public.cart_items
    ADD CONSTRAINT fk_rails_6cdb1f0139 FOREIGN KEY (cart_id) REFERENCES public.carts(id);


--
-- Name: cart_items fk_rails_6eb6b13d40; Type: FK CONSTRAINT; Schema: public; Owner: apple
--

ALTER TABLE ONLY public.cart_items
    ADD CONSTRAINT fk_rails_6eb6b13d40 FOREIGN KEY (menu_id) REFERENCES public.menus(id);


--
-- Name: completed_menus fk_rails_731cf2dc9e; Type: FK CONSTRAINT; Schema: public; Owner: apple
--

ALTER TABLE ONLY public.completed_menus
    ADD CONSTRAINT fk_rails_731cf2dc9e FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: shopping_list_menus fk_rails_78d2c5f641; Type: FK CONSTRAINT; Schema: public; Owner: apple
--

ALTER TABLE ONLY public.shopping_list_menus
    ADD CONSTRAINT fk_rails_78d2c5f641 FOREIGN KEY (shopping_list_id) REFERENCES public.shopping_lists(id);


--
-- Name: completed_menus fk_rails_844f5c0dc4; Type: FK CONSTRAINT; Schema: public; Owner: apple
--

ALTER TABLE ONLY public.completed_menus
    ADD CONSTRAINT fk_rails_844f5c0dc4 FOREIGN KEY (menu_id) REFERENCES public.menus(id);


--
-- Name: active_storage_variant_records fk_rails_993965df05; Type: FK CONSTRAINT; Schema: public; Owner: apple
--

ALTER TABLE ONLY public.active_storage_variant_records
    ADD CONSTRAINT fk_rails_993965df05 FOREIGN KEY (blob_id) REFERENCES public.active_storage_blobs(id);


--
-- Name: shopping_list_items fk_rails_9f4bbc18b7; Type: FK CONSTRAINT; Schema: public; Owner: apple
--

ALTER TABLE ONLY public.shopping_list_items
    ADD CONSTRAINT fk_rails_9f4bbc18b7 FOREIGN KEY (material_id) REFERENCES public.materials(id);


--
-- Name: active_storage_attachments fk_rails_c3b3935057; Type: FK CONSTRAINT; Schema: public; Owner: apple
--

ALTER TABLE ONLY public.active_storage_attachments
    ADD CONSTRAINT fk_rails_c3b3935057 FOREIGN KEY (blob_id) REFERENCES public.active_storage_blobs(id);


--
-- Name: shopping_list_items fk_rails_cae3153540; Type: FK CONSTRAINT; Schema: public; Owner: apple
--

ALTER TABLE ONLY public.shopping_list_items
    ADD CONSTRAINT fk_rails_cae3153540 FOREIGN KEY (shopping_list_id) REFERENCES public.shopping_lists(id);


--
-- Name: shopping_list_items fk_rails_d8e15b0b1b; Type: FK CONSTRAINT; Schema: public; Owner: apple
--

ALTER TABLE ONLY public.shopping_list_items
    ADD CONSTRAINT fk_rails_d8e15b0b1b FOREIGN KEY (unit_id) REFERENCES public.units(id);


--
-- Name: shopping_lists fk_rails_dbfe2457b9; Type: FK CONSTRAINT; Schema: public; Owner: apple
--

ALTER TABLE ONLY public.shopping_lists
    ADD CONSTRAINT fk_rails_dbfe2457b9 FOREIGN KEY (cart_id) REFERENCES public.carts(id);


--
-- Name: carts fk_rails_ea59a35211; Type: FK CONSTRAINT; Schema: public; Owner: apple
--

ALTER TABLE ONLY public.carts
    ADD CONSTRAINT fk_rails_ea59a35211 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- PostgreSQL database dump complete
--

