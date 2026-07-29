-- Schema for InVolt Backend

-- Configuración de la municipalidad/empresa
CREATE TABLE IF NOT EXISTS settings (
    id TEXT PRIMARY KEY DEFAULT 'main',
    municipalidad TEXT NOT NULL DEFAULT 'MUNICIPALIDAD DISTRITAL DE CHETILLA',
    empresa TEXT NOT NULL DEFAULT 'HIDROELECTRICA QARWAQIRU MICHAY',
    ruc TEXT NOT NULL DEFAULT '',
    direccion TEXT NOT NULL DEFAULT '',
    telefono TEXT NOT NULL DEFAULT '',
    email TEXT NOT NULL DEFAULT '',
    dias_vencimiento INTEGER DEFAULT 15,
    tarifa_kwh DOUBLE PRECISION DEFAULT 0.25,
    cargo_fijo DOUBLE PRECISION DEFAULT 6.00,
    alumbrado DOUBLE PRECISION DEFAULT 0.00,
    mantenimiento DOUBLE PRECISION DEFAULT 0.00,
    igv BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS app_configs (
    id TEXT PRIMARY KEY DEFAULT 'main',
    map_url_template TEXT NOT NULL DEFAULT '',
    map_user_agent TEXT NOT NULL DEFAULT '',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

INSERT INTO app_configs (id, map_url_template, map_user_agent) VALUES ('main', 'https://tile.openstreetmap.org/{z}/{x}/{y}.png', 'InVolt-App') ON CONFLICT DO NOTHING;

CREATE TABLE IF NOT EXISTS communities (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS sectors (
    id TEXT PRIMARY KEY,
    community_id TEXT REFERENCES communities(id),
    name TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS customers (
    id TEXT PRIMARY KEY,
    code TEXT UNIQUE NOT NULL,
    name TEXT NOT NULL,
    community_id TEXT REFERENCES communities(id),
    sector_id TEXT REFERENCES sectors(id),
    address TEXT NOT NULL DEFAULT '',  -- Dirección del cliente (caserio, anexo, etc.)
    connection_type TEXT NOT NULL, -- MONOFASICA / TRIFASICA
    tariff DOUBLE PRECISION NOT NULL,
    meter_number TEXT NOT NULL,
    latitude DOUBLE PRECISION NOT NULL DEFAULT 0,
    longitude DOUBLE PRECISION NOT NULL DEFAULT 0,
    initial_reading DOUBLE PRECISION DEFAULT 0,
    contract_start DATE,  -- Fecha de inicio de contrato
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS readings (
    id TEXT PRIMARY KEY,
    customer_id TEXT REFERENCES customers(id),
    previous_value DOUBLE PRECISION NOT NULL,
    current_value DOUBLE PRECISION NOT NULL,
    consumption DOUBLE PRECISION NOT NULL,
    photo_url TEXT NOT NULL DEFAULT '',
    timestamp TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    latitude DOUBLE PRECISION NOT NULL DEFAULT 0,
    longitude DOUBLE PRECISION NOT NULL DEFAULT 0,
    -- Periodo de facturación
    period_start DATE NOT NULL,
    period_end DATE NOT NULL,
    -- Conceptos de cobro
    cargo_fijo DOUBLE PRECISION NOT NULL,
    alumbrado_publico DOUBLE PRECISION NOT NULL,
    mantenimiento DOUBLE PRECISION NOT NULL DEFAULT 0,
    adjustment DOUBLE PRECISION DEFAULT 0,  -- Ajuste tarifario
    subtotal DOUBLE PRECISION NOT NULL,
    saldo_redondeo DOUBLE PRECISION DEFAULT 0,
    round_difference DOUBLE PRECISION DEFAULT 0,
    -- Totales
    previous_balance DOUBLE PRECISION DEFAULT 0,  -- Saldo anterior
    overdue_total DOUBLE PRECISION DEFAULT 0,    -- Total recibos vencidos
    total_to_pay DOUBLE PRECISION NOT NULL,
    -- Fechas
    expiration_date DATE NOT NULL,  -- Fecha de vencimiento
    period VARCHAR(10),
    observation TEXT,
    is_paid BOOLEAN NOT NULL DEFAULT FALSE,
    payment_date TIMESTAMPTZ
);

-- Initial Mock Data for Testing
INSERT INTO communities (id, name) VALUES ('COM-001', 'Chetilla') ON CONFLICT DO NOTHING;
INSERT INTO sectors (id, community_id, name) VALUES ('SEC-001', 'COM-001', 'Chetilla Centro') ON CONFLICT DO NOTHING;
INSERT INTO sectors (id, community_id, name) VALUES ('SEC-002', 'COM-001', 'La Libertad') ON CONFLICT DO NOTHING;
INSERT INTO settings (id, municipalidad, empresa, dias_vencimiento) VALUES ('main', 'MUNICIPALIDAD DISTRITAL DE CHETILLA', 'HIDROELECTRICA QARWAQIRU MICHAY', 15) ON CONFLICT DO NOTHING;

-- Admin and RBAC
CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email TEXT UNIQUE NOT NULL,
    password_hash TEXT NOT NULL,
    role TEXT NOT NULL DEFAULT 'READER',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS user_sectors (
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    sector_id TEXT NOT NULL,
    PRIMARY KEY (user_id, sector_id)
);

CREATE INDEX IF NOT EXISTS idx_user_sectors_user_id ON user_sectors(user_id);

INSERT INTO users (email, password_hash, role)
VALUES ('admin@infira.pe', '$2a$10$dwB7XvBZNbRY5GMwd61IRum0y5FSzn4hq3Dl3FuxdHwyi.i1exx0a', 'ADMIN')
ON CONFLICT (email) DO NOTHING;
