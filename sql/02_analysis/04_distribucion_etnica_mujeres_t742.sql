-- ======================================================================================
-- PROYECTO: Rompiendo el silencio estadístico: Violencia sexual contra niñas y adolescentes en Ecuador
-- AUTOR: Pablo Andrés Japón Calva
-- SCRIPT: 04_distribucion_etnica_mujeres_t742.sql
-- DESCRIPCIÓN: Desglose anual y acumulado de casos de Abuso Sexual (T74.2) en mujeres
--               según autoidentificación étnica declarada.
-- RESULTADO CLAVE: 81.05% Mestiza, 16.29% Indígena (coherente con la estructura demográfica nacional).
-- ======================================================================================

WITH CasosEtniaMujeres AS (
    SELECT 2019 AS anio, etnia FROM `airy-runway-450418-q9.warehouse.egresosnor_2019` WHERE cie10_codigo = 'T742' AND sexo = 'Mujer'
    UNION ALL
    SELECT 2020 AS anio, etnia FROM `airy-runway-450418-q9.warehouse.egresosnor_2020` WHERE cie10_codigo = 'T742' AND sexo = 'Mujer'
    UNION ALL
    SELECT 2021 AS anio, etnia FROM `airy-runway-450418-q9.warehouse.egresosnor_2021` WHERE cie10_codigo = 'Abuso sexual' AND sexo = 'Mujer'
    UNION ALL
    SELECT 2022 AS anio, etnia FROM `airy-runway-450418-q9.warehouse.egresosnor_2022` WHERE cie10_codigo = 'T742' AND sexo = 'Mujer'
    UNION ALL
    SELECT 2023 AS anio, etnia FROM `airy-runway-450418-q9.warehouse.egresosnor_2023` WHERE cie10_codigo = 'T742' AND sexo = 'Mujer'
    UNION ALL
    SELECT 2024 AS anio, etnia FROM `airy-runway-450418-q9.warehouse.egresosnor`      WHERE cie10_codigo = 'T742' AND sexo = 'Mujer'
)

SELECT
    etnia,
    COUNTIF(anio = 2019) AS casos_2019,
    COUNTIF(anio = 2020) AS casos_2020,
    COUNTIF(anio = 2021) AS casos_2021,
    COUNTIF(anio = 2022) AS casos_2022,
    COUNTIF(anio = 2023) AS casos_2023,
    COUNTIF(anio = 2024) AS casos_2024,
    COUNT(*) AS total_acumulado,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS porcentaje_total
FROM CasosEtniaMujeres
WHERE etnia IS NOT NULL
GROUP BY etnia
ORDER BY total_acumulado DESC;
