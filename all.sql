--
-- PostgreSQL database cluster dump
--

SET default_transaction_read_only = off;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

--
-- Roles
--

CREATE ROLE loraserver_as;
ALTER ROLE loraserver_as WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS PASSWORD 'md5efa6acb899280a4cfb24ee8fa630b55c';
CREATE ROLE loraserver_ns;
ALTER ROLE loraserver_ns WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS PASSWORD 'md52a083cb233ff34a5b79014712fef7ad0';
CREATE ROLE postgres;
ALTER ROLE postgres WITH SUPERUSER INHERIT CREATEROLE CREATEDB LOGIN REPLICATION BYPASSRLS;






--
-- Database creation
--

CREATE DATABASE loraserver_as WITH TEMPLATE = template0 OWNER = loraserver_as;
CREATE DATABASE loraserver_ns WITH TEMPLATE = template0 OWNER = loraserver_ns;
REVOKE CONNECT,TEMPORARY ON DATABASE template1 FROM PUBLIC;
GRANT CONNECT ON DATABASE template1 TO PUBLIC;


\connect loraserver_as

SET default_transaction_read_only = off;

--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.11
-- Dumped by pg_dump version 9.6.11

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: pg_trgm; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;


--
-- Name: EXTENSION pg_trgm; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_trgm IS 'text similarity measurement and index searching based on trigrams';


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: application; Type: TABLE; Schema: public; Owner: loraserver_as
--

CREATE TABLE public.application (
    id bigint NOT NULL,
    name character varying(100) NOT NULL,
    description text NOT NULL,
    organization_id bigint NOT NULL,
    service_profile_id uuid NOT NULL,
    payload_codec text DEFAULT ''::text NOT NULL,
    payload_encoder_script text DEFAULT ''::text NOT NULL,
    payload_decoder_script text DEFAULT ''::text NOT NULL
);


ALTER TABLE public.application OWNER TO loraserver_as;

--
-- Name: application_id_seq; Type: SEQUENCE; Schema: public; Owner: loraserver_as
--

CREATE SEQUENCE public.application_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.application_id_seq OWNER TO loraserver_as;

--
-- Name: application_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: loraserver_as
--

ALTER SEQUENCE public.application_id_seq OWNED BY public.application.id;


--
-- Name: device; Type: TABLE; Schema: public; Owner: loraserver_as
--

CREATE TABLE public.device (
    dev_eui bytea NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    application_id bigint NOT NULL,
    device_profile_id uuid NOT NULL,
    name character varying(100) NOT NULL,
    description text NOT NULL,
    last_seen_at timestamp with time zone,
    device_status_battery numeric(5,2),
    device_status_margin integer,
    latitude double precision,
    longitude double precision,
    altitude double precision,
    device_status_external_power_source boolean NOT NULL
);


ALTER TABLE public.device OWNER TO loraserver_as;

--
-- Name: device_activation; Type: TABLE; Schema: public; Owner: loraserver_as
--

CREATE TABLE public.device_activation (
    id bigint NOT NULL,
    created_at timestamp with time zone NOT NULL,
    dev_eui bytea NOT NULL,
    dev_addr bytea NOT NULL,
    app_s_key bytea NOT NULL
);


ALTER TABLE public.device_activation OWNER TO loraserver_as;

--
-- Name: device_activation_id_seq; Type: SEQUENCE; Schema: public; Owner: loraserver_as
--

CREATE SEQUENCE public.device_activation_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.device_activation_id_seq OWNER TO loraserver_as;

--
-- Name: device_activation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: loraserver_as
--

ALTER SEQUENCE public.device_activation_id_seq OWNED BY public.device_activation.id;


--
-- Name: device_keys; Type: TABLE; Schema: public; Owner: loraserver_as
--

CREATE TABLE public.device_keys (
    dev_eui bytea NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    nwk_key bytea NOT NULL,
    join_nonce integer NOT NULL,
    app_key bytea NOT NULL
);


ALTER TABLE public.device_keys OWNER TO loraserver_as;

--
-- Name: device_multicast_group; Type: TABLE; Schema: public; Owner: loraserver_as
--

CREATE TABLE public.device_multicast_group (
    dev_eui bytea NOT NULL,
    multicast_group_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL
);


ALTER TABLE public.device_multicast_group OWNER TO loraserver_as;

--
-- Name: device_profile; Type: TABLE; Schema: public; Owner: loraserver_as
--

CREATE TABLE public.device_profile (
    device_profile_id uuid NOT NULL,
    network_server_id bigint NOT NULL,
    organization_id bigint NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    name character varying(100) NOT NULL
);


ALTER TABLE public.device_profile OWNER TO loraserver_as;

--
-- Name: gateway; Type: TABLE; Schema: public; Owner: loraserver_as
--

CREATE TABLE public.gateway (
    mac bytea NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    name character varying(100) NOT NULL,
    description text NOT NULL,
    organization_id bigint NOT NULL,
    ping boolean DEFAULT false NOT NULL,
    last_ping_id bigint,
    last_ping_sent_at timestamp with time zone,
    network_server_id bigint NOT NULL,
    gateway_profile_id uuid
);


ALTER TABLE public.gateway OWNER TO loraserver_as;

--
-- Name: gateway_ping; Type: TABLE; Schema: public; Owner: loraserver_as
--

CREATE TABLE public.gateway_ping (
    id bigint NOT NULL,
    created_at timestamp with time zone NOT NULL,
    gateway_mac bytea NOT NULL,
    frequency integer NOT NULL,
    dr integer NOT NULL
);


ALTER TABLE public.gateway_ping OWNER TO loraserver_as;

--
-- Name: gateway_ping_id_seq; Type: SEQUENCE; Schema: public; Owner: loraserver_as
--

CREATE SEQUENCE public.gateway_ping_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.gateway_ping_id_seq OWNER TO loraserver_as;

--
-- Name: gateway_ping_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: loraserver_as
--

ALTER SEQUENCE public.gateway_ping_id_seq OWNED BY public.gateway_ping.id;


--
-- Name: gateway_ping_rx; Type: TABLE; Schema: public; Owner: loraserver_as
--

CREATE TABLE public.gateway_ping_rx (
    id bigint NOT NULL,
    created_at timestamp with time zone NOT NULL,
    ping_id bigint NOT NULL,
    gateway_mac bytea NOT NULL,
    received_at timestamp with time zone,
    rssi integer NOT NULL,
    lora_snr numeric(3,1) NOT NULL,
    location point,
    altitude double precision
);


ALTER TABLE public.gateway_ping_rx OWNER TO loraserver_as;

--
-- Name: gateway_ping_rx_id_seq; Type: SEQUENCE; Schema: public; Owner: loraserver_as
--

CREATE SEQUENCE public.gateway_ping_rx_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.gateway_ping_rx_id_seq OWNER TO loraserver_as;

--
-- Name: gateway_ping_rx_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: loraserver_as
--

ALTER SEQUENCE public.gateway_ping_rx_id_seq OWNED BY public.gateway_ping_rx.id;


--
-- Name: gateway_profile; Type: TABLE; Schema: public; Owner: loraserver_as
--

CREATE TABLE public.gateway_profile (
    gateway_profile_id uuid NOT NULL,
    network_server_id bigint NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    name character varying(100) NOT NULL
);


ALTER TABLE public.gateway_profile OWNER TO loraserver_as;

--
-- Name: gorp_migrations; Type: TABLE; Schema: public; Owner: loraserver_as
--

CREATE TABLE public.gorp_migrations (
    id text NOT NULL,
    applied_at timestamp with time zone
);


ALTER TABLE public.gorp_migrations OWNER TO loraserver_as;

--
-- Name: integration; Type: TABLE; Schema: public; Owner: loraserver_as
--

CREATE TABLE public.integration (
    id bigint NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    application_id bigint NOT NULL,
    kind character varying(20) NOT NULL,
    settings jsonb
);


ALTER TABLE public.integration OWNER TO loraserver_as;

--
-- Name: integration_id_seq; Type: SEQUENCE; Schema: public; Owner: loraserver_as
--

CREATE SEQUENCE public.integration_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.integration_id_seq OWNER TO loraserver_as;

--
-- Name: integration_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: loraserver_as
--

ALTER SEQUENCE public.integration_id_seq OWNED BY public.integration.id;


--
-- Name: multicast_group; Type: TABLE; Schema: public; Owner: loraserver_as
--

CREATE TABLE public.multicast_group (
    id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    name character varying(100) NOT NULL,
    service_profile_id uuid NOT NULL,
    mc_app_s_key bytea
);


ALTER TABLE public.multicast_group OWNER TO loraserver_as;

--
-- Name: network_server; Type: TABLE; Schema: public; Owner: loraserver_as
--

CREATE TABLE public.network_server (
    id bigint NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    name character varying(100) NOT NULL,
    server character varying(255) NOT NULL,
    ca_cert text DEFAULT ''::text NOT NULL,
    tls_cert text DEFAULT ''::text NOT NULL,
    tls_key text DEFAULT ''::text NOT NULL,
    routing_profile_ca_cert text DEFAULT ''::text NOT NULL,
    routing_profile_tls_cert text DEFAULT ''::text NOT NULL,
    routing_profile_tls_key text DEFAULT ''::text NOT NULL,
    gateway_discovery_enabled boolean DEFAULT false NOT NULL,
    gateway_discovery_interval integer DEFAULT 0 NOT NULL,
    gateway_discovery_tx_frequency integer DEFAULT 0 NOT NULL,
    gateway_discovery_dr smallint DEFAULT 0 NOT NULL
);


ALTER TABLE public.network_server OWNER TO loraserver_as;

--
-- Name: network_server_id_seq; Type: SEQUENCE; Schema: public; Owner: loraserver_as
--

CREATE SEQUENCE public.network_server_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.network_server_id_seq OWNER TO loraserver_as;

--
-- Name: network_server_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: loraserver_as
--

ALTER SEQUENCE public.network_server_id_seq OWNED BY public.network_server.id;


--
-- Name: organization; Type: TABLE; Schema: public; Owner: loraserver_as
--

CREATE TABLE public.organization (
    id bigint NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    name character varying(100) NOT NULL,
    display_name character varying(100) NOT NULL,
    can_have_gateways boolean NOT NULL
);


ALTER TABLE public.organization OWNER TO loraserver_as;

--
-- Name: organization_id_seq; Type: SEQUENCE; Schema: public; Owner: loraserver_as
--

CREATE SEQUENCE public.organization_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.organization_id_seq OWNER TO loraserver_as;

