--CREACION DE TABLA DE EGRESOS NORMALIZADA 2020
CREATE OR REPLACE TABLE `airy-runway-450418-q9.warehouse.egresosnor_2020`
      PARTITION BY fecha_egr_dt
      CLUSTER BY sector_normalizado, cie10_codigo AS
      SELECT
          -- 1. ENRIQUECIMIENTO: Estandarización de la Edad a días (con decodificación)
          CASE SAFE_CAST(cod_edad AS INT64)
              WHEN 4 THEN SAFE_CAST(edad AS INT64) * 365 -- 4: Años
              WHEN 3 THEN SAFE_CAST(edad AS INT64) * 30  -- 3: Meses
              WHEN 2 THEN SAFE_CAST(edad AS INT64)      -- 2: Días
             ELSE NULL
         END AS edad_en_dias,
    
         -- 2. ENRIQUECIMIENTO: EN ESTE DATA SET YA VIENE EL CIE 10 PURO, SOLO SE CAMBIA NOMBRE A LA COLUMNA
         cau_cie10 AS cie10_codigo,
    
         -- 3. LIMPIEZA: Normalización del Sector (con decodificación)
         CASE SAFE_CAST(sector AS INT64)
             WHEN 1 THEN 'Público' -- 1: Público
             WHEN 2 THEN 'Privado' -- 2: Privado con fines de lucro
             WHEN 3 THEN 'Privado' -- 3: Privado sin fines de lucro
             ELSE 'Otro'
         END AS sector_normalizado,
    
         -- 4. CASTING SEGURO: Conversión de tipos de datos
         SAFE_CAST(dia_estad AS INT64) AS dias_estancia,
         SAFE_CAST(fecha_ingr AS DATE) AS fecha_ingr_dt,
         SAFE_CAST(fecha_egr AS DATE) AS fecha_egr_dt,
    
          -- 5. NORMALIZACION ESPECIALIDAD DE EGRESO DEL PACIENTE (con decodificación)
        UPPER( CASE SAFE_CAST(esp_egrpa AS INT64)
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
            WHEN 51 THEN 'NO ESPECIFICADO'
            WHEN 52 THEN 'NO ESPECIFICADO'
            ELSE NULL
        END) AS espegre,
   
         -- 6. DECODIFICACIÓN DE COLUMNAS RELEVANTES
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
    
         cau_cie10, -- Se mantiene la causa original para referencia
    
         -- Se mantiene el sector original para verificación
         sector
    
     FROM
         `airy-runway-450418-q9.warehouse.egresos_2020`
     WHERE
         -- Filtro de calidad de datos (adaptado a la codificación numérica)
         SAFE_CAST(dia_estad AS INT64) >= 0
         AND fecha_egr IS NOT NULL
        AND cau_cie10 IS NOT NULL
        AND con_egrpa IS NOT NULL
        AND SAFE_CAST(sector AS INT64) IN (1, 2, 3);



--EXPLORACION DE CIE 10 RELACIONADOS CON VIOLENCIA 2020
SELECT
DISTINCT(cie10_codigo)
FROM
warehouse.egresosnor_2020
WHERE
cie10_codigo LIKE 'T74%' OR -- Síndromes de maltrato
cie10_codigo LIKE 'Y04%' OR -- Agresión con fuerza corporal
cie10_codigo LIKE 'Y07%' OR -- Otros síndromes de maltrato (especifica el perpetrador)
cie10_codigo LIKE 'W50%'    -- Aporreo, golpe, mordedura, patada, etc., infligidos por otra persona
;


--SELECCION DE CASOS POR CIE 10 MAS FRECUENTE 2020
SELECT
cie10_codigo,
sexo,
COUNT(*) AS numero_de_casos,
ROUND(AVG(edad_en_dias / 365.25),2) AS edad_promedio_anios,
ROUND(AVG(dias_estancia), 2) AS estancia_promedio,
AVG(CASE WHEN con_egrpa LIKE 'Fallecido%' THEN 1.0 ELSE 0.0 END) AS tasa_mortalidad
FROM
warehouse.egresosnor_2020
WHERE
cie10_codigo LIKE 'T74%' -- Síndromes de maltrato
GROUP BY
cie10_codigo,
sexo
ORDER BY numero_de_casos DESC, cie10_codigo ASC;


-- ENFOQUE SOLO EN CIE 10 T742 POR PROVINCIA 2020
SELECT
prov_res,
COUNT(*) AS numero_de_casos,
ROUND(AVG(dias_estancia), 2) AS estancia_promedio,
ROUND(AVG(edad_en_dias / 365.25),2) AS edad_promedio_anios
FROM
warehouse.egresosnor_2020
WHERE
cie10_codigo = 'T742' 
GROUP BY
prov_res
ORDER BY numero_de_casos DESC, prov_res;


--TOP 3 PROVINCIAS - EXPLORACION DE DATOS 2020

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
warehouse.egresosnor_2020
WHERE
cie10_codigo = 'T742' AND prov_res IN ('Pastaza', 'Morona Santiago', 'Guayas')
GROUP BY
grupo_edad,
sexo,
prov_res
ORDER BY
prov_res,
sexo,
grupo_edad;


--EXPLORACION DE CASOS DE ABUSOS POR MES 2020
SELECT
EXTRACT(MONTH FROM fecha_ingr_dt) AS mes_ingreso,
COUNT(*) AS numero_de_casos,
ROUND(AVG(edad_en_dias / 365.25), 2) AS edad_promedio_anios,
ROUND(AVG(dias_estancia), 2) AS estancia_promedio
FROM
warehouse.egresosnor_2020
WHERE
cie10_codigo = 'T742' -- Casos de Abuso Sexual
GROUP BY
mes_ingreso
ORDER BY
mes_ingreso;



