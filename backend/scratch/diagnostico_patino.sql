-- Diagnóstico de deuda del caserío Patiño. SOLO LECTURA: no modifica ningún dato.
-- Calcula el saldo igual que el panel de Cobranzas (recibo menos pagos no anulados).
--
-- Uso, desde la carpeta donde está el docker-compose.yml del servidor:
--   docker compose exec -T db psql -U involt_user -d involt_db < diagnostico_patino.sql

BEGIN TRANSACTION READ ONLY;

\pset pager off
\set ON_ERROR_STOP on
SET client_encoding = 'UTF8';

\set sectores '(SELECT s.id FROM sectors s LEFT JOIN communities cm ON cm.id = s.community_id WHERE s.name ~* \'pati(n|ñ|Ñ)o\' OR cm.name ~* \'pati(n|ñ|Ñ)o\')'
\set recibos '(SELECT r.id AS reading_id, c.id AS customer_id, c.code, c.name, c.service_status, c.service_status_changed_at, COALESCE(NULLIF(r.period, \'\'), to_char(r.period_start, \'YYYY-MM\')) AS periodo, r.total_to_pay::numeric(12,2) AS total, COALESCE(pd.paid, 0)::numeric(12,2) AS pagado, GREATEST(r.total_to_pay::numeric(12,2) - COALESCE(pd.paid, 0)::numeric(12,2), 0) AS saldo, r.is_paid, r.expiration_date, r."timestamp" AS emitido, r.consumption, r.observation FROM readings r JOIN customers c ON c.id = r.customer_id LEFT JOIN (SELECT pa.reading_id, SUM(pa.amount) AS paid FROM payment_allocations pa JOIN payments p ON p.id = pa.payment_id WHERE p.voided_at IS NULL GROUP BY pa.reading_id) pd ON pd.reading_id = r.id WHERE c.deleted_at IS NULL AND c.sector_id IN (SELECT s.id FROM sectors s LEFT JOIN communities cm ON cm.id = s.community_id WHERE s.name ~* \'pati(n|ñ|Ñ)o\' OR cm.name ~* \'pati(n|ñ|Ñ)o\'))'

\echo
\echo '=== 1. Caserío encontrado (debe aparecer solo Patiño) ==='
SELECT s.id, s.name AS caserio, cm.name AS comunidad,
       COUNT(c.id) AS usuarios,
       COUNT(c.id) FILTER (WHERE c.service_status = 'ACTIVE') AS con_servicio,
       COUNT(c.id) FILTER (WHERE c.service_status = 'TEMPORARY_CUT') AS corte_temporal,
       COUNT(c.id) FILTER (WHERE c.service_status = 'NO_POWER') AS sin_energia
FROM sectors s
LEFT JOIN communities cm ON cm.id = s.community_id
LEFT JOIN customers c ON c.sector_id = s.id AND c.deleted_at IS NULL
WHERE s.id IN :sectores
GROUP BY s.id, s.name, cm.name
ORDER BY s.name;

\echo
\echo '=== 2. ¿DE QUIÉN ES LA DEUDA? Activos vs. corte temporal (esta es la respuesta principal) ==='
SELECT COALESCE(service_status, 'TOTAL') AS estado,
       COUNT(DISTINCT customer_id) FILTER (WHERE saldo > 0) AS usuarios_con_deuda,
       COUNT(*) FILTER (WHERE saldo > 0) AS recibos_pendientes,
       SUM(saldo) AS deuda
FROM :recibos t
GROUP BY ROLLUP (service_status)
ORDER BY service_status NULLS LAST;

\echo
\echo '=== 3. Deuda por periodo (para comparar con el rango elegido en pantalla) ==='
SELECT periodo, SUM(total) AS facturado, SUM(LEAST(pagado, total)) AS cobrado, SUM(saldo) AS deuda,
       COUNT(DISTINCT customer_id) FILTER (WHERE saldo > 0) AS usuarios_con_deuda
FROM :recibos t
GROUP BY periodo
ORDER BY periodo;