--
-- Name: organization_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: loraserver_as
--

ALTER SEQUENCE public.organization_id_seq OWNED BY public.organization.id;


--
-- Name: organization_user; Type: TABLE; Schema: public; Owner: loraserver_as
--

CREATE TABLE public.organization_user (
    id bigint NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    user_id bigint NOT NULL,
    organization_id bigint NOT NULL,
    is_admin boolean NOT NULL
);


ALTER TABLE public.organization_user OWNER TO loraserver_as;

--
-- Name: organization_user_id_seq; Type: SEQUENCE; Schema: public; Owner: loraserver_as
--

CREATE SEQUENCE public.organization_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.organization_user_id_seq OWNER TO loraserver_as;

--
-- Name: organization_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: loraserver_as
--

ALTER SEQUENCE public.organization_user_id_seq OWNED BY public.organization_user.id;


--
-- Name: service_profile; Type: TABLE; Schema: public; Owner: loraserver_as
--

CREATE TABLE public.service_profile (
    service_profile_id uuid NOT NULL,
    organization_id bigint NOT NULL,
    network_server_id bigint NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    name character varying(100) NOT NULL
);


ALTER TABLE public.service_profile OWNER TO loraserver_as;

--
-- Name: user; Type: TABLE; Schema: public; Owner: loraserver_as
--

CREATE TABLE public."user" (
    id bigint NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    username character varying(100) NOT NULL,
    password_hash character varying(200) NOT NULL,
    session_ttl bigint NOT NULL,
    is_active boolean NOT NULL,
    is_admin boolean NOT NULL,
    email text DEFAULT ''::text NOT NULL,
    note text DEFAULT ''::text NOT NULL
);


ALTER TABLE public."user" OWNER TO loraserver_as;

--
-- Name: user_id_seq; Type: SEQUENCE; Schema: public; Owner: loraserver_as
--

CREATE SEQUENCE public.user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_id_seq OWNER TO loraserver_as;

--
-- Name: user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: loraserver_as
--

ALTER SEQUENCE public.user_id_seq OWNED BY public."user".id;


--
-- Name: application id; Type: DEFAULT; Schema: public; Owner: loraserver_as
--

ALTER TABLE ONLY public.application ALTER COLUMN id SET DEFAULT nextval('public.application_id_seq'::regclass);


--
-- Name: device_activation id; Type: DEFAULT; Schema: public; Owner: loraserver_as
--

ALTER TABLE ONLY public.device_activation ALTER COLUMN id SET DEFAULT nextval('public.device_activation_id_seq'::regclass);


--
-- Name: gateway_ping id; Type: DEFAULT; Schema: public; Owner: loraserver_as
--

ALTER TABLE ONLY public.gateway_ping ALTER COLUMN id SET DEFAULT nextval('public.gateway_ping_id_seq'::regclass);


--
-- Name: gateway_ping_rx id; Type: DEFAULT; Schema: public; Owner: loraserver_as
--

ALTER TABLE ONLY public.gateway_ping_rx ALTER COLUMN id SET DEFAULT nextval('public.gateway_ping_rx_id_seq'::regclass);


--
-- Name: integration id; Type: DEFAULT; Schema: public; Owner: loraserver_as
--

ALTER TABLE ONLY public.integration ALTER COLUMN id SET DEFAULT nextval('public.integration_id_seq'::regclass);


--
-- Name: network_server id; Type: DEFAULT; Schema: public; Owner: loraserver_as
--

ALTER TABLE ONLY public.network_server ALTER COLUMN id SET DEFAULT nextval('public.network_server_id_seq'::regclass);


--
-- Name: organization id; Type: DEFAULT; Schema: public; Owner: loraserver_as
--

ALTER TABLE ONLY public.organization ALTER COLUMN id SET DEFAULT nextval('public.organization_id_seq'::regclass);


--
-- Name: organization_user id; Type: DEFAULT; Schema: public; Owner: loraserver_as
--

ALTER TABLE ONLY public.organization_user ALTER COLUMN id SET DEFAULT nextval('public.organization_user_id_seq'::regclass);


--
-- Name: user id; Type: DEFAULT; Schema: public; Owner: loraserver_as
--

ALTER TABLE ONLY public."user" ALTER COLUMN id SET DEFAULT nextval('public.user_id_seq'::regclass);


--
-- Data for Name: application; Type: TABLE DATA; Schema: public; Owner: loraserver_as
--

COPY public.application (id, name, description, organization_id, service_profile_id, payload_codec, payload_encoder_script, payload_decoder_script) FROM stdin;
1	AppModel	AppModel	1	c74edd4e-f0d0-4dcf-afe0-165bb57661ca	CUSTOM_JS	// Encode encodes the given object into an array of bytes.\n//  - fPort contains the LoRaWAN fPort number\n//  - obj is an object, e.g. {"temperature": 22.5}\n// The function must return an array of bytes, e.g. [225, 230, 255, 0]\nfunction Encode(fPort, obj) {\n  return [];\n}	// Decode decodes an array of bytes into an object.\n//  - fPort contains the LoRaWAN fPort number\n//  - bytes is an array of bytes, e.g. [225, 230, 255, 0]\n// The function must return an object, e.g. {"temperature": 22.5}\nfunction bin2String(array) {\n  return String.fromCharCode.apply(String, array);\n}\n\nfunction bin2HexStr(arr)\n \n{\n    var str = "";\n    for(var i=0; i<arr.length; i++)\n    {\n    if (i != 0)\n    {\n    \tstr += ",";\n    }\n       var tmp = arr[i].toString(16);\n       if(tmp.length == 1)\n       {\n           tmp = "0" + tmp;\n       }\n       str += "0x";\n       str += tmp;\n    }\n    return str;\n}\n\nfunction Decode(fPort, bytes) \n{\n  \tvar myObj = {"DecodeDataString":"", "DecodeDataHex":""};\n  \tvar tostring=bin2String(bytes);\n  \tvar tosHextring=bin2HexStr(bytes);\n  \tmyObj.DecodeDataString = tostring;\n  \tmyObj.DecodeDataHex = tosHextring;\n\treturn myObj;\n}
\.


--
-- Name: application_id_seq; Type: SEQUENCE SET; Schema: public; Owner: loraserver_as
--

SELECT pg_catalog.setval('public.application_id_seq', 1, true);


--
-- Data for Name: device; Type: TABLE DATA; Schema: public; Owner: loraserver_as
--

COPY public.device (dev_eui, created_at, updated_at, application_id, device_profile_id, name, description, last_seen_at, device_status_battery, device_status_margin, latitude, longitude, altitude, device_status_external_power_source) FROM stdin;
\\x0000000000000666	2019-04-12 03:39:22.54574+00	2019-04-12 03:39:22.54574+00	1	2ebc845c-878a-4b28-a4bd-40eb7631f5a0	DeviceModel	DeviceModel	\N	\N	\N	\N	\N	\N	f
\.


--
-- Data for Name: device_activation; Type: TABLE DATA; Schema: public; Owner: loraserver_as
--

COPY public.device_activation (id, created_at, dev_eui, dev_addr, app_s_key) FROM stdin;
\.


--
-- Name: device_activation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: loraserver_as
--

SELECT pg_catalog.setval('public.device_activation_id_seq', 1, false);


--
-- Data for Name: device_keys; Type: TABLE DATA; Schema: public; Owner: loraserver_as
--

COPY public.device_keys (dev_eui, created_at, updated_at, nwk_key, join_nonce, app_key) FROM stdin;
\\x0000000000000666	2019-04-12 03:39:55.952325+00	2019-04-12 03:39:55.952325+00	\\x00000000000000000000000000000666	0	\\x00000000000000000000000000000000
\.


--
-- Data for Name: device_multicast_group; Type: TABLE DATA; Schema: public; Owner: loraserver_as
--

COPY public.device_multicast_group (dev_eui, multicast_group_id, created_at) FROM stdin;
\.


--
-- Data for Name: device_profile; Type: TABLE DATA; Schema: public; Owner: loraserver_as
--

COPY public.device_profile (device_profile_id, network_server_id, organization_id, created_at, updated_at, name) FROM stdin;
2ebc845c-878a-4b28-a4bd-40eb7631f5a0	1	1	2019-04-12 03:27:08.984752+00	2019-04-12 03:38:07.043348+00	DeviceProfileModel
\.


--
-- Data for Name: gateway; Type: TABLE DATA; Schema: public; Owner: loraserver_as
--

COPY public.gateway (mac, created_at, updated_at, name, description, organization_id, ping, last_ping_id, last_ping_sent_at, network_server_id, gateway_profile_id) FROM stdin;
\\x0000000000000888	2019-04-12 03:34:03.122543+00	2019-04-12 03:38:39.312415+00	GwModel	GwModel	1	f	\N	\N	1	\N
\.


--
-- Data for Name: gateway_ping; Type: TABLE DATA; Schema: public; Owner: loraserver_as
--

COPY public.gateway_ping (id, created_at, gateway_mac, frequency, dr) FROM stdin;
\.


--
-- Name: gateway_ping_id_seq; Type: SEQUENCE SET; Schema: public; Owner: loraserver_as
--

SELECT pg_catalog.setval('public.gateway_ping_id_seq', 1, false);


--
-- Data for Name: gateway_ping_rx; Type: TABLE DATA; Schema: public; Owner: loraserver_as
--

COPY public.gateway_ping_rx (id, created_at, ping_id, gateway_mac, received_at, rssi, lora_snr, location, altitude) FROM stdin;
\.


--
-- Name: gateway_ping_rx_id_seq; Type: SEQUENCE SET; Schema: public; Owner: loraserver_as
--

SELECT pg_catalog.setval('public.gateway_ping_rx_id_seq', 1, false);


--
-- Data for Name: gateway_profile; Type: TABLE DATA; Schema: public; Owner: loraserver_as
--

COPY public.gateway_profile (gateway_profile_id, network_server_id, created_at, updated_at, name) FROM stdin;
fab572ae-5477-4d4c-adb7-fac4ec7685f7	1	2019-04-12 03:26:20.20254+00	2019-04-12 03:37:48.469602+00	GwProfileModel
\.


--
-- Data for Name: gorp_migrations; Type: TABLE DATA; Schema: public; Owner: loraserver_as
--

