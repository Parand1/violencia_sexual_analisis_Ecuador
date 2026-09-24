-- ======================================================================================
-- PROYECTO: Rompiendo el silencio estadístico: Violencia sexual contra niñas y adolescentes en Ecuador
-- AUTOR: Pablo Andrés Japón Calva
-- SCRIPT: 05_distribucion_rural_urbano.sql
-- DESCRIPCIÓN: Distribución anual de casos de Abuso Sexual (T74.2) en mujeres
--               según el área de residencia (Rural vs. Urbana).
-- RESULTADO CLAVE: Estabilidad temporal de la proporción (66.3% urbana vs 33.7% rural,
--                  prueba Chi-cuadrado p = 0.921, sin diferencias significativas a través del tiempo).
-- ======================================================================================

WITH CasosAreaMujeres AS (
    SELECT 2019 AS anio, area_res FROM `airy-runway-450418-q9.warehouse.egresosnor_2019` WHERE cie10_codigo = 'T742' AND sexo = 'Mujer'
    UNION ALL
    SELECT 2020 AS anio, area_res FROM `airy-runway-450418-q9.warehouse.egresosnor_2020` WHERE cie10_codigo = 'T742' AND sexo = 'Mujer'
    UNION ALL
    SELECT 2021 AS anio, area_res FROM `airy-runway-450418-q9.warehouse.egresosnor_2021` WHERE cie10_codigo = 'Abuso sexual' AND sexo = 'Mujer'
    UNION ALL
    SELECT 2022 AS anio, area_res FROM `airy-runway-450418-q9.warehouse.egresosnor_2022` WHERE cie10_codigo = 'T742' AND sexo = 'Mujer'
    UNION ALL
    SELECT 2023 AS anio, area_res FROM `airy-runway-450418-q9.warehouse.egresosnor_2023` WHERE cie10_codigo = 'T742' AND sexo = 'Mujer'
    UNION ALL
    SELECT 2024 AS anio, area_res FROM `airy-runway-450418-q9.warehouse.egresosnor`      WHERE cie10_codigo = 'T742' AND sexo = 'Mujer'
)

SELECT
    anio,
    COUNTIF(area_res = 'Rural')  AS area_rural,
    COUNTIF(area_res = 'Urbana') AS area_urbana,
    COUNT(*)                     AS total_anual,
    ROUND(COUNTIF(area_res = 'Rural') * 100.0 / COUNT(*), 2)  AS pct_rural,
    ROUND(COUNTIF(area_res = 'Urbana') * 100.0 / COUNT(*), 2) AS pct_urbano
FROM CasosAreaMujeres
WHERE area_res IS NOT NULL
GROUP BY anio
ORDER BY anio;