\echo
\echo '=== 4. Usuarios con deuda ==='
SELECT t.code, t.name, t.service_status AS estado,
       t.service_status_changed_at::date AS fecha_estado,
       COUNT(*) AS recibos_pendientes,
       SUM(t.saldo) AS deuda,
       MIN(t.periodo) AS periodo_mas_antiguo,
       MAX(t.periodo) AS periodo_mas_reciente,
       (SELECT MAX(p.paid_at)::date FROM payments p
         WHERE p.customer_id = t.customer_id AND p.voided_at IS NULL) AS ultimo_pago
FROM :recibos t
WHERE t.saldo > 0
GROUP BY t.customer_id, t.code, t.name, t.service_status, t.service_status_changed_at
ORDER BY deuda DESC, t.code;

\echo
\echo '=== 5. Recibos pendientes uno por uno (¿se emitieron después del corte?) ==='
SELECT t.code, t.name, t.service_status AS estado, t.periodo,
       t.total, t.pagado, t.saldo, t.consumption AS consumo_kwh,
       t.is_paid AS marcado_pagado,
       t.emitido::date AS emitido, t.expiration_date AS vence,
       CASE WHEN t.service_status <> 'ACTIVE'
             AND t.emitido > t.service_status_changed_at THEN 'SÍ' ELSE '' END AS emitido_tras_corte,
       t.observation AS observacion
FROM :recibos t
WHERE t.saldo > 0
ORDER BY t.code, t.periodo;

\echo
\echo '=== 6. Historial de cortes y motivos (usuarios que no están activos) ==='
SELECT c.code, c.name, h.previous_status AS antes, h.status AS despues,
       h.changed_at::date AS fecha, h.changed_by_email AS por, h.reason AS motivo
FROM customers c
LEFT JOIN customer_status_changes h ON h.customer_id = c.id
WHERE c.deleted_at IS NULL AND c.sector_id IN :sectores AND c.service_status <> 'ACTIVE'
ORDER BY c.code, h.changed_at;

\echo
\echo '=== 7. Pagos anulados (una anulación vuelve a abrir la deuda) ==='
SELECT c.code, c.name, p.receipt_number AS recibo_caja, p.amount AS monto,
       p.paid_at::date AS pagado, p.voided_at::date AS anulado, p.voided_by AS por, p.void_reason AS motivo
FROM payments p
JOIN customers c ON c.id = p.customer_id
WHERE p.voided_at IS NOT NULL AND c.deleted_at IS NULL AND c.sector_id IN :sectores
ORDER BY p.voided_at DESC;

\echo
\echo '=== 8. Convenios de pago de usuarios del caserío ==='
SELECT c.code, c.name, a.number AS convenio, a.status AS estado, a.total, a.initial_amount AS inicial,
       a.created_at::date AS creado, a.cancelled_at::date AS cancelado
FROM payment_agreements a
JOIN customers c ON c.id = a.customer_id
WHERE c.deleted_at IS NULL AND c.sector_id IN :sectores
ORDER BY a.created_at DESC;

\echo
\echo '=== 9. Datos inconsistentes (lo normal es que salga vacío) ==='
\echo '--- 9a. Marcado como pagado pero con saldo, o sin marcar y ya pagado'
SELECT t.code, t.name, t.periodo, t.total, t.pagado, t.saldo, t.is_paid AS marcado_pagado
FROM :recibos t
WHERE (t.is_paid AND t.saldo > 0) OR (NOT t.is_paid AND t.total > 0 AND t.saldo = 0)
ORDER BY t.code, t.periodo;

\echo '--- 9b. Mismo usuario con más de un recibo en el mismo periodo'
SELECT t.code, t.name, t.periodo, COUNT(*) AS recibos, SUM(t.total) AS total, SUM(t.saldo) AS saldo
FROM :recibos t
GROUP BY t.customer_id, t.code, t.name, t.periodo
HAVING COUNT(*) > 1
ORDER BY t.code, t.periodo;

ROLLBACK;