COPY public.gorp_migrations (id, applied_at) FROM stdin;
0001_initial.sql	2019-04-12 03:20:46.311357+00
0002_join_accept_params.sql	2019-04-12 03:20:46.857353+00
0003_rx_window_and_rx2_dr.sql	2019-04-12 03:20:47.064512+00
0004_add_node_apps_nwks_key_name_devaddr.sql	2019-04-12 03:20:47.232399+00
0005_add_queue.sql	2019-04-12 03:20:47.39108+00
0006_remove_application_table.sql	2019-04-12 03:20:47.454152+00
0007_migrate_channels_to_channel_list.sql	2019-04-12 03:20:47.532321+00
0008_relax_fcnt.sql	2019-04-12 03:20:47.717645+00
0009_adr_interval_and_install_margin.sql	2019-04-12 03:20:48.473129+00
0010_recreate_application_table.sql	2019-04-12 03:20:48.907507+00
0011_node_description_and_is_abp.sql	2019-04-12 03:20:49.731226+00
0012_class_c_node.sql	2019-04-12 03:20:50.829534+00
0013_application_settings.sql	2019-04-12 03:20:51.553862+00
0014_users_and_application_users.sql	2019-04-12 03:20:51.791626+00
0015_organizations.sql	2019-04-12 03:20:53.669313+00
0016_delete_channel_list.sql	2019-04-12 03:20:53.70016+00
0017_integrations.sql	2019-04-12 03:20:54.213869+00
0018_gateway_ping.sql	2019-04-12 03:20:54.855765+00
0019_node_prefix_search.sql	2019-04-12 03:20:54.9012+00
0020_backend_interfaces.sql	2019-04-12 03:21:01.305051+00
0021_user_email_and_note.sql	2019-04-12 03:21:02.39088+00
0022_add_device_queue_mapping.sql	2019-04-12 03:21:02.464299+00
0023_payload_decoder.sql	2019-04-12 03:21:03.191232+00
0024_network_server_certs.sql	2019-04-12 03:21:03.335049+00
0025_device_status.sql	2019-04-12 03:21:03.348924+00
0026_network_server_gw_discovery.sql	2019-04-12 03:21:03.424943+00
0027_global_search.sql	2019-04-12 03:21:03.483721+00
0028_gateway_profile.sql	2019-04-12 03:21:03.593148+00
0029_cleanup_old_tables.sql	2019-04-12 03:21:03.63276+00
0030_lorawan_11_keys.sql	2019-04-12 03:21:03.739746+00
0031_cleanup_indices.sql	2019-04-12 03:21:03.762275+00
0032_fix_table_constraints.sql	2019-04-12 03:21:05.003679+00
0033_drop_device_queue_mapping.sql	2019-04-12 03:21:05.020512+00
0034_drop_nwk_session_keys.sql	2019-04-12 03:21:05.032704+00
0035_multicast.sql	2019-04-12 03:21:05.119361+00
0036_device_location.sql	2019-04-12 03:21:05.124437+00
0037_fix_device_status.sql	2019-04-12 03:21:05.583111+00
\.


--
-- Data for Name: integration; Type: TABLE DATA; Schema: public; Owner: loraserver_as
--

COPY public.integration (id, created_at, updated_at, application_id, kind, settings) FROM stdin;
\.


--
-- Name: integration_id_seq; Type: SEQUENCE SET; Schema: public; Owner: loraserver_as
--

SELECT pg_catalog.setval('public.integration_id_seq', 1, false);


--
-- Data for Name: multicast_group; Type: TABLE DATA; Schema: public; Owner: loraserver_as
--

COPY public.multicast_group (id, created_at, updated_at, name, service_profile_id, mc_app_s_key) FROM stdin;
\.


--
-- Data for Name: network_server; Type: TABLE DATA; Schema: public; Owner: loraserver_as
--

COPY public.network_server (id, created_at, updated_at, name, server, ca_cert, tls_cert, tls_key, routing_profile_ca_cert, routing_profile_tls_cert, routing_profile_tls_key, gateway_discovery_enabled, gateway_discovery_interval, gateway_discovery_tx_frequency, gateway_discovery_dr) FROM stdin;
1	2019-04-12 03:25:45.93949+00	2019-04-12 03:37:41.512309+00	NetServerModel	127.0.0.1:8000							f	0	0	0
\.


--
-- Name: network_server_id_seq; Type: SEQUENCE SET; Schema: public; Owner: loraserver_as
--

SELECT pg_catalog.setval('public.network_server_id_seq', 1, true);


--
-- Data for Name: organization; Type: TABLE DATA; Schema: public; Owner: loraserver_as
--

COPY public.organization (id, created_at, updated_at, name, display_name, can_have_gateways) FROM stdin;
1	2019-04-12 03:20:51.796536+00	2019-04-12 03:20:51.796536+00	loraserver	LoRa Server	t
\.


--
-- Name: organization_id_seq; Type: SEQUENCE SET; Schema: public; Owner: loraserver_as
--

SELECT pg_catalog.setval('public.organization_id_seq', 1, true);


--
-- Data for Name: organization_user; Type: TABLE DATA; Schema: public; Owner: loraserver_as
--

COPY public.organization_user (id, created_at, updated_at, user_id, organization_id, is_admin) FROM stdin;
1	2019-04-12 03:20:51.796536+00	2019-04-12 03:20:51.796536+00	1	1	t
\.


--
-- Name: organization_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: loraserver_as
--

SELECT pg_catalog.setval('public.organization_user_id_seq', 1, true);


--
-- Data for Name: service_profile; Type: TABLE DATA; Schema: public; Owner: loraserver_as
--

COPY public.service_profile (service_profile_id, organization_id, network_server_id, created_at, updated_at, name) FROM stdin;
c74edd4e-f0d0-4dcf-afe0-165bb57661ca	1	1	2019-04-12 03:26:45.796784+00	2019-04-12 03:37:59.256295+00	ServiceProfileModel
\.


--
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: loraserver_as
--

COPY public."user" (id, created_at, updated_at, username, password_hash, session_ttl, is_active, is_admin, email, note) FROM stdin;
1	2019-04-12 03:20:51.568686+00	2019-04-12 03:20:51.568686+00	admin	PBKDF2$sha512$100000$4u3hL8krvlMIS0KnCYXeMw==$G7c7tuUYq2zSJaUeruvNL/KF30d3TVDORVD56wzvJYmc3muWjoaozH8bHJ7r8zY8dW6Pts2bWyhFfkb/ubQZsA==	0	t	t		
\.


--
-- Name: user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: loraserver_as
--

SELECT pg_catalog.setval('public.user_id_seq', 1, true);


--
-- Name: application application_name_organization_id_key; Type: CONSTRAINT; Schema: public; Owner: loraserver_as
--

ALTER TABLE ONLY public.application
    ADD CONSTRAINT application_name_organization_id_key UNIQUE (name, organization_id);


--
-- Name: application application_pkey; Type: CONSTRAINT; Schema: public; Owner: loraserver_as
--

ALTER TABLE ONLY public.application
    ADD CONSTRAINT application_pkey PRIMARY KEY (id);


--
-- Name: device_activation device_activation_pkey; Type: CONSTRAINT; Schema: public; Owner: loraserver_as
--

ALTER TABLE ONLY public.device_activation
    ADD CONSTRAINT device_activation_pkey PRIMARY KEY (id);


--
-- Name: device_keys device_keys_pkey; Type: CONSTRAINT; Schema: public; Owner: loraserver_as
--

ALTER TABLE ONLY public.device_keys
    ADD CONSTRAINT device_keys_pkey PRIMARY KEY (dev_eui);


--
-- Name: device_multicast_group device_multicast_group_pkey; Type: CONSTRAINT; Schema: public; Owner: loraserver_as
--

ALTER TABLE ONLY public.device_multicast_group
    ADD CONSTRAINT device_multicast_group_pkey PRIMARY KEY (multicast_group_id, dev_eui);


--
-- Name: device device_pkey; Type: CONSTRAINT; Schema: public; Owner: loraserver_as
--

ALTER TABLE ONLY public.device
    ADD CONSTRAINT device_pkey PRIMARY KEY (dev_eui);


--
-- Name: device_profile device_profile_pkey; Type: CONSTRAINT; Schema: public; Owner: loraserver_as
--

ALTER TABLE ONLY public.device_profile
    ADD CONSTRAINT device_profile_pkey PRIMARY KEY (device_profile_id);


--
-- Name: gateway gateway_name_organization_id_key; Type: CONSTRAINT; Schema: public; Owner: loraserver_as
--

ALTER TABLE ONLY public.gateway
    ADD CONSTRAINT gateway_name_organization_id_key UNIQUE (name, organization_id);


--
-- Name: gateway_ping gateway_ping_pkey; Type: CONSTRAINT; Schema: public; Owner: loraserver_as
--

ALTER TABLE ONLY public.gateway_ping
    ADD CONSTRAINT gateway_ping_pkey PRIMARY KEY (id);


--
-- Name: gateway_ping_rx gateway_ping_rx_pkey; Type: CONSTRAINT; Schema: public; Owner: loraserver_as
--

ALTER TABLE ONLY public.gateway_ping_rx
    ADD CONSTRAINT gateway_ping_rx_pkey PRIMARY KEY (id);


--
-- Name: gateway gateway_pkey; Type: CONSTRAINT; Schema: public; Owner: loraserver_as
--

ALTER TABLE ONLY public.gateway
    ADD CONSTRAINT gateway_pkey PRIMARY KEY (mac);


--
-- Name: gateway_profile gateway_profile_pkey; Type: CONSTRAINT; Schema: public; Owner: loraserver_as
--

ALTER TABLE ONLY public.gateway_profile
    ADD CONSTRAINT gateway_profile_pkey PRIMARY KEY (gateway_profile_id);


--
-- Name: gorp_migrations gorp_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: loraserver_as
--

ALTER TABLE ONLY public.gorp_migrations
    ADD CONSTRAINT gorp_migrations_pkey PRIMARY KEY (id);


--
-- Name: integration integration_kind_application_id; Type: CONSTRAINT; Schema: public; Owner: loraserver_as
--

ALTER TABLE ONLY public.integration
    ADD CONSTRAINT integration_kind_application_id UNIQUE (kind, application_id);


--
-- Name: integration integration_pkey; Type: CONSTRAINT; Schema: public; Owner: loraserver_as
--

ALTER TABLE ONLY public.integration
    ADD CONSTRAINT integration_pkey PRIMARY KEY (id);


--
-- Name: multicast_group multicast_group_pkey; Type: CONSTRAINT; Schema: public; Owner: loraserver_as
--

ALTER TABLE ONLY public.multicast_group
    ADD CONSTRAINT multicast_group_pkey PRIMARY KEY (id);


