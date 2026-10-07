-- Migration: Add payment status is_paid to readings
-- Date: 2026-05-27

ALTER TABLE readings ADD COLUMN IF NOT EXISTS is_paid BOOLEAN NOT NULL DEFAULT FALSE;
ALTER TABLE readings ADD COLUMN IF NOT EXISTS payment_date TIMESTAMPTZ;

