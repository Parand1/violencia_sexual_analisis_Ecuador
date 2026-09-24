-- ======================================================================================
-- PROYECTO: Rompiendo el silencio estadístico: Violencia sexual contra niñas y adolescentes en Ecuador
-- AUTOR: Pablo Andrés Japón Calva
-- SCRIPT: 05_etl_egresosnor_2023.sql
-- DESCRIPCIÓN: Creación y normalización de la tabla de egresos hospitalarios 2023 en BigQuery.
-- ======================================================================================

CREATE OR REPLACE TABLE `airy-runway-450418-q9.warehouse.egresosnor_2023`
PARTITION BY fecha_egr_dt
CLUSTER BY sector_normalizado, cie10_codigo AS
SELECT
    -- 1. Estandarización de la Edad a días
    CASE
        WHEN cod_edad LIKE 'Años%' THEN SAFE_CAST(edad AS INT64) * 365
        WHEN cod_edad LIKE 'Meses%' THEN SAFE_CAST(edad AS INT64) * 30
        WHEN cod_edad LIKE 'Días%' THEN SAFE_CAST(edad AS INT64)
        ELSE NULL
    END AS edad_en_dias,

    -- 2. Extracción del código CIE-10 puro
    SPLIT(cau_cie10, ' ')[OFFSET(0)] AS cie10_codigo,

    -- 3. Normalización del Sector
    CASE
        WHEN sector = 'Público' THEN 'Público'
        WHEN sector IN ('Privado con fines de lucro', 'Privado sin fines de lucro') THEN 'Privado'
        ELSE 'Otro'
    END AS sector_normalizado,

    -- 4. Conversión segura de tipos
    SAFE_CAST(dia_estad AS INT64) AS dias_estancia,
    SAFE_CAST(fecha_ingr AS DATE) AS fecha_ingr_dt,
    SAFE_CAST(fecha_egr AS DATE)  AS fecha_egr_dt,

    -- 5. Normalización de especialidad médica
    REGEXP_REPLACE(NORMALIZE(UPPER(esp_egrpa), NFD), r'\p{M}', '') AS espegre,

    -- 6. Columnas de interés
    sexo,
    etnia,
    prov_res,
    con_egrpa,
    cau_cie10,
    sector,
    area_res

FROM `airy-runway-450418-q9.warehouse.egresos_2023`
WHERE
    SAFE_CAST(dia_estad AS INT64) >= 0
    AND fecha_egr IS NOT NULL
    AND cau_cie10 IS NOT NULL
    AND con_egrpa IS NOT NULL
    AND sector IN ('Público', 'Privado con fines de lucro', 'Privado sin fines de lucro');
