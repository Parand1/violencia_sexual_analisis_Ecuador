--SELECCION DE CASOS POR CIE 10 MAS FRECUENTE
SELECT
cie10_codigo,
sexo,
COUNT(*) AS numero_de_casos,
ROUND(AVG(edad_en_dias / 365.25),2) AS edad_promedio_anios,
ROUND(AVG(dias_estancia), 2) AS estancia_promedio,
AVG(CASE WHEN con_egrpa LIKE 'Fallecido%' THEN 1.0 ELSE 0.0 END) AS tasa_mortalidad
FROM
warehouse.egresosnor
WHERE
cie10_codigo LIKE 'T74%' -- Síndromes de maltrato
GROUP BY
cie10_codigo,
sexo
ORDER BY numero_de_casos DESC, cie10_codigo ASC;

-- ENFOQUE SOLO EN CIE 10 T742 POR PROVINCIA
SELECT
prov_res,
COUNT(*) AS numero_de_casos,
ROUND(AVG(dias_estancia), 2) AS estancia_promedio,
ROUND(AVG(edad_en_dias / 365.25),2) AS edad_promedio_anios
FROM
warehouse.egresosnor
WHERE
cie10_codigo = 'T742' 
GROUP BY
prov_res
ORDER BY numero_de_casos DESC, prov_res;


-- ENFOQUE SOLO EN CIE 10 T742 POR PROVINCIA Y SEXO
SELECT
prov_res,
sexo,
COUNT(*) AS numero_de_casos,
ROUND(AVG(dias_estancia), 2) AS estancia_promedio,
ROUND(AVG(edad_en_dias / 365.25),2) AS edad_promedio_anios
FROM
warehouse.egresosnor
WHERE
cie10_codigo = 'T742' 
GROUP BY
prov_res, sexo
ORDER BY numero_de_casos DESC, prov_res;

--TOP 3 PROVINCIAS - EXPLORACION DE DATOS

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
warehouse.egresosnor
WHERE
cie10_codigo = 'T742' AND prov_res IN ('Tungurahua', 'Morona Santiago', 'Guayas')
GROUP BY
grupo_edad,
sexo,
prov_res
ORDER BY
prov_res,
sexo,
grupo_edad;

--EXPLORACION DE CASOS DE ABUSOS POR MES
SELECT
EXTRACT(MONTH FROM fecha_ingr_dt) AS mes_ingreso,
COUNT(*) AS numero_de_casos,
ROUND(AVG(edad_en_dias / 365.25), 2) AS edad_promedio_anios,
ROUND(AVG(dias_estancia), 2) AS estancia_promedio
FROM
warehouse.egresosnor
WHERE
cie10_codigo = 'T742' -- Casos de Abuso Sexual
GROUP BY
mes_ingreso
ORDER BY
mes_ingreso;