--
-- Name: network_server network_server_pkey; Type: CONSTRAINT; Schema: public; Owner: loraserver_as
--

ALTER TABLE ONLY public.network_server
    ADD CONSTRAINT network_server_pkey PRIMARY KEY (id);


--
-- Name: organization organization_pkey; Type: CONSTRAINT; Schema: public; Owner: loraserver_as
--

ALTER TABLE ONLY public.organization
    ADD CONSTRAINT organization_pkey PRIMARY KEY (id);


--
-- Name: organization_user organization_user_pkey; Type: CONSTRAINT; Schema: public; Owner: loraserver_as
--

ALTER TABLE ONLY public.organization_user
    ADD CONSTRAINT organization_user_pkey PRIMARY KEY (id);


--
-- Name: organization_user organization_user_user_id_organization_id_key; Type: CONSTRAINT; Schema: public; Owner: loraserver_as
--

ALTER TABLE ONLY public.organization_user
    ADD CONSTRAINT organization_user_user_id_organization_id_key UNIQUE (user_id, organization_id);


--
-- Name: service_profile service_profile_pkey; Type: CONSTRAINT; Schema: public; Owner: loraserver_as
--

ALTER TABLE ONLY public.service_profile
    ADD CONSTRAINT service_profile_pkey PRIMARY KEY (service_profile_id);


--
-- Name: user user_pkey; Type: CONSTRAINT; Schema: public; Owner: loraserver_as
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (id);


--
-- Name: idx_application_name_trgm; Type: INDEX; Schema: public; Owner: loraserver_as
--

CREATE INDEX idx_application_name_trgm ON public.application USING gin (name public.gin_trgm_ops);


--
-- Name: idx_application_organization_id; Type: INDEX; Schema: public; Owner: loraserver_as
--

CREATE INDEX idx_application_organization_id ON public.application USING btree (organization_id);


--
-- Name: idx_application_service_profile_id; Type: INDEX; Schema: public; Owner: loraserver_as
--

CREATE INDEX idx_application_service_profile_id ON public.application USING btree (service_profile_id);


--
-- Name: idx_device_activation_dev_eui; Type: INDEX; Schema: public; Owner: loraserver_as
--

CREATE INDEX idx_device_activation_dev_eui ON public.device_activation USING btree (dev_eui);


--
-- Name: idx_device_application_id; Type: INDEX; Schema: public; Owner: loraserver_as
--

CREATE INDEX idx_device_application_id ON public.device USING btree (application_id);


--
-- Name: idx_device_dev_eui_trgm; Type: INDEX; Schema: public; Owner: loraserver_as
--

CREATE INDEX idx_device_dev_eui_trgm ON public.device USING gin (encode(dev_eui, 'hex'::text) public.gin_trgm_ops);


--
-- Name: idx_device_device_profile_id; Type: INDEX; Schema: public; Owner: loraserver_as
--

CREATE INDEX idx_device_device_profile_id ON public.device USING btree (device_profile_id);


--
-- Name: idx_device_name_application_id; Type: INDEX; Schema: public; Owner: loraserver_as
--

CREATE UNIQUE INDEX idx_device_name_application_id ON public.device USING btree (name, application_id);


--
-- Name: idx_device_name_trgm; Type: INDEX; Schema: public; Owner: loraserver_as
--

CREATE INDEX idx_device_name_trgm ON public.device USING gin (name public.gin_trgm_ops);


--
-- Name: idx_device_profile_network_server_id; Type: INDEX; Schema: public; Owner: loraserver_as
--

CREATE INDEX idx_device_profile_network_server_id ON public.device_profile USING btree (network_server_id);


--
-- Name: idx_device_profile_organization_id; Type: INDEX; Schema: public; Owner: loraserver_as
--

CREATE INDEX idx_device_profile_organization_id ON public.device_profile USING btree (organization_id);


--
-- Name: idx_gateway_gateway_profile_id; Type: INDEX; Schema: public; Owner: loraserver_as
--

CREATE INDEX idx_gateway_gateway_profile_id ON public.gateway USING btree (gateway_profile_id);


--
-- Name: idx_gateway_last_ping_sent_at; Type: INDEX; Schema: public; Owner: loraserver_as
--

CREATE INDEX idx_gateway_last_ping_sent_at ON public.gateway USING btree (last_ping_sent_at);


--
-- Name: idx_gateway_mac_trgm; Type: INDEX; Schema: public; Owner: loraserver_as
--

CREATE INDEX idx_gateway_mac_trgm ON public.gateway USING gin (encode(mac, 'hex'::text) public.gin_trgm_ops);


--
-- Name: idx_gateway_name_organization_id; Type: INDEX; Schema: public; Owner: loraserver_as
--

CREATE UNIQUE INDEX idx_gateway_name_organization_id ON public.gateway USING btree (name, organization_id);


--
-- Name: idx_gateway_name_trgm; Type: INDEX; Schema: public; Owner: loraserver_as
--

CREATE INDEX idx_gateway_name_trgm ON public.gateway USING gin (name public.gin_trgm_ops);


--
-- Name: idx_gateway_network_server_id; Type: INDEX; Schema: public; Owner: loraserver_as
--

CREATE INDEX idx_gateway_network_server_id ON public.gateway USING btree (network_server_id);


--
-- Name: idx_gateway_organization_id; Type: INDEX; Schema: public; Owner: loraserver_as
--

CREATE INDEX idx_gateway_organization_id ON public.gateway USING btree (organization_id);


--
-- Name: idx_gateway_ping; Type: INDEX; Schema: public; Owner: loraserver_as
--

CREATE INDEX idx_gateway_ping ON public.gateway USING btree (ping);


--
-- Name: idx_gateway_ping_gateway_mac; Type: INDEX; Schema: public; Owner: loraserver_as
--

CREATE INDEX idx_gateway_ping_gateway_mac ON public.gateway_ping USING btree (gateway_mac);


--
-- Name: idx_gateway_ping_rx_gateway_mac; Type: INDEX; Schema: public; Owner: loraserver_as
--

CREATE INDEX idx_gateway_ping_rx_gateway_mac ON public.gateway_ping_rx USING btree (gateway_mac);


--
-- Name: idx_gateway_ping_rx_ping_id; Type: INDEX; Schema: public; Owner: loraserver_as
--

CREATE INDEX idx_gateway_ping_rx_ping_id ON public.gateway_ping_rx USING btree (ping_id);


--
-- Name: idx_gateway_profile_network_server_id; Type: INDEX; Schema: public; Owner: loraserver_as
--

CREATE INDEX idx_gateway_profile_network_server_id ON public.gateway_profile USING btree (network_server_id);


--
-- Name: idx_integration_application_id; Type: INDEX; Schema: public; Owner: loraserver_as
--

CREATE INDEX idx_integration_application_id ON public.integration USING btree (application_id);


--
-- Name: idx_integration_kind; Type: INDEX; Schema: public; Owner: loraserver_as
--

CREATE INDEX idx_integration_kind ON public.integration USING btree (kind);


--
-- Name: idx_multicast_group_name_trgm; Type: INDEX; Schema: public; Owner: loraserver_as
--

CREATE INDEX idx_multicast_group_name_trgm ON public.multicast_group USING gin (name public.gin_trgm_ops);


--
-- Name: idx_multicast_group_service_profile_id; Type: INDEX; Schema: public; Owner: loraserver_as
--

CREATE INDEX idx_multicast_group_service_profile_id ON public.multicast_group USING btree (service_profile_id);


--
-- Name: idx_organization_name; Type: INDEX; Schema: public; Owner: loraserver_as
--

CREATE UNIQUE INDEX idx_organization_name ON public.organization USING btree (name);


--
-- Name: idx_organization_name_trgm; Type: INDEX; Schema: public; Owner: loraserver_as
--

CREATE INDEX idx_organization_name_trgm ON public.organization USING gin (name public.gin_trgm_ops);


--
-- Name: idx_organization_user_organization_id; Type: INDEX; Schema: public; Owner: loraserver_as
--

CREATE INDEX idx_organization_user_organization_id ON public.organization_user USING btree (organization_id);


--
-- Name: idx_organization_user_user_id; Type: INDEX; Schema: public; Owner: loraserver_as
--

CREATE INDEX idx_organization_user_user_id ON public.organization_user USING btree (user_id);


--
-- Name: idx_service_profile_network_server_id; Type: INDEX; Schema: public; Owner: loraserver_as
--

CREATE INDEX idx_service_profile_network_server_id ON public.service_profile USING btree (network_server_id);


--
-- Name: idx_service_profile_organization_id; Type: INDEX; Schema: public; Owner: loraserver_as
--

CREATE INDEX idx_service_profile_organization_id ON public.service_profile USING btree (organization_id);


--
-- Name: idx_user_username; Type: INDEX; Schema: public; Owner: loraserver_as
--

CREATE UNIQUE INDEX idx_user_username ON public."user" USING btree (username);


--
-- Name: idx_user_username_trgm; Type: INDEX; Schema: public; Owner: loraserver_as
--

CREATE INDEX idx_user_username_trgm ON public."user" USING gin (username public.gin_trgm_ops);


--
-- Name: application application_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: loraserver_as
--

ALTER TABLE ONLY public.application
    ADD CONSTRAINT application_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organization(id) ON DELETE CASCADE;


--
-- Name: application application_service_profile_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: loraserver_as
--

ALTER TABLE ONLY public.application
    ADD CONSTRAINT application_service_profile_id_fkey FOREIGN KEY (service_profile_id) REFERENCES public.service_profile(service_profile_id);


--
-- Name: device_activation device_activation_dev_eui_fkey; Type: FK CONSTRAINT; Schema: public; Owner: loraserver_as
--

ALTER TABLE ONLY public.device_activation
    ADD CONSTRAINT device_activation_dev_eui_fkey FOREIGN KEY (dev_eui) REFERENCES public.device(dev_eui) ON DELETE CASCADE;


--
-- Name: device device_application_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: loraserver_as
--

ALTER TABLE ONLY public.device
    ADD CONSTRAINT device_application_id_fkey FOREIGN KEY (application_id) REFERENCES public.application(id);


--
-- Name: device device_device_profile_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: loraserver_as
--

ALTER TABLE ONLY public.device
    ADD CONSTRAINT device_device_profile_id_fkey FOREIGN KEY (device_profile_id) REFERENCES public.device_profile(device_profile_id);


