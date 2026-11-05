-- Borra TODO lo anterior a 2026-09: periodos, recibos, pagos y convenios de esos meses.
-- La deuda y los pagos de esos meses DESAPARECEN. Solo se recuperan desde un respaldo.
--
-- Por defecto solo muestra lo que borraría y deshace todo (ROLLBACK). Uso, desde la carpeta
-- donde está este archivo en el servidor:
--
-- 1. Vista previa (no cambia nada):
--    docker exec -i involt_db psql -U involt_user -d involt_db < borrar_periodos_antes_septiembre.sql
--
-- 2. Respaldo:
--    docker exec involt_db pg_dump -U involt_user -Fc involt_db > respaldo_antes_de_borrar.dump
--
-- 3. Borrado real:
--    docker exec -i involt_db psql -U involt_user -d involt_db -v confirmar=SI < borrar_periodos_antes_septiembre.sql

\set ON_ERROR_STOP on
\pset pager off
SET client_encoding = 'UTF8';

BEGIN;

CREATE TEMP TABLE recibos_viejos ON COMMIT DROP AS
SELECT r.id, r.customer_id, COALESCE(NULLIF(r.period, ''), to_char(r.period_start, 'YYYY-MM')) AS periodo,
       r.total_to_pay::numeric(12,2) AS total,
       COALESCE(pd.paid, 0)::numeric(12,2) AS pagado
FROM readings r
LEFT JOIN (
    SELECT pa.reading_id, SUM(pa.amount) AS paid
    FROM payment_allocations pa JOIN payments p ON p.id = pa.payment_id
    WHERE p.voided_at IS NULL
    GROUP BY pa.reading_id
) pd ON pd.reading_id = r.id
WHERE COALESCE(NULLIF(r.period, ''), to_char(r.period_start, 'YYYY-MM')) ~ '^\d{4}-\d{2}$'
  AND COALESCE(NULLIF(r.period, ''), to_char(r.period_start, 'YYYY-MM')) < '2026-09';

\echo
\echo '=== 1. Lo que se borra, por periodo ==='
SELECT COALESCE(periodo, 'TOTAL') AS periodo, COUNT(*) AS recibos, SUM(total) AS facturado,
       SUM(LEAST(pagado, total)) AS cobrado, SUM(GREATEST(total - pagado, 0)) AS deuda_que_desaparece
FROM recibos_viejos
GROUP BY ROLLUP (periodo)
ORDER BY periodo NULLS LAST;

\echo
\echo '=== 2. Deuda por caserío: antes y después del borrado ==='
SELECT COALESCE(s.name, '(sin caserío)') AS caserio,
       SUM(GREATEST(r.total_to_pay::numeric(12,2) - COALESCE(pd.paid, 0)::numeric(12,2), 0)) AS deuda_actual,
       SUM(GREATEST(r.total_to_pay::numeric(12,2) - COALESCE(pd.paid, 0)::numeric(12,2), 0))
         FILTER (WHERE r.id NOT IN (SELECT id FROM recibos_viejos)) AS deuda_despues
FROM readings r
JOIN customers c ON c.id = r.customer_id AND c.deleted_at IS NULL
LEFT JOIN sectors s ON s.id = c.sector_id
LEFT JOIN (
    SELECT pa.reading_id, SUM(pa.amount) AS paid
    FROM payment_allocations pa JOIN payments p ON p.id = pa.payment_id
    WHERE p.voided_at IS NULL
    GROUP BY pa.reading_id
) pd ON pd.reading_id = r.id
GROUP BY s.name
ORDER BY s.name;

\echo
\echo '=== 3. Pagos afectados ==='
SELECT CASE WHEN nuevos = 0 THEN 'Se borran completos' ELSE 'Mixtos: se les resta lo viejo' END AS tipo,
       COUNT(*) AS pagos, SUM(viejo)::numeric(12,2) AS monto_que_sale_de_caja
FROM (
    SELECT p.id,
           SUM(pa.amount + pa.late_fee) FILTER (WHERE pa.reading_id IN (SELECT id FROM recibos_viejos)) AS viejo,
           COUNT(*) FILTER (WHERE pa.reading_id NOT IN (SELECT id FROM recibos_viejos)) AS nuevos
    FROM payments p JOIN payment_allocations pa ON pa.payment_id = p.id
    WHERE p.voided_at IS NULL
    GROUP BY p.id
) t
WHERE viejo IS NOT NULL
GROUP BY 1;

