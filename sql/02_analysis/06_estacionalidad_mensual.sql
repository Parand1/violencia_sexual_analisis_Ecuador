-- ======================================================================================
-- PROYECTO: Rompiendo el silencio estadístico: Violencia sexual contra niñas y adolescentes en Ecuador
-- AUTOR: Pablo Andrés Japón Calva
-- SCRIPT: 06_estacionalidad_mensual.sql
-- DESCRIPCIÓN: Análisis temporal mensual de los ingresos hospitalarios por abuso sexual.
-- RESULTADO CLAVE: Identificación de picos cíclicos de ingreso en septiembre (coincidente
--                  con el inicio del ciclo escolar en la Sierra/Amazonía).
-- ======================================================================================

WITH CasosPorFecha AS (
    SELECT fecha_ingr_dt FROM `airy-runway-450418-q9.warehouse.egresosnor_2019` WHERE cie10_codigo = 'T742'
    UNION ALL
    SELECT fecha_ingr_dt FROM `airy-runway-450418-q9.warehouse.egresosnor_2020` WHERE cie10_codigo = 'T742'
    UNION ALL
    SELECT fecha_ingr_dt FROM `airy-runway-450418-q9.warehouse.egresosnor_2021` WHERE cie10_codigo = 'Abuso sexual'
    UNION ALL
    SELECT fecha_ingr_dt FROM `airy-runway-450418-q9.warehouse.egresosnor_2022` WHERE cie10_codigo = 'T742'
    UNION ALL
    SELECT fecha_ingr_dt FROM `airy-runway-450418-q9.warehouse.egresosnor_2023` WHERE cie10_codigo = 'T742'
    UNION ALL
    SELECT fecha_ingr_dt FROM `airy-runway-450418-q9.warehouse.egresosnor`      WHERE cie10_codigo = 'T742'
)

SELECT
    EXTRACT(YEAR FROM fecha_ingr_dt)  AS anio,
    EXTRACT(MONTH FROM fecha_ingr_dt) AS mes,
    COUNT(*) AS numero_de_casos
FROM CasosPorFecha
WHERE fecha_ingr_dt IS NOT NULL
GROUP BY anio, mes
ORDER BY anio, mes;