--
-- Name: device_keys device_keys_dev_eui_fkey; Type: FK CONSTRAINT; Schema: public; Owner: loraserver_as
--

ALTER TABLE ONLY public.device_keys
    ADD CONSTRAINT device_keys_dev_eui_fkey FOREIGN KEY (dev_eui) REFERENCES public.device(dev_eui) ON DELETE CASCADE;


--
-- Name: device_multicast_group device_multicast_group_dev_eui_fkey; Type: FK CONSTRAINT; Schema: public; Owner: loraserver_as
--

ALTER TABLE ONLY public.device_multicast_group
    ADD CONSTRAINT device_multicast_group_dev_eui_fkey FOREIGN KEY (dev_eui) REFERENCES public.device(dev_eui) ON DELETE CASCADE;


--
-- Name: device_multicast_group device_multicast_group_multicast_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: loraserver_as
--

ALTER TABLE ONLY public.device_multicast_group
    ADD CONSTRAINT device_multicast_group_multicast_group_id_fkey FOREIGN KEY (multicast_group_id) REFERENCES public.multicast_group(id) ON DELETE CASCADE;


--
-- Name: device_profile device_profile_network_server_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: loraserver_as
--

ALTER TABLE ONLY public.device_profile
    ADD CONSTRAINT device_profile_network_server_id_fkey FOREIGN KEY (network_server_id) REFERENCES public.network_server(id);


--
-- Name: device_profile device_profile_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: loraserver_as
--

ALTER TABLE ONLY public.device_profile
    ADD CONSTRAINT device_profile_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organization(id);


--
-- Name: gateway gateway_gateway_profile_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: loraserver_as
--

ALTER TABLE ONLY public.gateway
    ADD CONSTRAINT gateway_gateway_profile_id_fkey FOREIGN KEY (gateway_profile_id) REFERENCES public.gateway_profile(gateway_profile_id);


--
-- Name: gateway gateway_last_ping_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: loraserver_as
--

ALTER TABLE ONLY public.gateway
    ADD CONSTRAINT gateway_last_ping_id_fkey FOREIGN KEY (last_ping_id) REFERENCES public.gateway_ping(id) ON DELETE SET NULL;


--
-- Name: gateway gateway_network_server_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: loraserver_as
--

ALTER TABLE ONLY public.gateway
    ADD CONSTRAINT gateway_network_server_id_fkey FOREIGN KEY (network_server_id) REFERENCES public.network_server(id);


--
-- Name: gateway gateway_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: loraserver_as
--

ALTER TABLE ONLY public.gateway
    ADD CONSTRAINT gateway_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organization(id) ON DELETE CASCADE;


--
-- Name: gateway_ping gateway_ping_gateway_mac_fkey; Type: FK CONSTRAINT; Schema: public; Owner: loraserver_as
--

ALTER TABLE ONLY public.gateway_ping
    ADD CONSTRAINT gateway_ping_gateway_mac_fkey FOREIGN KEY (gateway_mac) REFERENCES public.gateway(mac) ON DELETE CASCADE;


--
-- Name: gateway_ping_rx gateway_ping_rx_gateway_mac_fkey; Type: FK CONSTRAINT; Schema: public; Owner: loraserver_as
--

ALTER TABLE ONLY public.gateway_ping_rx
    ADD CONSTRAINT gateway_ping_rx_gateway_mac_fkey FOREIGN KEY (gateway_mac) REFERENCES public.gateway(mac) ON DELETE CASCADE;


--
-- Name: gateway_ping_rx gateway_ping_rx_ping_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: loraserver_as
--

ALTER TABLE ONLY public.gateway_ping_rx
    ADD CONSTRAINT gateway_ping_rx_ping_id_fkey FOREIGN KEY (ping_id) REFERENCES public.gateway_ping(id) ON DELETE CASCADE;


--
-- Name: gateway_profile gateway_profile_network_server_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: loraserver_as
--

ALTER TABLE ONLY public.gateway_profile
    ADD CONSTRAINT gateway_profile_network_server_id_fkey FOREIGN KEY (network_server_id) REFERENCES public.network_server(id);


--
-- Name: integration integration_application_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: loraserver_as
--

ALTER TABLE ONLY public.integration
    ADD CONSTRAINT integration_application_id_fkey FOREIGN KEY (application_id) REFERENCES public.application(id) ON DELETE CASCADE;


--
-- Name: multicast_group multicast_group_service_profile_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: loraserver_as
--

ALTER TABLE ONLY public.multicast_group
    ADD CONSTRAINT multicast_group_service_profile_id_fkey FOREIGN KEY (service_profile_id) REFERENCES public.service_profile(service_profile_id);


--
-- Name: organization_user organization_user_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: loraserver_as
--

ALTER TABLE ONLY public.organization_user
    ADD CONSTRAINT organization_user_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organization(id) ON DELETE CASCADE;


--
-- Name: organization_user organization_user_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: loraserver_as
--

ALTER TABLE ONLY public.organization_user
    ADD CONSTRAINT organization_user_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id) ON DELETE CASCADE;


--
-- Name: service_profile service_profile_network_server_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: loraserver_as
--

ALTER TABLE ONLY public.service_profile
    ADD CONSTRAINT service_profile_network_server_id_fkey FOREIGN KEY (network_server_id) REFERENCES public.network_server(id);


--
-- Name: service_profile service_profile_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: loraserver_as
--

ALTER TABLE ONLY public.service_profile
    ADD CONSTRAINT service_profile_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organization(id);


--
-- PostgreSQL database dump complete
--

\connect loraserver_ns

SET default_transaction_read_only = off;

--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.11
-- Dumped by pg_dump version 9.6.11

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: code_migration; Type: TABLE; Schema: public; Owner: loraserver_ns
--

CREATE TABLE public.code_migration (
    id text NOT NULL,
    applied_at timestamp with time zone NOT NULL
);


ALTER TABLE public.code_migration OWNER TO loraserver_ns;

--
-- Name: device; Type: TABLE; Schema: public; Owner: loraserver_ns
--

CREATE TABLE public.device (
    dev_eui bytea NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    device_profile_id uuid NOT NULL,
    service_profile_id uuid NOT NULL,
    routing_profile_id uuid NOT NULL,
    skip_fcnt_check boolean DEFAULT false NOT NULL,
    reference_altitude double precision NOT NULL,
    mode character(1) NOT NULL
);


ALTER TABLE public.device OWNER TO loraserver_ns;

--
-- Name: device_activation; Type: TABLE; Schema: public; Owner: loraserver_ns
--

CREATE TABLE public.device_activation (
    id bigint NOT NULL,
    created_at timestamp with time zone NOT NULL,
    dev_eui bytea NOT NULL,
    join_eui bytea NOT NULL,
    dev_addr bytea NOT NULL,
    f_nwk_s_int_key bytea NOT NULL,
    s_nwk_s_int_key bytea NOT NULL,
    nwk_s_enc_key bytea NOT NULL,
    dev_nonce integer NOT NULL,
    join_req_type smallint NOT NULL
);


ALTER TABLE public.device_activation OWNER TO loraserver_ns;

--
-- Name: device_activation_id_seq; Type: SEQUENCE; Schema: public; Owner: loraserver_ns
--

CREATE SEQUENCE public.device_activation_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.device_activation_id_seq OWNER TO loraserver_ns;

--
-- Name: device_activation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: loraserver_ns
--

ALTER SEQUENCE public.device_activation_id_seq OWNED BY public.device_activation.id;


--
-- Name: device_multicast_group; Type: TABLE; Schema: public; Owner: loraserver_ns
--

CREATE TABLE public.device_multicast_group (
    dev_eui bytea NOT NULL,
    multicast_group_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL
);


ALTER TABLE public.device_multicast_group OWNER TO loraserver_ns;

--
-- Name: device_profile; Type: TABLE; Schema: public; Owner: loraserver_ns
--

CREATE TABLE public.device_profile (
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    device_profile_id uuid NOT NULL,
    supports_class_b boolean NOT NULL,
    class_b_timeout integer NOT NULL,
    ping_slot_period integer NOT NULL,
    ping_slot_dr integer NOT NULL,
    ping_slot_freq integer NOT NULL,
    supports_class_c boolean NOT NULL,
    class_c_timeout integer NOT NULL,
    mac_version character varying(10) NOT NULL,
    reg_params_revision character varying(10) NOT NULL,
    rx_delay_1 integer NOT NULL,
    rx_dr_offset_1 integer NOT NULL,
    rx_data_rate_2 integer NOT NULL,
    rx_freq_2 integer NOT NULL,
    factory_preset_freqs integer[],
    max_eirp integer NOT NULL,
    max_duty_cycle integer NOT NULL,
    supports_join boolean NOT NULL,
    rf_region character varying(20) NOT NULL,
    supports_32bit_fcnt boolean NOT NULL
);


ALTER TABLE public.device_profile OWNER TO loraserver_ns;

--
-- Name: device_queue; Type: TABLE; Schema: public; Owner: loraserver_ns
--

CREATE TABLE public.device_queue (
    id bigint NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    dev_eui bytea,
    frm_payload bytea,
    f_cnt integer NOT NULL,
    f_port integer NOT NULL,
    confirmed boolean NOT NULL,
    is_pending boolean NOT NULL,
    timeout_after timestamp with time zone,
    emit_at_time_since_gps_epoch bigint
);


ALTER TABLE public.device_queue OWNER TO loraserver_ns;

--
-- Name: device_queue_id_seq; Type: SEQUENCE; Schema: public; Owner: loraserver_ns
--

CREATE SEQUENCE public.device_queue_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.device_queue_id_seq OWNER TO loraserver_ns;

--
-- Name: device_queue_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: loraserver_ns
--

ALTER SEQUENCE public.device_queue_id_seq OWNED BY public.device_queue.id;


--
-- Name: gateway; Type: TABLE; Schema: public; Owner: loraserver_ns
--

CREATE TABLE public.gateway (
    gateway_id bytea NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    first_seen_at timestamp with time zone,
    last_seen_at timestamp with time zone,
    location point NOT NULL,
    altitude double precision NOT NULL,
    gateway_profile_id uuid
);


ALTER TABLE public.gateway OWNER TO loraserver_ns;

--
-- Name: gateway_board; Type: TABLE; Schema: public; Owner: loraserver_ns
--

CREATE TABLE public.gateway_board (
    id smallint NOT NULL,
    gateway_id bytea NOT NULL,
    fpga_id bytea,
    fine_timestamp_key bytea
);


ALTER TABLE public.gateway_board OWNER TO loraserver_ns;

