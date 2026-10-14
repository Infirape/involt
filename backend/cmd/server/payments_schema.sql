-- Payments ledger (cobranzas). Idempotent: safe to run on every startup.

CREATE SEQUENCE IF NOT EXISTS payment_receipt_seq START 1;

CREATE TABLE IF NOT EXISTS payments (
    id text PRIMARY KEY,
    receipt_number bigint NOT NULL UNIQUE DEFAULT nextval('payment_receipt_seq'),
    customer_id text NOT NULL REFERENCES customers(id),
    amount double precision NOT NULL CHECK (amount > 0),
    method text NOT NULL DEFAULT 'CASH',
    reference text NOT NULL DEFAULT '',
    observation text NOT NULL DEFAULT '',
    collected_by text NOT NULL DEFAULT '',
    collected_by_email text NOT NULL DEFAULT '',
    paid_at timestamp with time zone NOT NULL DEFAULT now(),
    voided_at timestamp with time zone,
    voided_by text NOT NULL DEFAULT '',
    void_reason text NOT NULL DEFAULT ''
);

CREATE INDEX IF NOT EXISTS idx_payments_customer ON payments(customer_id);
CREATE INDEX IF NOT EXISTS idx_payments_paid_at ON payments(paid_at);

CREATE TABLE IF NOT EXISTS payment_allocations (
    payment_id text NOT NULL REFERENCES payments(id) ON DELETE CASCADE,
    reading_id text NOT NULL REFERENCES readings(id),
    amount double precision NOT NULL CHECK (amount > 0),
    PRIMARY KEY (payment_id, reading_id)
);

CREATE INDEX IF NOT EXISTS idx_payment_allocations_reading ON payment_allocations(reading_id);

-- Backfill: readings marked as paid with the old boolean toggle become one payment each,
-- so the ledger and readings.is_paid agree from day one. Old rows may lack payment_date and
-- even a timestamp (dummy readings), so fall back to the billing period instead of year 0001;
-- this also keeps backfilled payments out of today's cash closing.
INSERT INTO payments (id, customer_id, amount, method, observation, collected_by_email, paid_at)
SELECT 'legacy-' || r.id, r.customer_id, r.total_to_pay, 'CASH',
       'Migrado del registro anterior de cobranzas', 'sistema',
       COALESCE(
           r.payment_date,
           CASE WHEN r."timestamp" > '2000-01-01' THEN r."timestamp" END,
           CASE WHEN r.period ~ '^\d{4}-\d{2}$' THEN to_date(r.period, 'YYYY-MM')::timestamptz END,
           now()
       )
FROM readings r
WHERE r.is_paid
  AND r.customer_id IS NOT NULL
  AND r.total_to_pay > 0
  AND NOT EXISTS (SELECT 1 FROM payment_allocations pa WHERE pa.reading_id = r.id)
ORDER BY r.period, r.id
ON CONFLICT (id) DO NOTHING;

INSERT INTO payment_allocations (payment_id, reading_id, amount)
SELECT p.id, r.id, r.total_to_pay
FROM readings r
JOIN payments p ON p.id = 'legacy-' || r.id
ON CONFLICT DO NOTHING;
