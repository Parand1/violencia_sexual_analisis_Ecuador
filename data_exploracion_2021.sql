--CREACION DE TABLA DE EGRESOS NORMALIZADA 2021

CREATE OR REPLACE TABLE `airy-runway-450418-q9.warehouse.egresosnor_2021`
     PARTITION BY fecha_egr_dt
     CLUSTER BY sector_normalizado, cie10_codigo
     AS
     SELECT
    --1. ENRIQUECIMIENTO: Estandarización de la Edad a días
       CASE
         WHEN cod_edad LIKE 'Años%' THEN SAFE_CAST(edad AS INT64) * 365
        WHEN cod_edad LIKE 'Meses%' THEN SAFE_CAST(edad AS INT64) * 30
        WHEN cod_edad LIKE 'Días%' THEN SAFE_CAST(edad AS INT64)
        ELSE NULL
      END AS edad_en_dias,
   
      -- 2. ENRIQUECIMIENTO: NO SE PUEDE EXTRAER CIE 10 PURO, SE DEBE FLILTRAR POR DESCRIPCION CIE 10
      cau_cie10 AS cie10_codigo,
   
      -- 3. LIMPIEZA: Normalización del Sector (CORREGIDO)
      CASE
        WHEN sector = 'Público' THEN 'Público'
        WHEN sector = 'Privado con fines de lucro' THEN 'Privado'
        WHEN sector = 'Privado sin fines de lucro' THEN 'Privado' -- Corregido para agrupar ambos tipos de privados
        ELSE 'Otro'
      END AS sector_normalizado,
   
      -- 4. CASTING SEGURO: Conversión de tipos de datos
      SAFE_CAST(dia_estad AS INT64) AS dias_estancia,
      SAFE_CAST(fecha_ingr AS DATE) AS fecha_ingr_dt,
      SAFE_CAST(fecha_egr AS DATE) AS fecha_egr_dt,

      -- 5. NORMALIZACION ESPECIALIDAD DE EGRESO DEL PACIENTE
      REGEXP_REPLACE(NORMALIZE(UPPER(esp_egrpa), NFD), r'\p{M}', '') AS espegre,

    
      -- 6. SELECCIÓN DE COLUMNAS RELEVANTES
      sexo,
      etnia,
      prov_res,
      con_egrpa,
      cau_cie10,
      sector -- Mantenemos el sector original para verificación

   
    FROM
      `airy-runway-450418-q9.warehouse.egresos_2021`
    WHERE
      -- Filtro de calidad de datos (CORREGIDO)
      SAFE_CAST(dia_estad AS INT64) >= 0
      AND fecha_egr IS NOT NULL
      AND cau_cie10 IS NOT NULL
      AND con_egrpa IS NOT NULL
      AND sector IN ('Público', 'Privado con fines de lucro', 'Privado sin fines de lucro');


--EXPLORACION DE CIE 10 RELACIONADOS CON VIOLENCIA 2021
SELECT
DISTINCT(cie10_codigo),
FROM
warehouse.egresosnor_2021
WHERE
cau_cie10 LIKE 'Abuso sexual' OR
cau_cie10 LIKE 'Abuso de sustancias que no producen dependencia'OR
cau_cie10 LIKE 'Abuso físico'
;


--SELECCION DE CASOS POR DESCRIPCION DE CIE 10 MAS FRECUENTE 2021
SELECT
cie10_codigo,
sexo,
COUNT(*) AS numero_de_casos,
ROUND(AVG(edad_en_dias / 365.25),2) AS edad_promedio_anios,
ROUND(AVG(dias_estancia), 2) AS estancia_promedio,
AVG(CASE WHEN con_egrpa LIKE 'Fallecido%' THEN 1.0 ELSE 0.0 END) AS tasa_mortalidad
FROM
warehouse.egresosnor_2021
WHERE
cau_cie10 LIKE 'Abuso sexual' OR
cau_cie10 LIKE 'Abuso de sustancias que no producen dependencia'OR
cau_cie10 LIKE 'Abuso físico'
GROUP BY
cie10_codigo,
sexo
ORDER BY numero_de_casos DESC, cie10_codigo ASC;


-- ENFOQUE SOLO EN CIE 10 ABUSO SEXUAL POR PROVINCIA 2021
SELECT
prov_res,
COUNT(*) AS numero_de_casos,
ROUND(AVG(dias_estancia), 2) AS estancia_promedio,
ROUND(AVG(edad_en_dias / 365.25),2) AS edad_promedio_anios
FROM
warehouse.egresosnor_2021
WHERE
cau_cie10 LIKE 'Abuso sexual' 
GROUP BY
prov_res
ORDER BY numero_de_casos DESC, prov_res;


--TOP 3 PROVINCIAS - EXPLORACION DE DATOS 2021

SELECT
CASE
WHEN (edad_en_dias / 365.25) < 5 THEN '0-4 años'
WHEN (edad_en_dias / 365.25) >= 5 AND (edad_en_dias / 365.25) < 10 THEN '5-9 años'
WHEN (edad_en_dias / 365.25) >= 10 AND (edad_en_dias / 365.25) < 15 THEN '10-14 años'
WHEN (edad_en_dias / 365.25) >= 15 AND (edad_en_dias / 365.25) < 20 THEN '15-19 años'
ELSE '20+ años'
END AS grupo_edad,
sexo,
prov_res,
COUNT(*) AS numero_de_casos,
ROUND(AVG(dias_estancia), 2) AS estancia_promedio
FROM
warehouse.egresosnor_2021
WHERE
cau_cie10 = 'Abuso sexual' AND prov_res IN ('Azuay', 'Morona Santiago', 'Guayas')
GROUP BY
grupo_edad,
sexo,
prov_res
ORDER BY
prov_res,
sexo,
grupo_edad;


--EXPLORACION DE CASOS DE ABUSOS POR MES 2021
SELECT
EXTRACT(MONTH FROM fecha_ingr_dt) AS mes_ingreso,
COUNT(*) AS numero_de_casos,
ROUND(AVG(edad_en_dias / 365.25), 2) AS edad_promedio_anios,
ROUND(AVG(dias_estancia), 2) AS estancia_promedio
FROM
warehouse.egresosnor_2021
WHERE
cau_cie10 = 'Abuso sexual' -- Casos de Abuso Sexual
GROUP BY
mes_ingreso
ORDER BY
mes_ingreso;

