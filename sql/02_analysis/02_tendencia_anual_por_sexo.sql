-- ======================================================================================
-- PROYECTO: Rompiendo el silencio estadístico: Violencia sexual contra niñas y adolescentes en Ecuador
-- AUTOR: Pablo Andrés Japón Calva
-- SCRIPT: 02_tendencia_anual_por_sexo.sql
-- DESCRIPCIÓN: Serie temporal anual (2019-2024) de casos de Abuso Sexual (T74.2)
--               desagregados por sexo.
-- RESULTADO CLAVE: Brecha estructural de género (>90% mujeres) y patrón ascendente
--                  sostenido ("escalera") a partir de 2020 (143 -> 166 -> 233 -> 332 -> 363).
-- ======================================================================================

WITH CasosT742PorSexo AS (
    SELECT 2019 AS anio, sexo FROM `airy-runway-450418-q9.warehouse.egresosnor_2019` WHERE cie10_codigo = 'T742'
    UNION ALL
    SELECT 2020 AS anio, sexo FROM `airy-runway-450418-q9.warehouse.egresosnor_2020` WHERE cie10_codigo = 'T742'
    UNION ALL
    SELECT 2021 AS anio, sexo FROM `airy-runway-450418-q9.warehouse.egresosnor_2021` WHERE cie10_codigo = 'Abuso sexual'
    UNION ALL
    SELECT 2022 AS anio, sexo FROM `airy-runway-450418-q9.warehouse.egresosnor_2022` WHERE cie10_codigo = 'T742'
    UNION ALL
    SELECT 2023 AS anio, sexo FROM `airy-runway-450418-q9.warehouse.egresosnor_2023` WHERE cie10_codigo = 'T742'
    UNION ALL
    SELECT 2024 AS anio, sexo FROM `airy-runway-450418-q9.warehouse.egresosnor`      WHERE cie10_codigo = 'T742'
)

SELECT
    anio,
    sexo,
    COUNT(*) AS numero_de_casos,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(PARTITION BY anio), 2) AS porcentaje_anual
FROM CasosT742PorSexo
WHERE sexo IS NOT NULL
GROUP BY anio, sexo
ORDER BY anio, sexo;