\echo
\echo '=== 4. Convenios de pago que se borran (solo cubren meses viejos) ==='
SELECT a.number AS convenio, c.code, c.name, a.status AS estado, a.total
FROM payment_agreements a
JOIN customers c ON c.id = a.customer_id
WHERE EXISTS (SELECT 1 FROM agreement_receipts ar WHERE ar.agreement_id = a.id)
  AND NOT EXISTS (SELECT 1 FROM agreement_receipts ar WHERE ar.agreement_id = a.id
                  AND ar.reading_id NOT IN (SELECT id FROM recibos_viejos))
ORDER BY a.number;

-- Un convenio con recibos viejos y nuevos no se puede partir sin una decisión humana: se detiene todo.
DO $$
DECLARE mixtos text;
BEGIN
    SELECT string_agg(a.number::text, ', ') INTO mixtos
    FROM payment_agreements a
    WHERE EXISTS (SELECT 1 FROM agreement_receipts ar WHERE ar.agreement_id = a.id
                  AND ar.reading_id IN (SELECT id FROM recibos_viejos))
      AND EXISTS (SELECT 1 FROM agreement_receipts ar WHERE ar.agreement_id = a.id
                  AND ar.reading_id NOT IN (SELECT id FROM recibos_viejos));
    IF mixtos IS NOT NULL THEN
        RAISE EXCEPTION 'No se borró nada. Estos convenios cubren meses viejos y nuevos: %', mixtos;
    END IF;
END $$;

-- Sin el historial, la última lectura del medidor se tomaría de initial_reading. Se guarda ahí la
-- última lectura previa a septiembre para que el consumo siguiente se calcule bien.
UPDATE customers c
SET initial_reading = u.current_value
FROM (
    SELECT DISTINCT ON (r.customer_id) r.customer_id, r.current_value
    FROM readings r JOIN recibos_viejos v ON v.id = r.id
    WHERE r.current_value > 0
    ORDER BY r.customer_id, v.periodo DESC
) u
WHERE u.customer_id = c.id;

-- Pagos mixtos: conservan solo lo que corresponde a septiembre en adelante.
UPDATE payments p
SET amount = p.amount - t.viejo
FROM (
    SELECT pa.payment_id, SUM(pa.amount + pa.late_fee) AS viejo
    FROM payment_allocations pa
    WHERE pa.reading_id IN (SELECT id FROM recibos_viejos)
      AND pa.payment_id IN (SELECT payment_id FROM payment_allocations
                            WHERE reading_id NOT IN (SELECT id FROM recibos_viejos))
    GROUP BY pa.payment_id
) t
WHERE t.payment_id = p.id;

CREATE TEMP TABLE pagos_completos ON COMMIT DROP AS
SELECT DISTINCT pa.payment_id AS id
FROM payment_allocations pa
WHERE pa.reading_id IN (SELECT id FROM recibos_viejos)
  AND pa.payment_id NOT IN (SELECT payment_id FROM payment_allocations
                            WHERE reading_id NOT IN (SELECT id FROM recibos_viejos));

DELETE FROM payment_agreements a
WHERE EXISTS (SELECT 1 FROM agreement_receipts ar WHERE ar.agreement_id = a.id
              AND ar.reading_id IN (SELECT id FROM recibos_viejos));
DELETE FROM late_fee_waivers WHERE reading_id IN (SELECT id FROM recibos_viejos);
DELETE FROM payment_allocations WHERE reading_id IN (SELECT id FROM recibos_viejos);
DELETE FROM payments WHERE id IN (SELECT id FROM pagos_completos);
DELETE FROM readings WHERE id IN (SELECT id FROM recibos_viejos);
DELETE FROM periods WHERE id ~ '^\d{4}-\d{2}$' AND id < '2026-09';

\echo
\echo '=== 5. Periodos que quedan ==='
SELECT id AS periodo, status AS estado,
       (SELECT COUNT(*) FROM readings r WHERE r.period = periods.id) AS recibos
FROM periods
ORDER BY id DESC;

\echo
\if :{?confirmar}
    COMMIT;
    \echo '>>> BORRADO APLICADO.'
\else
    ROLLBACK;
    \echo '>>> VISTA PREVIA: no se cambió nada. Para borrar, sigue los pasos 2 y 3 de la cabecera.'
\endif
