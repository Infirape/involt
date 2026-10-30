-- Companies (client brands) and the user -> company link. Idempotent: safe to run on every startup.

CREATE TABLE IF NOT EXISTS companies (
    id text PRIMARY KEY DEFAULT gen_random_uuid()::text,
    name text NOT NULL,
    entity text NOT NULL DEFAULT '',
    logo text NOT NULL DEFAULT '',
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);

ALTER TABLE users ADD COLUMN IF NOT EXISTS company_id text REFERENCES companies(id) ON DELETE SET NULL;

-- First run only: the brand stored in settings becomes the first company and every user joins it.
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM companies) AND EXISTS (SELECT 1 FROM settings WHERE id = 'main') THEN
        INSERT INTO companies (id, name, entity, logo)
        SELECT 'principal', empresa, municipalidad, 'companies/principal.png' FROM settings WHERE id = 'main';
        UPDATE users SET company_id = 'principal' WHERE company_id IS NULL;
    END IF;
END $$;
