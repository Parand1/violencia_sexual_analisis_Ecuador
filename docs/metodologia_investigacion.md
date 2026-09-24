# Metodología de Investigación y Arquitectura de Datos

## 1. Contexto Académico
*   **Investigador Principal:** Pablo Andrés Japón Calva
*   **Evento:** I Congreso Intersectorial sobre Violencia de Género y Mujeres en Situación de Vulnerabilidad
*   **Fecha de Presentación:** 05 de diciembre de 2025
*   **Título:** *Rompiendo el silencio estadístico: Descifrando el patrón de violencia sexual contra niñas y adolescentes en Ecuador a través del análisis de datos.*

---

## 2. Origen y Dimensiones del Corpus de Datos
La fuente primaria de información corresponde a las bases de datos abiertas del **Registro Estadístico de Egresos Hospitalarios** publicadas anualmente por el **Instituto Nacional de Estadística y Censos (INEC)** de la República del Ecuador.

*   **Período Temporal:** 2019 a 2024 (6 años completos de registros hospitalarios).
*   **Volumen Total:** Más de **6 millones de transacciones hospitalarias** consolidadas.
*   **Unidad de Análisis:** Paciente con ingreso a internación hospitalaria cuya causa de egreso o diagnóstico principal se encuentra tipificado bajo el estándar internacional de la Clasificación Estadística Internacional de Enfermedades y Problemas Relacionados con la Salud, Décima Revisión (**CIE-10**).
*   **Criterio Clínico de Selección:** A diferencia de las estadísticas policiales o judiciales (denuncias), el egreso hospitalario captura casos donde la violencia produjo un **impacto físico o psicológico de gravedad médica**, requiriendo hospitalización para estabilización clínica, cirugía reconstructiva, manejo de politraumatismos o profilaxis post-exposición de emergencia.

---

## 3. Pipeline de Ingeniería de Datos (Google BigQuery)

Dada la magnitud de las bases de datos originales del INEC, el procesamiento analítico se estructuró en la nube con **Google BigQuery (SQL)**:

1.  **Ingesta Raw:** Tablas `airy-runway-450418-q9.warehouse.egresos_YYYY`.
2.  **Tratamiento de Inconsistencias Interanuales:**
    *   **2019-2020:** Los datos crudos contenían codificación numérica pura (ej. `cod_edad = 4` para años, `sector = 1` para público, catálogos numéricos de 52 especialidades médicas). Se construyeron capas DDL de decodificación masiva con sentencias `CASE WHEN`.
    *   **2021:** El INEC modificó la nomenclatura de diagnósticos, registrando cadenas de texto libre en lugar de códigos directos. Se implementó una lógica de mapeo regex/string matching para restituir los códigos CIE-10.
    *   **2022-2024:** Se aplicó extracción de cadenas alfa-numéricas puras mediante funciones de división de texto y descarte de acentos (NFD normalize).
3.  **Normalización de Unidades:** La edad se estandarizó a una escala unívoca (`edad_en_dias`):
    $$\text{edad\_en\_dias} = \begin{cases} \text{edad} \times 365 & \text{si unidad = Años} \\ \text{edad} \times 30 & \text{si unidad = Meses} \\ \text{edad} \times 1 & \text{si unidad = Días} \end{cases}$$
4.  **Optimización de Almacenamiento:** Las tablas resultantes (`egresosnor_YYYY`) se particionaron por día de egreso (`fecha_egr_dt`) y se agruparon por clusters (`CLUSTER BY sector_normalizado, cie10_codigo`), optimizando el rendimiento de cómputo y minimizando costos de escaneo.

---

## 4. Marco Metodológico y Formulación de Hipótesis

Para trascender el nivel meramente descriptivo, se definieron tres hipótesis de investigación validadas mediante contraste de hipótesis con software estadístico (SPSS y Python / SciPy / Statsmodels):

### Hipótesis 1: Aumento temporal sostenido y proyección al 2025
*   **Pregunta:** ¿Constituye el incremento anual de casos hospitalarios por abuso sexual en mujeres una tendencia lineal estadísticamente significativa en el período post-pandemia?
*   **Método:** Modelo de Regresión Lineal Simple por Mínimos Cuadrados Ordinarios (MCO / OLS).
*   **Justificación de Períodos:** Se contrastó el modelo general (2019-2024) frente al modelo post-pandemia (2020-2024). El año 2020 representó una quiebra estructural debido al confinamiento por COVID-19, produciendo un subregistro en admisiones médicas no relacionadas con la emergencia sanitaria.

### Hipótesis 2: Concentración de vulnerabilidad por ciclo de vida
*   **Pregunta:** ¿Se distribuyen uniformemente las víctimas de abuso sexual hospitalizadas a lo largo de las distintas etapas de la vida?
*   **Método:** Prueba de Chi-Cuadrado ($\chi^2$) de Bondad de Ajuste con cálculo de residuos estandarizados sobre cinco grupos quinquenales: 0-4 años, 5-9 años, 10-14 años, 15-19 años y 20+ años.

### Hipótesis 3: Estabilidad territorial de la carga de violencia
*   **Pregunta:** ¿Depende la proporción de casos hospitalizados procedentes de zonas rurales frente a urbanas del año de registro?
*   **Método:** Prueba de Chi-Cuadrado ($\chi^2$) de Independencia de Pearson en tablas de contingencia $6 \times 2$.

---

## 5. Consideraciones Éticas y Privacidad
El presente estudio opera exclusivamente con datos secundarios anonimizados conforme a la Ley de Estadística del Ecuador, sin contener nombres, cédulas ni identificadores individuales de pacientes.
