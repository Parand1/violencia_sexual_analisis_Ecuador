-- ======================================================================================
-- PROYECTO: Rompiendo el silencio estadístico: Violencia sexual contra niñas y adolescentes en Ecuador
-- AUTOR: Pablo Andrés Japón Calva
-- SCRIPT: 03_distribucion_etaria_mujeres_t742.sql
-- DESCRIPCIÓN: Agrupamiento de casos de Abuso Sexual (T74.2) en mujeres (2019-2024)
--               por grupos quinquenales de edad biológica estandarizada a días.
-- RESULTADO CLAVE: Concentración crítica en niñas y adolescentes de 10-14 años (41.92% de casos).
-- ======================================================================================

WITH CasosMujeresT742 AS (
    SELECT edad_en_dias FROM `airy-runway-450418-q9.warehouse.egresosnor_2019` WHERE cie10_codigo = 'T742' AND sexo = 'Mujer'
    UNION ALL
    SELECT edad_en_dias FROM `airy-runway-450418-q9.warehouse.egresosnor_2020` WHERE cie10_codigo = 'T742' AND sexo = 'Mujer'
    UNION ALL
    SELECT edad_en_dias FROM `airy-runway-450418-q9.warehouse.egresosnor_2021` WHERE cie10_codigo = 'Abuso sexual' AND sexo = 'Mujer'
    UNION ALL
    SELECT edad_en_dias FROM `airy-runway-450418-q9.warehouse.egresosnor_2022` WHERE cie10_codigo = 'T742' AND sexo = 'Mujer'
    UNION ALL
    SELECT edad_en_dias FROM `airy-runway-450418-q9.warehouse.egresosnor_2023` WHERE cie10_codigo = 'T742' AND sexo = 'Mujer'
    UNION ALL
    SELECT edad_en_dias FROM `airy-runway-450418-q9.warehouse.egresosnor`      WHERE cie10_codigo = 'T742' AND sexo = 'Mujer'
)

SELECT
    CASE
        WHEN edad_en_dias < 5 * 365 THEN '0-4 años'
        WHEN edad_en_dias >= 5 * 365 AND edad_en_dias < 10 * 365 THEN '5-9 años'
        WHEN edad_en_dias >= 10 * 365 AND edad_en_dias < 15 * 365 THEN '10-14 años'
        WHEN edad_en_dias >= 15 * 365 AND edad_en_dias < 20 * 365 THEN '15-19 años'
        WHEN edad_en_dias >= 20 * 365 THEN '20+ años'
        ELSE 'Edad desconocida'
    END AS grupo_edad,
    COUNT(*) AS numero_de_casos,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS porcentaje_del_total
FROM CasosMujeresT742
GROUP BY grupo_edad
ORDER BY MIN(edad_en_dias);
