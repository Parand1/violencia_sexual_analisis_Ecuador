--CONTEO DE CASOS DE VIOLENCIA MAS FRECUENTES
WITH DatosUnificados AS (
       -- Año 2019
       SELECT
         REPLACE(cie10_codigo, '.', '') AS cie10_codigo -- Aseguramos formato sin puntos (ej. T742)
       FROM `airy-runway-450418-q9.warehouse.egresosnor_2019`
       WHERE cie10_codigo LIKE 'T74%'
    
       UNION ALL
    
      -- Año 2020
      SELECT
        REPLACE(cie10_codigo, '.', '') AS cie10_codigo
      FROM `airy-runway-450418-q9.warehouse.egresosnor_2020`
      WHERE cie10_codigo LIKE 'T74%'
   
      UNION ALL
   
      -- Año 2021 (Manejo Especial: Mapeo de descripciones a códigos)
      SELECT
        CASE
          WHEN cie10_codigo LIKE 'Abuso sexual%' THEN 'T742'
          WHEN cie10_codigo LIKE 'Abuso físico%' THEN 'T741'
          WHEN cie10_codigo LIKE 'Abuso psicológico%' THEN 'T743'
          WHEN cie10_codigo LIKE 'Negligencia%' OR cie10_codigo LIKE 'Abandono%' THEN 'T740'
          WHEN cie10_codigo LIKE 'Otro maltrato%' THEN 'T748'
          ELSE 'T749' -- Asumimos el resto como no especificado dentro del contexto de violencia
        END AS cie10_codigo
      FROM `airy-runway-450418-q9.warehouse.egresosnor_2021`
      WHERE
        cie10_codigo LIKE 'Abuso%'
        OR cie10_codigo LIKE 'Negligencia%'
        OR cie10_codigo LIKE 'Maltrato%'
   
      UNION ALL
   
      -- Año 2022
      SELECT
        REPLACE(cie10_codigo, '.', '') AS cie10_codigo
      FROM `airy-runway-450418-q9.warehouse.egresosnor_2022`
      WHERE cie10_codigo LIKE 'T74%'
   
      UNION ALL
   
      -- Año 2023
      SELECT
        REPLACE(cie10_codigo, '.', '') AS cie10_codigo
      FROM `airy-runway-450418-q9.warehouse.egresosnor_2023`
      WHERE cie10_codigo LIKE 'T74%'
   
      UNION ALL
   
      -- Año 2024
      SELECT
        REPLACE(cie10_codigo, '.', '') AS cie10_codigo
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
        ELSE 'Otro'
      END AS descripcion_diagnostico,
      COUNT(*) AS total_casos_acumulados,
      ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS porcentaje_del_total
    FROM DatosUnificados
    GROUP BY cie10_codigo
    ORDER BY total_casos_acumulados DESC;



-- CONTEO DE CASOS DE ABUSO SEXUAL POR AÑO
SELECT
         anio,
         COUNT(*) AS numero_de_casos
     FROM (
         -- Datos de 2019
         SELECT 2019 AS anio FROM `airy-runway-450418-q9.warehouse.egresosnor_2019` WHERE cie10_codigo =
      'T742' AND sexo = 'Mujer'
         UNION ALL
         -- Datos de 2020
        SELECT 2020 AS anio FROM `airy-runway-450418-q9.warehouse.egresosnor_2020` WHERE cie10_codigo =
      'T742' AND sexo = 'Mujer'
        UNION ALL
        -- Datos de 2021 (Manejo especial por descripción)
        SELECT 2021 AS anio FROM `airy-runway-450418-q9.warehouse.egresosnor_2021` WHERE cie10_codigo = 'Abuso sexual' AND sexo = 'Mujer'
        UNION ALL
        -- Datos de 2022
        SELECT 2022 AS anio FROM `airy-runway-450418-q9.warehouse.egresosnor_2022` WHERE cie10_codigo =
      'T742' AND sexo = 'Mujer'
        UNION ALL
        -- Datos de 2023
        SELECT 2023 AS anio FROM `airy-runway-450418-q9.warehouse.egresosnor_2023` WHERE cie10_codigo =
      'T742' AND sexo = 'Mujer'
        UNION ALL
        -- Datos de 2024
        SELECT 2024 AS anio FROM `airy-runway-450418-q9.warehouse.egresosnor` WHERE cie10_codigo =
      'T742' AND sexo = 'Mujer'
    ) AS datos_unificados
    GROUP BY
        anio
    ORDER BY
        anio;


 -- CONTEO DE CASOS T742 en mujeres por grupo de edad (2019-2024)
WITH datos_filtrados AS (
-- Unificar datos de todos los años, filtrando desde el inicio para eficiencia
SELECT edad_en_dias FROM `airy-runway-450418-q9.warehouse.egresosnor_2019` WHERE cie10_codigo = 'T742'
AND sexo = 'Mujer'
UNION ALL
SELECT edad_en_dias FROM `airy-runway-450418-q9.warehouse.egresosnor_2020` WHERE cie10_codigo = 'T742'
AND sexo = 'Mujer'
UNION ALL
SELECT edad_en_dias FROM `airy-runway-450418-q9.warehouse.egresosnor_2021` WHERE cie10_codigo = 'Abuso sexual' AND sexo = 'Mujer'
UNION ALL
SELECT edad_en_dias FROM `airy-runway-450418-q9.warehouse.egresosnor_2022` WHERE cie10_codigo = 'T742'
AND sexo = 'Mujer'
UNION ALL
SELECT edad_en_dias FROM `airy-runway-450418-q9.warehouse.egresosnor_2023` WHERE cie10_codigo = 'T742'
AND sexo = 'Mujer'
UNION ALL
SELECT edad_en_dias FROM `airy-runway-450418-q9.warehouse.egresosnor` WHERE cie10_codigo = 'T742'
AND sexo = 'Mujer'
)
-- Agrupar por los rangos de edad definidos
SELECT
CASE
WHEN edad_en_dias < 5 * 365 THEN '0-4 años'
WHEN edad_en_dias >= 5 * 365 AND edad_en_dias < 10 * 365 THEN '5-9 años'
WHEN edad_en_dias >= 10 * 365 AND edad_en_dias < 15 * 365 THEN '10-14 años'
WHEN edad_en_dias >= 15 * 365 AND edad_en_dias < 20 * 365 THEN '15-19 años'
WHEN edad_en_dias >= 20 * 365 THEN '20+ años'
ELSE 'Edad desconocida'
END AS grupo_edad,
COUNT(*) AS numero_de_casos
FROM
datos_filtrados
GROUP BY
grupo_edad
ORDER BY
-- Ordenar para que los grupos de edad aparezcan en secuencia lógica
MIN(edad_en_dias);


-- CONTEO DE CASOS DE ABSUO SEXUAL POR SEXO 2019 A 2024

 WITH datos_filtrados AS (
-- Unificar datos de todos los años, filtrando por T74.2 para eficiencia
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
SELECT 2024 AS anio, sexo FROM `airy-runway-450418-q9.warehouse.egresosnor` WHERE cie10_codigo = 'T742'
 )
 -- Agrupar por año y sexo para obtener el conteo final
SELECT
anio,
sexo,
COUNT(*) AS numero_de_casos
FROM
datos_filtrados
WHERE
sexo IS NOT NULL
GROUP BY
anio,
sexo
ORDER BY
anio,
sexo;


-- CONTEO DE CASOS DE ABSUO SEXUAL POR ETNIA Y SEXO MUJER 2019 A 2024

 WITH datos_filtrados AS (
-- Unificar datos de todos los años, filtrando por T742 para eficiencia
SELECT 2019 AS anio, etnia, sexo FROM `airy-runway-450418-q9.warehouse.egresosnor_2019` WHERE cie10_codigo = 'T742'
UNION ALL
SELECT 2020 AS anio, etnia, sexo FROM `airy-runway-450418-q9.warehouse.egresosnor_2020` WHERE cie10_codigo = 'T742'
UNION ALL
SELECT 2021 AS anio, etnia, sexo FROM `airy-runway-450418-q9.warehouse.egresosnor_2021` WHERE cie10_codigo = 'Abuso sexual'
UNION ALL
SELECT 2022 AS anio, etnia, sexo FROM `airy-runway-450418-q9.warehouse.egresosnor_2022` WHERE cie10_codigo = 'T742'
UNION ALL
SELECT 2023 AS anio, etnia, sexo FROM `airy-runway-450418-q9.warehouse.egresosnor_2023` WHERE cie10_codigo = 'T742'
UNION ALL
SELECT 2024 AS anio, etnia, sexo FROM `airy-runway-450418-q9.warehouse.egresosnor` WHERE cie10_codigo = 'T742'
 )
 -- Agrupar por año y etnia para obtener el conteo final
SELECT
anio,
etnia,
COUNT(*) AS numero_de_casos
FROM
datos_filtrados
WHERE TRUE
AND etnia IS NOT NULL
AND sexo = 'Mujer'
GROUP BY
anio,
etnia
ORDER BY
anio,
etnia;


-- CONTEO DE CASOS DE ABSUO SEXUAL POR AREA DE RESIDENCIA Y SEXO MUJER 2019 A 2024

 WITH datos_filtrados AS (
-- Unificar datos de todos los años, filtrando por T742 para eficiencia
SELECT 2019 AS anio, area_res, sexo FROM `airy-runway-450418-q9.warehouse.egresosnor_2019` WHERE cie10_codigo = 'T742'
UNION ALL
SELECT 2020 AS anio, area_res, sexo FROM `airy-runway-450418-q9.warehouse.egresosnor_2020` WHERE cie10_codigo = 'T742'
UNION ALL
SELECT 2021 AS anio, area_res, sexo FROM `airy-runway-450418-q9.warehouse.egresosnor_2021` WHERE cie10_codigo = 'Abuso sexual'
UNION ALL
SELECT 2022 AS anio, area_res, sexo FROM `airy-runway-450418-q9.warehouse.egresosnor_2022` WHERE cie10_codigo = 'T742'
UNION ALL
SELECT 2023 AS anio, area_res, sexo FROM `airy-runway-450418-q9.warehouse.egresosnor_2023` WHERE cie10_codigo = 'T742'
UNION ALL
SELECT 2024 AS anio, area_res, sexo FROM `airy-runway-450418-q9.warehouse.egresosnor` WHERE cie10_codigo = 'T742'
 )
 -- Agrupar por año y etnia para obtener el conteo final
SELECT
anio,
area_res,
COUNT(*) AS numero_de_casos
FROM
datos_filtrados
WHERE TRUE
AND area_res IS NOT NULL
AND sexo = 'Mujer'
GROUP BY
anio,
area_res
ORDER BY
anio,
area_res;



--DISTRIBUCION DE CASOS DE ABUSO SEXUAL POR MES 2019 A 2024

WITH datos_filtrados AS (
-- Unificar datos de todos los años, filtrando por T74.2 para eficiencia
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
SELECT fecha_ingr_dt FROM `airy-runway-450418-q9.warehouse.egresosnor` WHERE cie10_codigo = 'T742'
)
-- Agrupar por año y mes para obtener el conteo
SELECT
EXTRACT(YEAR FROM fecha_ingr_dt) AS anio,
EXTRACT(MONTH FROM fecha_ingr_dt) AS mes,
COUNT(*) AS numero_de_casos
FROM
datos_filtrados
WHERE
fecha_ingr_dt IS NOT NULL
GROUP BY
anio,
mes
ORDER BY
anio,
mes;

