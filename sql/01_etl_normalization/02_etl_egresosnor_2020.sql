-- ======================================================================================
-- PROYECTO: Rompiendo el silencio estadístico: Violencia sexual contra niñas y adolescentes en Ecuador
-- AUTOR: Pablo Andrés Japón Calva
-- SCRIPT: 02_etl_egresosnor_2020.sql
-- DESCRIPCIÓN: Creación y normalización de la tabla de egresos hospitalarios 2020 en BigQuery.
-- ======================================================================================

CREATE OR REPLACE TABLE `airy-runway-450418-q9.warehouse.egresosnor_2020`
PARTITION BY fecha_egr_dt
CLUSTER BY sector_normalizado, cie10_codigo AS
SELECT
    -- 1. Estandarización de la Edad a días
    CASE SAFE_CAST(cod_edad AS INT64)
        WHEN 4 THEN SAFE_CAST(edad AS INT64) * 365 -- Años
        WHEN 3 THEN SAFE_CAST(edad AS INT64) * 30  -- Meses
        WHEN 2 THEN SAFE_CAST(edad AS INT64)      -- Días
        ELSE NULL
    END AS edad_en_dias,

    -- 2. Código CIE-10 puro (formato estandarizado sin puntos)
    REPLACE(cau_cie10, '.', '') AS cie10_codigo,

    -- 3. Normalización del Sector
    CASE SAFE_CAST(sector AS INT64)
        WHEN 1 THEN 'Público'
        WHEN 2 THEN 'Privado'
        WHEN 3 THEN 'Privado'
        ELSE 'Otro'
    END AS sector_normalizado,

    -- 4. Conversión de tipos
    SAFE_CAST(dia_estad AS INT64) AS dias_estancia,
    SAFE_CAST(fecha_ingr AS DATE) AS fecha_ingr_dt,
    SAFE_CAST(fecha_egr AS DATE)  AS fecha_egr_dt,

    -- 5. Normalización y decodificación de la especialidad de egreso
    UPPER(CASE SAFE_CAST(esp_egrpa AS INT64)
        WHEN 1 THEN 'Alergología'
        WHEN 2 THEN 'Atención Primaria de la Salud'
        WHEN 3 THEN 'Cardiología'
        WHEN 4 THEN 'Cardiopediatría'
        WHEN 5 THEN 'Cirugía Cardiaca'
        WHEN 6 THEN 'Cirugía Toráxica'
        WHEN 7 THEN 'Cirugía General'
        WHEN 8 THEN 'Cirugía Máxilo Facial'
        WHEN 9 THEN 'Cirugía Oncológica'
        WHEN 10 THEN 'Cirugía Pediátrica'
        WHEN 11 THEN 'Cirugía Plástica'
        WHEN 12 THEN 'Cirugía Vascular'
        WHEN 13 THEN 'Clínica del Dolor'
        WHEN 14 THEN 'Dermatología'
        WHEN 15 THEN 'Endocrinología'
        WHEN 16 THEN 'Endodoncia'
        WHEN 17 THEN 'Gastroenterología'
        WHEN 18 THEN 'Genética'
        WHEN 19 THEN 'Geriatría'
        WHEN 20 THEN 'Gerontología'
        WHEN 21 THEN 'Ginecología'
        WHEN 22 THEN 'Hematología'
        WHEN 23 THEN 'Infectología'
        WHEN 24 THEN 'Medicina Alternativa'
        WHEN 25 THEN 'Medicina Familiar'
        WHEN 26 THEN 'Medicina Física y Rehabilitación'
        WHEN 27 THEN 'Medicina Interna'
        WHEN 28 THEN 'Nefrología'
        WHEN 29 THEN 'Neonatología'
        WHEN 30 THEN 'Neumología'
        WHEN 31 THEN 'Neurología Clínica'
        WHEN 32 THEN 'Neuro Psicología'
        WHEN 33 THEN 'Neurocirugía'
        WHEN 34 THEN 'Neurología'
        WHEN 35 THEN 'Odonto Pediatría'
        WHEN 36 THEN 'Oftalmología'
        WHEN 37 THEN 'Oncología'
        WHEN 38 THEN 'Onco Hematología'
        WHEN 39 THEN 'Ortodoncia'
        WHEN 40 THEN 'Otorrinolaringología'
        WHEN 41 THEN 'Pediatría'
        WHEN 42 THEN 'Periodoncia'
        WHEN 43 THEN 'Proctología'
        WHEN 44 THEN 'Psiquiatría'
        WHEN 45 THEN 'Rehabilitación Oral'
        WHEN 46 THEN 'Reumatología'
        WHEN 47 THEN 'Traumatología'
        WHEN 48 THEN 'Urología'
        WHEN 49 THEN 'Obstetricia'
        WHEN 50 THEN 'Otra'
        ELSE 'NO ESPECIFICADO'
    END) AS espegre,

    -- 6. Variables demográficas y geográficas
    CASE SAFE_CAST(sexo AS INT64)
        WHEN 1 THEN 'Hombre'
        WHEN 2 THEN 'Mujer'
        ELSE NULL
    END AS sexo,

    CASE SAFE_CAST(etnia AS INT64)
        WHEN 1 THEN 'Indígena'
        WHEN 2 THEN 'Afroecuatoriano/a Afrodescendiente'
        WHEN 3 THEN 'Negro/a'
        WHEN 4 THEN 'Mulato/a'
        WHEN 5 THEN 'Montubio/a'
        WHEN 6 THEN 'Mestizo/a'
        WHEN 7 THEN 'Blanco/a'
        WHEN 8 THEN 'Otro/a'
        WHEN 9 THEN 'Ignorado/a'
        ELSE NULL
    END AS etnia,

    CASE SAFE_CAST(prov_res AS INT64)
        WHEN 1 THEN 'Azuay'
        WHEN 2 THEN 'Bolívar'
        WHEN 3 THEN 'Cañar'
        WHEN 4 THEN 'Carchi'
        WHEN 5 THEN 'Cotopaxi'
        WHEN 6 THEN 'Chimborazo'
        WHEN 7 THEN 'El Oro'
        WHEN 8 THEN 'Esmeraldas'
        WHEN 9 THEN 'Guayas'
        WHEN 10 THEN 'Imbabura'
        WHEN 11 THEN 'Loja'
        WHEN 12 THEN 'Los Ríos'
        WHEN 13 THEN 'Manabí'
        WHEN 14 THEN 'Morona Santiago'
        WHEN 15 THEN 'Napo'
        WHEN 16 THEN 'Pastaza'
        WHEN 17 THEN 'Pichincha'
        WHEN 18 THEN 'Tungurahua'
        WHEN 19 THEN 'Zamora Chinchipe'
        WHEN 20 THEN 'Galápagos'
        WHEN 21 THEN 'Sucumbíos'
        WHEN 22 THEN 'Orellana'
        WHEN 23 THEN 'Santo Domingo de los Tsáchilas'
        WHEN 24 THEN 'Santa Elena'
        WHEN 88 THEN 'Exterior'
        ELSE NULL
    END AS prov_res,

    CASE SAFE_CAST(con_egrpa AS INT64)
        WHEN 1 THEN 'Vivo'
        WHEN 2 THEN 'Fallecido menos de 48 horas'
        WHEN 3 THEN 'Fallecido en 48 horas y más'
        ELSE NULL
    END AS con_egrpa,

    CASE SAFE_CAST(area_res AS INT64)
        WHEN 1 THEN 'Urbana'
        WHEN 2 THEN 'Rural'
        ELSE NULL
    END AS area_res,

    cau_cie10,
    sector

FROM `airy-runway-450418-q9.warehouse.egresos_2020`
WHERE
    SAFE_CAST(dia_estad AS INT64) >= 0
    AND fecha_egr IS NOT NULL
    AND cau_cie10 IS NOT NULL
    AND con_egrpa IS NOT NULL
    AND SAFE_CAST(sector AS INT64) IN (1, 2, 3);
