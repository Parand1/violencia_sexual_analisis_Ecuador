-- ======================================================================================
-- PROYECTO: Rompiendo el silencio estadístico: Violencia sexual contra niñas y adolescentes en Ecuador
-- AUTOR: Pablo Andrés Japón Calva
-- SCRIPT: 01_prevalencia_sindromes_maltrato_t74.sql
-- DESCRIPCIÓN: Consulta unificada 2019-2024 para cuantificar la prevalencia de los
--               distintos síndromes de maltrato (CIE-10 T74).
-- RESULTADO CLAVE: El Abuso Sexual (T74.2) representa el 78.04% del total acumulado.
-- ======================================================================================

WITH DatosUnificados AS (
    -- Año 2019
    SELECT REPLACE(cie10_codigo, '.', '') AS cie10_codigo
    FROM `airy-runway-450418-q9.warehouse.egresosnor_2019`
    WHERE cie10_codigo LIKE 'T74%'

    UNION ALL

    -- Año 2020
    SELECT REPLACE(cie10_codigo, '.', '') AS cie10_codigo
    FROM `airy-runway-450418-q9.warehouse.egresosnor_2020`
    WHERE cie10_codigo LIKE 'T74%'

    UNION ALL

    -- Año 2021 (Manejo especial: normalización de descripciones a códigos)
    SELECT
        CASE
            WHEN cie10_codigo LIKE 'Abuso sexual%' THEN 'T742'
            WHEN cie10_codigo LIKE 'Abuso físico%' THEN 'T741'
            WHEN cie10_codigo LIKE 'Abuso psicológico%' THEN 'T743'
            WHEN cie10_codigo LIKE 'Negligencia%' OR cie10_codigo LIKE 'Abandono%' THEN 'T740'
            WHEN cie10_codigo LIKE 'Otro maltrato%' THEN 'T748'
            ELSE 'T749'
        END AS cie10_codigo
    FROM `airy-runway-450418-q9.warehouse.egresosnor_2021`
    WHERE
        cie10_codigo LIKE 'Abuso%'
        OR cie10_codigo LIKE 'Negligencia%'
        OR cie10_codigo LIKE 'Maltrato%'

    UNION ALL

    -- Año 2022
    SELECT REPLACE(cie10_codigo, '.', '') AS cie10_codigo
    FROM `airy-runway-450418-q9.warehouse.egresosnor_2022`
    WHERE cie10_codigo LIKE 'T74%'

    UNION ALL

    -- Año 2023
    SELECT REPLACE(cie10_codigo, '.', '') AS cie10_codigo
    FROM `airy-runway-450418-q9.warehouse.egresosnor_2023`
    WHERE cie10_codigo LIKE 'T74%'

    UNION ALL

    -- Año 2024
    SELECT REPLACE(cie10_codigo, '.', '') AS cie10_codigo
    FROM `airy-runway-450418-q9.warehouse.egresosnor`
    WHERE cie10_codigo LIKE 'T74%'
)

SELECT
    cie10_codigo,
    CASE
        WHEN cie10_codigo = 'T742' THEN 'Abuso sexual'
        WHEN cie10_codigo = 'T741' THEN 'Abuso físico'
        WHEN cie10_codigo = 'T740' THEN 'Negligencia o abandono'
        WHEN cie10_codigo = 'T743' THEN 'Abuso psicológico'
        WHEN cie10_codigo = 'T748' THEN 'Otros síndromes de maltrato'
        WHEN cie10_codigo = 'T749' THEN 'Síndrome del maltrato, no especificado'
        ELSE 'Otro síndrome'
    END AS descripcion_diagnostico,
    COUNT(*) AS total_casos_acumulados,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS porcentaje_del_total
FROM DatosUnificados
GROUP BY cie10_codigo
ORDER BY total_casos_acumulados DESC;
