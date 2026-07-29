-- InVolt Database Schema

-- Users
CREATE TABLE IF NOT EXISTS users (
    id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    email text UNIQUE NOT NULL,
    password_hash text NOT NULL,
    role text DEFAULT 'READER'::text NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);

-- Communities
CREATE TABLE IF NOT EXISTS communities (
    id text PRIMARY KEY,
    name text NOT NULL
);

-- Sectors
CREATE TABLE IF NOT EXISTS sectors (
    id text PRIMARY KEY,
    community_id text REFERENCES communities(id),
    name text NOT NULL
);

-- User Sectors
CREATE TABLE IF NOT EXISTS user_sectors (
    user_id uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    sector_id text NOT NULL,
    PRIMARY KEY (user_id, sector_id)
);
CREATE INDEX IF NOT EXISTS idx_user_sectors_user_id ON user_sectors(user_id);
CREATE INDEX IF NOT EXISTS idx_user_sectors_sector_id ON user_sectors(sector_id);

-- Customers
CREATE TABLE IF NOT EXISTS customers (
    id text PRIMARY KEY,
    code text UNIQUE NOT NULL,
    name text NOT NULL,
    community_id text REFERENCES communities(id),
    sector_id text REFERENCES sectors(id),
    connection_type text NOT NULL,
    tariff double precision NOT NULL,
    meter_number text NOT NULL,
    latitude double precision DEFAULT 0 NOT NULL,
    longitude double precision DEFAULT 0 NOT NULL,
    initial_reading double precision DEFAULT 0,
    address text DEFAULT ''::text NOT NULL,
    contract_start date,
    created_at timestamp with time zone DEFAULT now()
);

-- Periods
CREATE TABLE IF NOT EXISTS periods (
    id text PRIMARY KEY,
    start_date date NOT NULL,
    end_date date NOT NULL,
    status text DEFAULT 'OPEN'::text NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    is_billing_period boolean DEFAULT true
);

-- Readings
CREATE TABLE IF NOT EXISTS readings (
    id text PRIMARY KEY,
    customer_id text REFERENCES customers(id),
    previous_value double precision NOT NULL,
    current_value double precision NOT NULL,
    consumption double precision NOT NULL,
    photo_url text DEFAULT ''::text NOT NULL,
    "timestamp" timestamp with time zone DEFAULT now() NOT NULL,
    latitude double precision DEFAULT 0 NOT NULL,
    longitude double precision DEFAULT 0 NOT NULL,
    cargo_fijo double precision NOT NULL,
    alumbrado_publico double precision NOT NULL,
    saldo_redondeo double precision NOT NULL,
    total_to_pay double precision NOT NULL,
    period_start date DEFAULT CURRENT_DATE NOT NULL,
    period_end date DEFAULT CURRENT_DATE NOT NULL,
    mantenimiento double precision DEFAULT 0 NOT NULL,
    adjustment double precision DEFAULT 0,
    subtotal double precision DEFAULT 0 NOT NULL,
    round_difference double precision DEFAULT 0,
    previous_balance double precision DEFAULT 0,
    overdue_total double precision DEFAULT 0,
    expiration_date date DEFAULT CURRENT_DATE NOT NULL,
    period character varying(10),
    observation text,
    is_paid boolean DEFAULT false NOT NULL,
    payment_date timestamp with time zone
);

-- Settings
CREATE TABLE IF NOT EXISTS settings (
    id text DEFAULT 'main'::text PRIMARY KEY,
    municipalidad text DEFAULT 'MUNICIPALIDAD DISTRITAL DE CHETILLA'::text NOT NULL,
    empresa text DEFAULT 'HIDROELECTRICA QARWAQIRU MICHAY'::text NOT NULL,
    ruc text,
    direccion text,
    telefono text,
    email text,
    dias_vencimiento integer DEFAULT 15,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    tarifa_kwh double precision DEFAULT 0.25,
    cargo_fijo double precision DEFAULT 6.00,
    alumbrado double precision DEFAULT 0.00,
    mantenimiento double precision DEFAULT 0.00,
    igv boolean DEFAULT false
);

-- App Configs
CREATE TABLE IF NOT EXISTS app_configs (
    key text PRIMARY KEY,
    value text
);