--
-- Name: gateway_profile; Type: TABLE; Schema: public; Owner: loraserver_ns
--

CREATE TABLE public.gateway_profile (
    gateway_profile_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    channels smallint[] NOT NULL
);


ALTER TABLE public.gateway_profile OWNER TO loraserver_ns;

--
-- Name: gateway_profile_extra_channel; Type: TABLE; Schema: public; Owner: loraserver_ns
--

CREATE TABLE public.gateway_profile_extra_channel (
    id bigint NOT NULL,
    gateway_profile_id uuid NOT NULL,
    modulation character varying(10) NOT NULL,
    frequency integer NOT NULL,
    bandwidth integer NOT NULL,
    bitrate integer NOT NULL,
    spreading_factors smallint[]
);


ALTER TABLE public.gateway_profile_extra_channel OWNER TO loraserver_ns;

--
-- Name: gateway_profile_extra_channel_id_seq; Type: SEQUENCE; Schema: public; Owner: loraserver_ns
--

CREATE SEQUENCE public.gateway_profile_extra_channel_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.gateway_profile_extra_channel_id_seq OWNER TO loraserver_ns;

--
-- Name: gateway_profile_extra_channel_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: loraserver_ns
--

ALTER SEQUENCE public.gateway_profile_extra_channel_id_seq OWNED BY public.gateway_profile_extra_channel.id;


--
-- Name: gateway_stats; Type: TABLE; Schema: public; Owner: loraserver_ns
--

CREATE TABLE public.gateway_stats (
    id bigint NOT NULL,
    gateway_id bytea NOT NULL,
    "timestamp" timestamp with time zone NOT NULL,
    "interval" character varying(10) NOT NULL,
    rx_packets_received integer NOT NULL,
    rx_packets_received_ok integer NOT NULL,
    tx_packets_received integer NOT NULL,
    tx_packets_emitted integer NOT NULL
);


ALTER TABLE public.gateway_stats OWNER TO loraserver_ns;

--
-- Name: gateway_stats_id_seq; Type: SEQUENCE; Schema: public; Owner: loraserver_ns
--

CREATE SEQUENCE public.gateway_stats_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.gateway_stats_id_seq OWNER TO loraserver_ns;

--
-- Name: gateway_stats_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: loraserver_ns
--

ALTER SEQUENCE public.gateway_stats_id_seq OWNED BY public.gateway_stats.id;


--
-- Name: gorp_migrations; Type: TABLE; Schema: public; Owner: loraserver_ns
--

CREATE TABLE public.gorp_migrations (
    id text NOT NULL,
    applied_at timestamp with time zone
);


ALTER TABLE public.gorp_migrations OWNER TO loraserver_ns;

--
-- Name: multicast_group; Type: TABLE; Schema: public; Owner: loraserver_ns
--

CREATE TABLE public.multicast_group (
    id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    mc_addr bytea,
    mc_nwk_s_key bytea,
    f_cnt integer NOT NULL,
    group_type character(1) NOT NULL,
    dr integer NOT NULL,
    frequency integer NOT NULL,
    ping_slot_period integer NOT NULL,
    routing_profile_id uuid NOT NULL,
    service_profile_id uuid NOT NULL
);


ALTER TABLE public.multicast_group OWNER TO loraserver_ns;

--
-- Name: multicast_queue; Type: TABLE; Schema: public; Owner: loraserver_ns
--

CREATE TABLE public.multicast_queue (
    id bigint NOT NULL,
    created_at timestamp with time zone NOT NULL,
    schedule_at timestamp with time zone NOT NULL,
    emit_at_time_since_gps_epoch bigint,
    multicast_group_id uuid NOT NULL,
    gateway_id bytea NOT NULL,
    f_cnt integer NOT NULL,
    f_port integer NOT NULL,
    frm_payload bytea
);


ALTER TABLE public.multicast_queue OWNER TO loraserver_ns;

--
-- Name: multicast_queue_id_seq; Type: SEQUENCE; Schema: public; Owner: loraserver_ns
--

CREATE SEQUENCE public.multicast_queue_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.multicast_queue_id_seq OWNER TO loraserver_ns;

--
-- Name: multicast_queue_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: loraserver_ns
--

ALTER SEQUENCE public.multicast_queue_id_seq OWNED BY public.multicast_queue.id;


--
-- Name: routing_profile; Type: TABLE; Schema: public; Owner: loraserver_ns
--

CREATE TABLE public.routing_profile (
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    routing_profile_id uuid NOT NULL,
    as_id character varying(255),
    ca_cert text DEFAULT ''::text NOT NULL,
    tls_cert text DEFAULT ''::text NOT NULL,
    tls_key text DEFAULT ''::text NOT NULL
);


ALTER TABLE public.routing_profile OWNER TO loraserver_ns;

--
-- Name: service_profile; Type: TABLE; Schema: public; Owner: loraserver_ns
--

CREATE TABLE public.service_profile (
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    service_profile_id uuid NOT NULL,
    ul_rate integer NOT NULL,
    ul_bucket_size integer NOT NULL,
    ul_rate_policy character(4) NOT NULL,
    dl_rate integer NOT NULL,
    dl_bucket_size integer NOT NULL,
    dl_rate_policy character(4) NOT NULL,
    add_gw_metadata boolean NOT NULL,
    dev_status_req_freq integer NOT NULL,
    report_dev_status_battery boolean NOT NULL,
    report_dev_status_margin boolean NOT NULL,
    dr_min integer NOT NULL,
    dr_max integer NOT NULL,
    channel_mask bytea,
    pr_allowed boolean NOT NULL,
    hr_allowed boolean NOT NULL,
    ra_allowed boolean NOT NULL,
    nwk_geo_loc boolean NOT NULL,
    target_per integer NOT NULL,
    min_gw_diversity integer NOT NULL
);


ALTER TABLE public.service_profile OWNER TO loraserver_ns;

--
-- Name: device_activation id; Type: DEFAULT; Schema: public; Owner: loraserver_ns
--

ALTER TABLE ONLY public.device_activation ALTER COLUMN id SET DEFAULT nextval('public.device_activation_id_seq'::regclass);


--
-- Name: device_queue id; Type: DEFAULT; Schema: public; Owner: loraserver_ns
--

ALTER TABLE ONLY public.device_queue ALTER COLUMN id SET DEFAULT nextval('public.device_queue_id_seq'::regclass);


--
-- Name: gateway_profile_extra_channel id; Type: DEFAULT; Schema: public; Owner: loraserver_ns
--

ALTER TABLE ONLY public.gateway_profile_extra_channel ALTER COLUMN id SET DEFAULT nextval('public.gateway_profile_extra_channel_id_seq'::regclass);


--
-- Name: gateway_stats id; Type: DEFAULT; Schema: public; Owner: loraserver_ns
--

ALTER TABLE ONLY public.gateway_stats ALTER COLUMN id SET DEFAULT nextval('public.gateway_stats_id_seq'::regclass);


--
-- Name: multicast_queue id; Type: DEFAULT; Schema: public; Owner: loraserver_ns
--

ALTER TABLE ONLY public.multicast_queue ALTER COLUMN id SET DEFAULT nextval('public.multicast_queue_id_seq'::regclass);


--
-- Data for Name: code_migration; Type: TABLE DATA; Schema: public; Owner: loraserver_ns
--

COPY public.code_migration (id, applied_at) FROM stdin;
v1_to_v2_flush_profiles_cache	2019-04-12 03:20:57.668675+00
migrate_gateway_stats_to_redis	2019-04-12 03:20:57.69428+00
\.


--
-- Data for Name: device; Type: TABLE DATA; Schema: public; Owner: loraserver_ns
--

COPY public.device (dev_eui, created_at, updated_at, device_profile_id, service_profile_id, routing_profile_id, skip_fcnt_check, reference_altitude, mode) FROM stdin;
\\x0000000000000666	2019-04-12 03:39:22.560608+00	2019-04-12 03:39:22.560608+00	2ebc845c-878a-4b28-a4bd-40eb7631f5a0	c74edd4e-f0d0-4dcf-afe0-165bb57661ca	6d5db27e-4ce2-4b2b-b5d7-91f069397978	f	0	 
\.


--
-- Data for Name: device_activation; Type: TABLE DATA; Schema: public; Owner: loraserver_ns
--

COPY public.device_activation (id, created_at, dev_eui, join_eui, dev_addr, f_nwk_s_int_key, s_nwk_s_int_key, nwk_s_enc_key, dev_nonce, join_req_type) FROM stdin;
\.


--
-- Name: device_activation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: loraserver_ns
--

SELECT pg_catalog.setval('public.device_activation_id_seq', 1, false);


--
-- Data for Name: device_multicast_group; Type: TABLE DATA; Schema: public; Owner: loraserver_ns
--

COPY public.device_multicast_group (dev_eui, multicast_group_id, created_at) FROM stdin;
\.


--
-- Data for Name: device_profile; Type: TABLE DATA; Schema: public; Owner: loraserver_ns
--

COPY public.device_profile (created_at, updated_at, device_profile_id, supports_class_b, class_b_timeout, ping_slot_period, ping_slot_dr, ping_slot_freq, supports_class_c, class_c_timeout, mac_version, reg_params_revision, rx_delay_1, rx_dr_offset_1, rx_data_rate_2, rx_freq_2, factory_preset_freqs, max_eirp, max_duty_cycle, supports_join, rf_region, supports_32bit_fcnt) FROM stdin;
2019-04-12 03:27:08.994289+00	2019-04-12 03:38:06.991641+00	2ebc845c-878a-4b28-a4bd-40eb7631f5a0	f	0	0	0	0	f	0	1.0.2	A	0	0	0	0	\N	0	0	t	EU868	f
\.


--
-- Data for Name: device_queue; Type: TABLE DATA; Schema: public; Owner: loraserver_ns
--

COPY public.device_queue (id, created_at, updated_at, dev_eui, frm_payload, f_cnt, f_port, confirmed, is_pending, timeout_after, emit_at_time_since_gps_epoch) FROM stdin;
\.


--
-- Name: device_queue_id_seq; Type: SEQUENCE SET; Schema: public; Owner: loraserver_ns
--

SELECT pg_catalog.setval('public.device_queue_id_seq', 1, false);


--
-- Data for Name: gateway; Type: TABLE DATA; Schema: public; Owner: loraserver_ns
--

