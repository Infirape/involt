-- Collections phase 4: late fees (mora), waivers and payment agreements (convenios).
-- Idempotent: safe to run on every startup, after payments_schema.sql.

-- Allocations can now carry mora; a fee-only allocation has amount = 0.
ALTER TABLE payment_allocations ADD COLUMN IF NOT EXISTS late_fee double precision NOT NULL DEFAULT 0;
ALTER TABLE payment_allocations DROP CONSTRAINT IF EXISTS payment_allocations_amount_check;
ALTER TABLE payment_allocations DROP CONSTRAINT IF EXISTS payment_allocations_amounts_check;
ALTER TABLE payment_allocations ADD CONSTRAINT payment_allocations_amounts_check
    CHECK (amount >= 0 AND late_fee >= 0 AND amount + late_fee > 0);

CREATE TABLE IF NOT EXISTS collection_policy (
    id text PRIMARY KEY DEFAULT 'main',
    late_fee_mode text NOT NULL DEFAULT 'NONE',
    late_fee_value double precision NOT NULL DEFAULT 0,
    late_fee_start_date date,
    agreement_max_installments integer NOT NULL DEFAULT 12,
    agreement_min_initial_percent double precision NOT NULL DEFAULT 0,
    agreement_grace_days integer NOT NULL DEFAULT 15,
    agreement_waive_late_fees boolean NOT NULL DEFAULT true,
    updated_at timestamp with time zone NOT NULL DEFAULT now(),
    updated_by text NOT NULL DEFAULT ''
);
INSERT INTO collection_policy (id) VALUES ('main') ON CONFLICT DO NOTHING;

CREATE TABLE IF NOT EXISTS late_fee_waivers (
    reading_id text PRIMARY KEY REFERENCES readings(id),
    reason text NOT NULL,
    waived_by text NOT NULL DEFAULT '',
    waived_by_email text NOT NULL DEFAULT '',
    agreement_id text,
    waived_at timestamp with time zone NOT NULL DEFAULT now()
);

CREATE SEQUENCE IF NOT EXISTS agreement_number_seq START 1;

CREATE TABLE IF NOT EXISTS payment_agreements (
    id text PRIMARY KEY,
    number bigint NOT NULL UNIQUE DEFAULT nextval('agreement_number_seq'),
    customer_id text NOT NULL REFERENCES customers(id),
    status text NOT NULL DEFAULT 'ACTIVE',
    total double precision NOT NULL CHECK (total > 0),
    initial_amount double precision NOT NULL DEFAULT 0,
    notes text NOT NULL DEFAULT '',
    created_by text NOT NULL DEFAULT '',
    created_by_email text NOT NULL DEFAULT '',
    created_at timestamp with time zone NOT NULL DEFAULT now(),
    cancelled_at timestamp with time zone,
    cancelled_by text NOT NULL DEFAULT '',
    cancel_reason text NOT NULL DEFAULT ''
);
ALTER TABLE payment_agreements ADD COLUMN IF NOT EXISTS late_fees_waived boolean NOT NULL DEFAULT false;
CREATE INDEX IF NOT EXISTS idx_payment_agreements_customer ON payment_agreements(customer_id);

CREATE TABLE IF NOT EXISTS agreement_receipts (
    agreement_id text NOT NULL REFERENCES payment_agreements(id) ON DELETE CASCADE,
    reading_id text NOT NULL REFERENCES readings(id),
    principal double precision NOT NULL,
    late_fee double precision NOT NULL DEFAULT 0,
    PRIMARY KEY (agreement_id, reading_id)
);
CREATE INDEX IF NOT EXISTS idx_agreement_receipts_reading ON agreement_receipts(reading_id);

CREATE TABLE IF NOT EXISTS agreement_installments (
    agreement_id text NOT NULL REFERENCES payment_agreements(id) ON DELETE CASCADE,
    number integer NOT NULL,
    due_date date NOT NULL,
    amount double precision NOT NULL CHECK (amount > 0),
    PRIMARY KEY (agreement_id, number)
);

-- Service status (con servicio / corte temporal / sin energía), set by admins with history.
ALTER TABLE customers ADD COLUMN IF NOT EXISTS service_status text NOT NULL DEFAULT 'ACTIVE';
ALTER TABLE customers ADD COLUMN IF NOT EXISTS service_status_changed_at timestamp with time zone;

CREATE TABLE IF NOT EXISTS customer_status_changes (
    id text PRIMARY KEY,
    customer_id text NOT NULL REFERENCES customers(id),
    previous_status text NOT NULL,
    status text NOT NULL,
    reason text NOT NULL,
    changed_by text NOT NULL DEFAULT '',
    changed_by_email text NOT NULL DEFAULT '',
    changed_at timestamp with time zone NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_customer_status_changes_customer ON customer_status_changes(customer_id, changed_at DESC);

-- Supplies carry their own community_id, which reports filter and group by; it must match their
-- sector's. Realign any drift (idempotent; supplies without a sector keep theirs).
UPDATE customers c SET community_id = s.community_id
FROM sectors s
WHERE s.id = c.sector_id AND s.community_id IS NOT NULL AND c.community_id IS DISTINCT FROM s.community_id;
