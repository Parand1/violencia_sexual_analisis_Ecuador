--EXPLORACION DE CIE 10 RELACIONADOS CON VIOLENCIA 2020
SELECT
DISTINCT(cau_cie10)
FROM
warehouse.egresos_2019
WHERE
cau_cie10 LIKE 'T74%' OR -- Síndromes de maltrato
cau_cie10 LIKE 'Y04%' OR -- Agresión con fuerza corporal
cau_cie10 LIKE 'Y07%' OR -- Otros síndromes de maltrato (especifica el perpetrador)
cau_cie10 LIKE 'W50%'    -- Aporreo, golpe, mordedura, patada, etc., infligidos por otra persona
;


--SELECCION DE CASOS POR CIE 10 MAS FRECUENTE 2019
SELECT
cau_cie10,
sexo,
COUNT(*) AS numero_de_casos,
ROUND(AVG(dia_estad), 2) AS estancia_promedio
FROM
warehouse.egresos_2019
WHERE
cau_cie10 LIKE 'T74%' -- Síndromes de maltrato
GROUP BY
cau_cie10,
sexo
ORDER BY numero_de_casos DESC, cau_cie10 ASC;


-- ENFOQUE SOLO EN CIE 10 ABUSO POR PROVINCIA 2019
SELECT
prov_res,
COUNT(*) AS numero_de_casos,
ROUND(AVG(dia_estad), 2) AS estancia_promedio,
FROM
warehouse.egresos_2019
WHERE
cau_cie10 LIKE 'T74%' 
GROUP BY
prov_res
ORDER BY numero_de_casos DESC, prov_res;


--EXPLORACION DE CASOS DE ABUSOS POR MES 2019
SELECT
mes_ingr AS mes_ingreso,
COUNT(*) AS numero_de_casos,
FROM
warehouse.egresos_2019
WHERE
cau_cie10 LIKE 'T74%' -- Casos de Abuso Sexual
GROUP BY
mes_ingreso
ORDER BY
mes_ingreso;