COPY public.gateway (gateway_id, created_at, updated_at, first_seen_at, last_seen_at, location, altitude, gateway_profile_id) FROM stdin;
\\x0000000000000888	2019-04-12 03:34:03.140361+00	2019-04-12 03:38:39.330131+00	\N	\N	(0,0)	0	fab572ae-5477-4d4c-adb7-fac4ec7685f7
\.


--
-- Data for Name: gateway_board; Type: TABLE DATA; Schema: public; Owner: loraserver_ns
--

COPY public.gateway_board (id, gateway_id, fpga_id, fine_timestamp_key) FROM stdin;
\.


--
-- Data for Name: gateway_profile; Type: TABLE DATA; Schema: public; Owner: loraserver_ns
--

COPY public.gateway_profile (gateway_profile_id, created_at, updated_at, channels) FROM stdin;
fab572ae-5477-4d4c-adb7-fac4ec7685f7	2019-04-12 03:26:20.210594+00	2019-04-12 03:37:48.481249+00	{0,1,2,3,4,5,6,7}
\.


--
-- Data for Name: gateway_profile_extra_channel; Type: TABLE DATA; Schema: public; Owner: loraserver_ns
--

COPY public.gateway_profile_extra_channel (id, gateway_profile_id, modulation, frequency, bandwidth, bitrate, spreading_factors) FROM stdin;
\.


--
-- Name: gateway_profile_extra_channel_id_seq; Type: SEQUENCE SET; Schema: public; Owner: loraserver_ns
--

SELECT pg_catalog.setval('public.gateway_profile_extra_channel_id_seq', 1, false);


--
-- Data for Name: gateway_stats; Type: TABLE DATA; Schema: public; Owner: loraserver_ns
--

COPY public.gateway_stats (id, gateway_id, "timestamp", "interval", rx_packets_received, rx_packets_received_ok, tx_packets_received, tx_packets_emitted) FROM stdin;
\.


--
-- Name: gateway_stats_id_seq; Type: SEQUENCE SET; Schema: public; Owner: loraserver_ns
--

SELECT pg_catalog.setval('public.gateway_stats_id_seq', 1, false);


--
-- Data for Name: gorp_migrations; Type: TABLE DATA; Schema: public; Owner: loraserver_ns
--

COPY public.gorp_migrations (id, applied_at) FROM stdin;
0001_initial.sql	2019-04-12 03:20:46.237617+00
0002_node_frame_log.sql	2019-04-12 03:20:46.411473+00
0003_gateway_channel_config.sql	2019-04-12 03:20:47.059479+00
0004_update_gateway_model.sql	2019-04-12 03:20:47.078947+00
0005_profiles.sql	2019-04-12 03:20:48.764826+00
0006_device_queue.sql	2019-04-12 03:20:49.071377+00
0007_routing_profile_certs.sql	2019-04-12 03:20:50.293506+00
0008_device_queue_emit_at_gps_ts.sql	2019-04-12 03:20:50.753551+00
0009_gateway_profile.sql	2019-04-12 03:20:51.12264+00
0010_device_skip_fcnt.sql	2019-04-12 03:20:51.716938+00
0011_cleanup_old_tables.sql	2019-04-12 03:20:51.774107+00
0012_lorawan_11.sql	2019-04-12 03:20:52.86095+00
0013_cleanup_indices.sql	2019-04-12 03:20:52.995117+00
0014_remove_gateway_name_and_descr.sql	2019-04-12 03:20:53.012306+00
0015_code_migrations.sql	2019-04-12 03:20:53.53027+00
0016_multicast.sql	2019-04-12 03:20:54.434658+00
0017_gateway_mac_to_id.sql	2019-04-12 03:20:54.445694+00
0018_gateway_board_config.sql	2019-04-12 03:20:54.538083+00
0019_device_reference_altitude.sql	2019-04-12 03:20:54.819549+00
0020_device_add_mode.sql	2019-04-12 03:20:57.640219+00
\.


--
-- Data for Name: multicast_group; Type: TABLE DATA; Schema: public; Owner: loraserver_ns
--

COPY public.multicast_group (id, created_at, updated_at, mc_addr, mc_nwk_s_key, f_cnt, group_type, dr, frequency, ping_slot_period, routing_profile_id, service_profile_id) FROM stdin;
\.


--
-- Data for Name: multicast_queue; Type: TABLE DATA; Schema: public; Owner: loraserver_ns
--

COPY public.multicast_queue (id, created_at, schedule_at, emit_at_time_since_gps_epoch, multicast_group_id, gateway_id, f_cnt, f_port, frm_payload) FROM stdin;
\.


--
-- Name: multicast_queue_id_seq; Type: SEQUENCE SET; Schema: public; Owner: loraserver_ns
--

SELECT pg_catalog.setval('public.multicast_queue_id_seq', 1, false);


--
-- Data for Name: routing_profile; Type: TABLE DATA; Schema: public; Owner: loraserver_ns
--

COPY public.routing_profile (created_at, updated_at, routing_profile_id, as_id, ca_cert, tls_cert, tls_key) FROM stdin;
2019-04-12 03:25:45.956573+00	2019-04-12 03:37:41.520413+00	6d5db27e-4ce2-4b2b-b5d7-91f069397978	localhost:8001			
\.


--
-- Data for Name: service_profile; Type: TABLE DATA; Schema: public; Owner: loraserver_ns
--

COPY public.service_profile (created_at, updated_at, service_profile_id, ul_rate, ul_bucket_size, ul_rate_policy, dl_rate, dl_bucket_size, dl_rate_policy, add_gw_metadata, dev_status_req_freq, report_dev_status_battery, report_dev_status_margin, dr_min, dr_max, channel_mask, pr_allowed, hr_allowed, ra_allowed, nwk_geo_loc, target_per, min_gw_diversity) FROM stdin;
2019-04-12 03:26:45.805953+00	2019-04-12 03:37:59.266429+00	c74edd4e-f0d0-4dcf-afe0-165bb57661ca	0	0	Drop	0	0	Drop	f	0	f	f	0	0	\\x	f	f	f	f	0	0
\.


--
-- Name: code_migration code_migration_pkey; Type: CONSTRAINT; Schema: public; Owner: loraserver_ns
--

ALTER TABLE ONLY public.code_migration
    ADD CONSTRAINT code_migration_pkey PRIMARY KEY (id);


--
-- Name: device_activation device_activation_pkey; Type: CONSTRAINT; Schema: public; Owner: loraserver_ns
--

ALTER TABLE ONLY public.device_activation
    ADD CONSTRAINT device_activation_pkey PRIMARY KEY (id);


--
-- Name: device_multicast_group device_multicast_group_pkey; Type: CONSTRAINT; Schema: public; Owner: loraserver_ns
--

ALTER TABLE ONLY public.device_multicast_group
    ADD CONSTRAINT device_multicast_group_pkey PRIMARY KEY (multicast_group_id, dev_eui);


--
-- Name: device device_pkey; Type: CONSTRAINT; Schema: public; Owner: loraserver_ns
--

ALTER TABLE ONLY public.device
    ADD CONSTRAINT device_pkey PRIMARY KEY (dev_eui);


--
-- Name: device_profile device_profile_pkey; Type: CONSTRAINT; Schema: public; Owner: loraserver_ns
--

ALTER TABLE ONLY public.device_profile
    ADD CONSTRAINT device_profile_pkey PRIMARY KEY (device_profile_id);


--
-- Name: device_queue device_queue_pkey; Type: CONSTRAINT; Schema: public; Owner: loraserver_ns
--

ALTER TABLE ONLY public.device_queue
    ADD CONSTRAINT device_queue_pkey PRIMARY KEY (id);


--
-- Name: gateway_board gateway_board_pkey; Type: CONSTRAINT; Schema: public; Owner: loraserver_ns
--

ALTER TABLE ONLY public.gateway_board
    ADD CONSTRAINT gateway_board_pkey PRIMARY KEY (gateway_id, id);


--
-- Name: gateway gateway_pkey; Type: CONSTRAINT; Schema: public; Owner: loraserver_ns
--

ALTER TABLE ONLY public.gateway
    ADD CONSTRAINT gateway_pkey PRIMARY KEY (gateway_id);


--
-- Name: gateway_profile_extra_channel gateway_profile_extra_channel_pkey; Type: CONSTRAINT; Schema: public; Owner: loraserver_ns
--

ALTER TABLE ONLY public.gateway_profile_extra_channel
    ADD CONSTRAINT gateway_profile_extra_channel_pkey PRIMARY KEY (id);


--
-- Name: gateway_profile gateway_profile_pkey; Type: CONSTRAINT; Schema: public; Owner: loraserver_ns
--

ALTER TABLE ONLY public.gateway_profile
    ADD CONSTRAINT gateway_profile_pkey PRIMARY KEY (gateway_profile_id);


--
-- Name: gateway_stats gateway_stats_mac_timestamp_interval_key; Type: CONSTRAINT; Schema: public; Owner: loraserver_ns
--

ALTER TABLE ONLY public.gateway_stats
    ADD CONSTRAINT gateway_stats_mac_timestamp_interval_key UNIQUE (gateway_id, "timestamp", "interval");


--
-- Name: gateway_stats gateway_stats_pkey; Type: CONSTRAINT; Schema: public; Owner: loraserver_ns
--

ALTER TABLE ONLY public.gateway_stats
    ADD CONSTRAINT gateway_stats_pkey PRIMARY KEY (id);


--
-- Name: gorp_migrations gorp_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: loraserver_ns
--

ALTER TABLE ONLY public.gorp_migrations
    ADD CONSTRAINT gorp_migrations_pkey PRIMARY KEY (id);


--
-- Name: multicast_group multicast_group_pkey; Type: CONSTRAINT; Schema: public; Owner: loraserver_ns
--

ALTER TABLE ONLY public.multicast_group
    ADD CONSTRAINT multicast_group_pkey PRIMARY KEY (id);


--
-- Name: multicast_queue multicast_queue_pkey; Type: CONSTRAINT; Schema: public; Owner: loraserver_ns
--

ALTER TABLE ONLY public.multicast_queue
    ADD CONSTRAINT multicast_queue_pkey PRIMARY KEY (id);


--
-- Name: routing_profile routing_profile_pkey; Type: CONSTRAINT; Schema: public; Owner: loraserver_ns
--

ALTER TABLE ONLY public.routing_profile
    ADD CONSTRAINT routing_profile_pkey PRIMARY KEY (routing_profile_id);


--
-- Name: service_profile service_profile_pkey; Type: CONSTRAINT; Schema: public; Owner: loraserver_ns
--

