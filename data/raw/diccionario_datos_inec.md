# Diccionario de Datos: Egresos Hospitalarios (INEC) y BigQuery Warehouse

Este documento detalla el esquema, las definiciones de variables y las transformaciones aplicadas a los datos primarios del **Registro Estadístico de Egresos Hospitalarios** del Instituto Nacional de Estadística y Censos (INEC) de Ecuador, almacenados y procesados en Google BigQuery.

---

## 1. Esquema de Almacenamiento en Google BigQuery

*   **Proyecto:** `airy-runway-450418-q9`
*   **Dataset:** `warehouse`
*   **Tablas de Origen (Raw Data):**
    *   `egresos_2019`, `egresos_2020`, `egresos_2021`, `egresos_2022`, `egresos_2023`, `egresos` (2024)
*   **Tablas Destino (Warehouse Normalizado - ETL):**
    *   `egresosnor_2019`, `egresosnor_2020`, `egresosnor_2021`, `egresosnor_2022`, `egresosnor_2023`, `egresosnor` (2024)
    *   **Estrategia de Optimización:**
        *   `PARTITION BY fecha_egr_dt`: Particionamiento diario por fecha de egreso para reducir costos de escaneo de BigQuery.
        *   `CLUSTER BY sector_normalizado, cie10_codigo`: Agrupamiento para acelerar filtros recurrentes sobre sector de salud y código nosológico.

---

## 2. Variables Principales y Reglas de Transformación ETL

| Variable Original | Variable Normalizada | Tipo de Dato | Descripción y Reglas de Transformación |
| :--- | :--- | :--- | :--- |
| `cod_edad`, `edad` | `edad_en_dias` | `INT64` | Estandarización a días según unidad:<br>- Años (`4` o `Años%`): `edad * 365`<br>- Meses (`3` o `Meses%`): `edad * 30`<br>- Días (`2` o `Días%`): `edad * 1` |
| `cau_cie10` | `cie10_codigo` | `STRING` | Extracción del código alfa-numérico limpio del CIE-10 (ej. `T74.2` o `T742` -> `T742`). En 2021 se mapearon descripciones textuales. |
| `sector` | `sector_normalizado` | `STRING` | Clasificación binaria simplificada:<br>- `1` o `Público` -> `Público`<br>- `2`, `3` o `Privado%` -> `Privado`<br>- Otros valores excluidos por calidad. |
| `dia_estad` | `dias_estancia` | `INT64` | Días de estancia en cama hospitalaria (`dia_estad >= 0`). |
| `fecha_ingr` | `fecha_ingr_dt` | `DATE` | Fecha de ingreso del paciente (`YYYY-MM-DD`). |
| `fecha_egr` | `fecha_egr_dt` | `DATE` | Fecha de alta hospitalaria (`YYYY-MM-DD`). |
| `esp_egrpa` | `espegre` | `STRING` | Especialidad médica de egreso. En 2019/2020 se decodificó desde valores enteros (1-52); en 2021-2024 se removieron acentos y diacríticos con NFD regex. |
| `sexo` | `sexo` | `STRING` | Sexo biológico del paciente (`Hombre` / `Mujer`). |
| `etnia` | `etnia` | `STRING` | Autoidentificación étnica (`Mestizo/a`, `Indígena`, `Afroecuatoriano/a`, `Montubio/a`, `Blanco/a`, etc.). |
| `prov_res` | `prov_res` | `STRING` | Provincia de residencia habitual (24 provincias de Ecuador + Exterior). |
| `area_res` | `area_res` | `STRING` | Área geográfica de residencia (`Urbana` / `Rural`). |
| `con_egrpa` | `con_egrpa` | `STRING` | Condición al egreso hospitalario (`Vivo` / `Fallecido`). |

---

## 3. Códigos CIE-10 Analizados (Categoría T74)

*   **T74:** Síndromes del maltrato
    *   **`T74.0`:** Negligencia o abandono
    *   **`T74.1`:** Abuso físico
    *   **`T74.2`:** Abuso sexual *(Foco principal de la investigación)*
    *   **`T74.3`:** Abuso psicológico
    *   **`T74.8`:** Otros síndromes de maltrato
    *   **`T74.9`:** Síndrome del maltrato, no especificado

---

## 4. Diccionario de Códigos Numéricos (INEC 2019 - 2020)

### 4.1. Sexo
*   `1`: Hombre
*   `2`: Mujer

### 4.2. Área de Residencia
*   `1`: Urbana
*   `2`: Rural

### 4.3. Condición al Egreso
*   `1`: Vivo
*   `2`: Fallecido menos de 48 horas
*   `3`: Fallecido en 48 horas y más

### 4.4. Autoidentificación Étnica
*   `1`: Indígena
*   `2`: Afroecuatoriano/a Afrodescendiente
*   `3`: Negro/a
*   `4`: Mulato/a
*   `5`: Montubio/a
*   `6`: Mestizo/a
*   `7`: Blanco/a
*   `8`: Otro/a
*   `9`: Ignorado/a
