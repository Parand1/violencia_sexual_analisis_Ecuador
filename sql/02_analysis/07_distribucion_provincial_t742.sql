-- ======================================================================================
-- PROYECTO: Rompiendo el silencio estadístico: Violencia sexual contra niñas y adolescentes en Ecuador
-- AUTOR: Pablo Andrés Japón Calva
-- SCRIPT: 07_distribucion_provincial_t742.sql
-- DESCRIPCIÓN: Distribución geográfica de casos de Abuso Sexual (T74.2) por provincia
--               de residencia habitual, estancia hospitalaria promedio y edad media.
-- ======================================================================================

SELECT
    prov_res,
    sexo,
    COUNT(*) AS numero_de_casos,
    ROUND(AVG(dias_estancia), 2) AS estancia_promedio_dias,
    ROUND(AVG(edad_en_dias / 365.25), 2) AS edad_promedio_anios,
    AVG(CASE WHEN con_egrpa LIKE 'Fallecido%' THEN 1.0 ELSE 0.0 END) AS tasa_mortalidad
FROM `airy-runway-450418-q9.warehouse.egresosnor`
WHERE cie10_codigo = 'T742' AND prov_res IS NOT NULL
GROUP BY prov_res, sexo
ORDER BY numero_de_casos DESC, prov_res;