ALTER TABLE ONLY public.service_profile
    ADD CONSTRAINT service_profile_pkey PRIMARY KEY (service_profile_id);


--
-- Name: idx_device_activation_dev_eui; Type: INDEX; Schema: public; Owner: loraserver_ns
--

CREATE INDEX idx_device_activation_dev_eui ON public.device_activation USING btree (dev_eui);


--
-- Name: idx_device_activation_nonce_lookup; Type: INDEX; Schema: public; Owner: loraserver_ns
--

CREATE INDEX idx_device_activation_nonce_lookup ON public.device_activation USING btree (join_eui, dev_eui, join_req_type, dev_nonce);


--
-- Name: idx_device_device_profile_id; Type: INDEX; Schema: public; Owner: loraserver_ns
--

CREATE INDEX idx_device_device_profile_id ON public.device USING btree (device_profile_id);


--
-- Name: idx_device_mode; Type: INDEX; Schema: public; Owner: loraserver_ns
--

CREATE INDEX idx_device_mode ON public.device USING btree (mode);


--
-- Name: idx_device_queue_confirmed; Type: INDEX; Schema: public; Owner: loraserver_ns
--

CREATE INDEX idx_device_queue_confirmed ON public.device_queue USING btree (confirmed);


--
-- Name: idx_device_queue_dev_eui; Type: INDEX; Schema: public; Owner: loraserver_ns
--

CREATE INDEX idx_device_queue_dev_eui ON public.device_queue USING btree (dev_eui);


--
-- Name: idx_device_queue_emit_at_time_since_gps_epoch; Type: INDEX; Schema: public; Owner: loraserver_ns
--

CREATE INDEX idx_device_queue_emit_at_time_since_gps_epoch ON public.device_queue USING btree (emit_at_time_since_gps_epoch);


--
-- Name: idx_device_queue_timeout_after; Type: INDEX; Schema: public; Owner: loraserver_ns
--

CREATE INDEX idx_device_queue_timeout_after ON public.device_queue USING btree (timeout_after);


--
-- Name: idx_device_routing_profile_id; Type: INDEX; Schema: public; Owner: loraserver_ns
--

CREATE INDEX idx_device_routing_profile_id ON public.device USING btree (routing_profile_id);


--
-- Name: idx_device_service_profile_id; Type: INDEX; Schema: public; Owner: loraserver_ns
--

CREATE INDEX idx_device_service_profile_id ON public.device USING btree (service_profile_id);


--
-- Name: idx_gateway_gateway_profile_id; Type: INDEX; Schema: public; Owner: loraserver_ns
--

CREATE INDEX idx_gateway_gateway_profile_id ON public.gateway USING btree (gateway_profile_id);


--
-- Name: idx_gateway_profile_extra_channel_gw_profile_id; Type: INDEX; Schema: public; Owner: loraserver_ns
--

CREATE INDEX idx_gateway_profile_extra_channel_gw_profile_id ON public.gateway_profile_extra_channel USING btree (gateway_profile_id);


--
-- Name: idx_gateway_stats_gateway_id; Type: INDEX; Schema: public; Owner: loraserver_ns
--

CREATE INDEX idx_gateway_stats_gateway_id ON public.gateway_stats USING btree (gateway_id);


--
-- Name: idx_gateway_stats_interval; Type: INDEX; Schema: public; Owner: loraserver_ns
--

CREATE INDEX idx_gateway_stats_interval ON public.gateway_stats USING btree ("interval");


--
-- Name: idx_gateway_stats_timestamp; Type: INDEX; Schema: public; Owner: loraserver_ns
--

CREATE INDEX idx_gateway_stats_timestamp ON public.gateway_stats USING btree ("timestamp");


--
-- Name: idx_multicast_group_routing_profile_id; Type: INDEX; Schema: public; Owner: loraserver_ns
--

CREATE INDEX idx_multicast_group_routing_profile_id ON public.multicast_group USING btree (routing_profile_id);


--
-- Name: idx_multicast_group_service_profile_id; Type: INDEX; Schema: public; Owner: loraserver_ns
--

CREATE INDEX idx_multicast_group_service_profile_id ON public.multicast_group USING btree (service_profile_id);


--
-- Name: idx_multicast_queue_emit_at_time_since_gps_epoch; Type: INDEX; Schema: public; Owner: loraserver_ns
--

CREATE INDEX idx_multicast_queue_emit_at_time_since_gps_epoch ON public.multicast_queue USING btree (emit_at_time_since_gps_epoch);


--
-- Name: idx_multicast_queue_multicast_group_id; Type: INDEX; Schema: public; Owner: loraserver_ns
--

CREATE INDEX idx_multicast_queue_multicast_group_id ON public.multicast_queue USING btree (multicast_group_id);


--
-- Name: idx_multicast_queue_schedule_at; Type: INDEX; Schema: public; Owner: loraserver_ns
--

CREATE INDEX idx_multicast_queue_schedule_at ON public.multicast_queue USING btree (schedule_at);


--
-- Name: device_activation device_activation_dev_eui_fkey; Type: FK CONSTRAINT; Schema: public; Owner: loraserver_ns
--

ALTER TABLE ONLY public.device_activation
    ADD CONSTRAINT device_activation_dev_eui_fkey FOREIGN KEY (dev_eui) REFERENCES public.device(dev_eui) ON DELETE CASCADE;


--
-- Name: device device_device_profile_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: loraserver_ns
--

ALTER TABLE ONLY public.device
    ADD CONSTRAINT device_device_profile_id_fkey FOREIGN KEY (device_profile_id) REFERENCES public.device_profile(device_profile_id) ON DELETE CASCADE;


--
-- Name: device_multicast_group device_multicast_group_dev_eui_fkey; Type: FK CONSTRAINT; Schema: public; Owner: loraserver_ns
--

ALTER TABLE ONLY public.device_multicast_group
    ADD CONSTRAINT device_multicast_group_dev_eui_fkey FOREIGN KEY (dev_eui) REFERENCES public.device(dev_eui) ON DELETE CASCADE;


--
-- Name: device_multicast_group device_multicast_group_multicast_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: loraserver_ns
--

ALTER TABLE ONLY public.device_multicast_group
    ADD CONSTRAINT device_multicast_group_multicast_group_id_fkey FOREIGN KEY (multicast_group_id) REFERENCES public.multicast_group(id) ON DELETE CASCADE;


--
-- Name: device_queue device_queue_dev_eui_fkey; Type: FK CONSTRAINT; Schema: public; Owner: loraserver_ns
--

ALTER TABLE ONLY public.device_queue
    ADD CONSTRAINT device_queue_dev_eui_fkey FOREIGN KEY (dev_eui) REFERENCES public.device(dev_eui) ON DELETE CASCADE;


--
-- Name: device device_routing_profile_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: loraserver_ns
--

ALTER TABLE ONLY public.device
    ADD CONSTRAINT device_routing_profile_id_fkey FOREIGN KEY (routing_profile_id) REFERENCES public.routing_profile(routing_profile_id) ON DELETE CASCADE;


--
-- Name: device device_service_profile_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: loraserver_ns
--

ALTER TABLE ONLY public.device
    ADD CONSTRAINT device_service_profile_id_fkey FOREIGN KEY (service_profile_id) REFERENCES public.service_profile(service_profile_id) ON DELETE CASCADE;


--
-- Name: gateway_board gateway_board_gateway_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: loraserver_ns
--

ALTER TABLE ONLY public.gateway_board
    ADD CONSTRAINT gateway_board_gateway_id_fkey FOREIGN KEY (gateway_id) REFERENCES public.gateway(gateway_id) ON DELETE CASCADE;


--
-- Name: gateway gateway_gateway_profile_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: loraserver_ns
--

ALTER TABLE ONLY public.gateway
    ADD CONSTRAINT gateway_gateway_profile_id_fkey FOREIGN KEY (gateway_profile_id) REFERENCES public.gateway_profile(gateway_profile_id);


--
-- Name: gateway_profile_extra_channel gateway_profile_extra_channel_gateway_profile_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: loraserver_ns
--

ALTER TABLE ONLY public.gateway_profile_extra_channel
    ADD CONSTRAINT gateway_profile_extra_channel_gateway_profile_id_fkey FOREIGN KEY (gateway_profile_id) REFERENCES public.gateway_profile(gateway_profile_id) ON DELETE CASCADE;


--
-- Name: gateway_stats gateway_stats_mac_fkey; Type: FK CONSTRAINT; Schema: public; Owner: loraserver_ns
--

ALTER TABLE ONLY public.gateway_stats
    ADD CONSTRAINT gateway_stats_mac_fkey FOREIGN KEY (gateway_id) REFERENCES public.gateway(gateway_id) ON DELETE CASCADE;


--
-- Name: multicast_group multicast_group_routing_profile_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: loraserver_ns
--

ALTER TABLE ONLY public.multicast_group
    ADD CONSTRAINT multicast_group_routing_profile_id_fkey FOREIGN KEY (routing_profile_id) REFERENCES public.routing_profile(routing_profile_id) ON DELETE CASCADE;


--
-- Name: multicast_group multicast_group_service_profile_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: loraserver_ns
--

ALTER TABLE ONLY public.multicast_group
    ADD CONSTRAINT multicast_group_service_profile_id_fkey FOREIGN KEY (service_profile_id) REFERENCES public.service_profile(service_profile_id) ON DELETE CASCADE;


--
-- Name: multicast_queue multicast_queue_gateway_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: loraserver_ns
--

ALTER TABLE ONLY public.multicast_queue
    ADD CONSTRAINT multicast_queue_gateway_id_fkey FOREIGN KEY (gateway_id) REFERENCES public.gateway(gateway_id) ON DELETE CASCADE;


--
-- Name: multicast_queue multicast_queue_multicast_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: loraserver_ns
--

ALTER TABLE ONLY public.multicast_queue
    ADD CONSTRAINT multicast_queue_multicast_group_id_fkey FOREIGN KEY (multicast_group_id) REFERENCES public.multicast_group(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\connect postgres

SET default_transaction_read_only = off;

--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.11
-- Dumped by pg_dump version 9.6.11

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: DATABASE postgres; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON DATABASE postgres IS 'default administrative connection database';


--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- PostgreSQL database dump complete
--

\connect template1

SET default_transaction_read_only = off;

--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.11
-- Dumped by pg_dump version 9.6.11

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: DATABASE template1; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON DATABASE template1 IS 'default template for new databases';


--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- PostgreSQL database dump complete
--

--
-- PostgreSQL database cluster dump complete
--

