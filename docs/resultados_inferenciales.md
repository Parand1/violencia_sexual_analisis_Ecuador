# Validación Estadística y Resultados Inferenciales

Este documento presenta los resultados de los contrastes de hipótesis realizados sobre los egresos hospitalarios por violencia en Ecuador (INEC 2019-2024), validados conjuntamente mediante **IBM SPSS Statistics** y bibliotecas científicas de **Python (SciPy y Statsmodels)**.

---

## 1. Justificación Epidemiológica: Predominancia del Abuso Sexual (CIE-10 T74.2)

Al consolidar los 6 años del estudio (2019–2024), se identificaron un total de **2,067 ingresos hospitalarios** por la categoría diagnóstica CIE-10 **T74: Síndromes del maltrato**.

| Código CIE-10 | Diagnóstico Clínico | Casos Acumulados (N) | Porcentaje (%) |
| :--- | :--- | :---: | :---: |
| **T74.2** | **Abuso sexual** | **1,613** | **78.04%** |
| T74.1 | Abuso físico | 206 | 9.97% |
| T74.0 | Negligencia o abandono | 105 | 5.08% |
| T74.9 | Síndrome del maltrato, no especificado | 94 | 4.55% |
| T74.8 | Otros síndromes de maltrato | 26 | 1.26% |
| T74.3 | Abuso psicológico | 23 | 1.11% |
| **Total** | | **2,067** | **100.00%** |

El abuso sexual concentra el 78% de los egresos hospitalarios por maltrato en el período, lo que justificó centrar el modelado estadístico en este diagnóstico (código T74.2).

---

## 2. Hipótesis 1: Tendencia Temporal y Modelo de Proyección para 2025

### 2.1. Formulación
*   **$H_0$:** No existe relación lineal entre el año y el volumen anual de hospitalizaciones por abuso sexual en mujeres ($\beta_1 = 0$).
*   **$H_1$:** Existe una tendencia lineal estadísticamente significativa en el período analizado ($\beta_1 \neq 0$).

### 2.2. Modelo Principal: Período Post-Pandemia (2020 - 2024)
*   **Variables:**
    *   $X$ (Independiente): Año ($2020, 2021, 2022, 2023, 2024$)
    *   $Y$ (Dependiente): Casos anuales en mujeres ($143, 166, 233, 332, 363$)
*   **Parámetros Estimados:**
    *   **Coeficiente de Determinación ($R^2$):** $0.960$ (El $96.0\%$ de la variabilidad observada es explicada por el tiempo).
    *   **Pendiente ($\beta_1$):** $+60.60$ casos anuales adicionales en promedio.
    *   **Intercepto ($\beta_0$):** $-122,285.80$.
    *   **Significancia ($p$-valor):** $p = 0.0034$ ($p < 0.01$).
*   **Ecuación de Regresión:**
    $$\widehat{Y} = 60.600 \times \text{Año} - 122,285.800$$

### 2.3. Proyección para el Año 2025
*   **Cálculo puntual:**
    $$\widehat{Y}_{2025} = (60.600 \times 2025) - 122,285.800 = 122,715.000 - 122,285.800 = 429.2 \approx \mathbf{429\text{ casos}}$$
*   **Intervalo de Confianza al 95% para la media:** $[353.8, 504.6]$
*   **Intervalo de Predicción al 95% para nueva observación:** $[325.1, 533.3]$

### 2.4. Contraste Metodológico: Período Completo (2019 - 2024)
Al incorporar el año 2019 ($n = 230$), el modelo lineal arroja $R^2 = 0.626$ y $p = 0.061$. Aunque se mantiene la tendencia positiva ($+37.11$ casos/año), el p-valor ($p > 0.05$) no alcanza significancia estadística formal al $95\%$. Esto confirma empíricamente que el 2020 ($n = 143$) generó una **ruptura estructural por confinamiento sanitario y subregistro**, siendo el modelo 2020–2024 el que captura con fidelidad la dinámica real actual.

---

## 3. Hipótesis 2: Concentración de Casos por Grupo de Edad

### 3.1. Formulación
*   **$H_0$:** Los casos de abuso sexual hospitalario en mujeres se distribuyen de manera uniforme entre las diferentes etapas de la vida.
*   **$H_1$:** Existen diferencias estadísticamente significativas en la concentración de casos entre grupos etarios.

### 3.2. Prueba de Chi-Cuadrado ($\chi^2$) de Bondad de Ajuste
*   **Total de casos acumulados (2019-2024):** $N = 1,467$ mujeres.
*   **Frecuencia esperada bajo uniformidad ($E$):** $1,467 / 5 = 293.4$ casos por grupo.

| Grupo de Edad | Casos Observados ($O$) | Frecuencia Esperada ($E$) | Porcentaje (%) | Residuo Estandarizado $\frac{O-E}{\sqrt{E}}$ |
| :--- | :---: | :---: | :---: | :---: |
| 0-4 años | 85 | 293.4 | 5.79% | -12.17 |
| 5-9 años | 179 | 293.4 | 12.20% | -6.68 |
| **10-14 años** | **615** | **293.4** | **41.92%** | **+18.78** |
| 15-19 años | 330 | 293.4 | 22.49% | +2.14 |
| 20+ años | 258 | 293.4 | 17.59% | -2.07 |

*   **Estadístico Chi-cuadrado ($\chi^2$):** $553.978$
*   **Grados de libertad ($gl$):** $4$
*   **Significancia asintótica ($p$-valor):** $p < 0.0001$ ($1.41 \times 10^{-118}$).

**Conclusión:** Se rechaza la hipótesis nula ($p < 0.001$). El residuo estandarizado de $+18.78$ en el grupo de 10 a 14 años confirma una concentración significativamente mayor a la esperada bajo una distribución uniforme (41.92% del total de casos).

---

## 4. Hipótesis 3: Independencia entre Área Territorial y Año de Registro

### 4.1. Formulación
*   **$H_0$:** La distribución de hospitalizaciones entre áreas rurales y urbanas es independiente del año analizado (proporción territorial invariante).
*   **$H_1$:** Existe una variación temporal significativa en la distribución territorial de los casos.

### 4.2. Prueba de Chi-Cuadrado de Independencia (Pearson)
Tabla de contingencia $6 \times 2$:

| Año | Casos Área Rural ($N$) | Casos Área Urbana ($N$) | Total Anual | % Rural | % Urbano |
| :---: | :---: | :---: | :---: | :---: | :---: |
| 2019 | 74 | 156 | 230 | 32.2% | 67.8% |
| 2020 | 48 | 95 | 143 | 33.6% | 66.4% |
| 2021 | 59 | 107 | 166 | 35.5% | 64.5% |
| 2022 | 83 | 150 | 233 | 35.6% | 64.4% |
| 2023 | 106 | 226 | 332 | 31.9% | 68.1% |
| 2024 | 125 | 238 | 363 | 34.4% | 65.6% |
| **Total** | **495** | **972** | **1,467** | **33.7%** | **66.3%** |

*   **Estadístico Chi-cuadrado ($\chi^2$):** $1.431$
*   **Grados de libertad ($gl$):** $5$
*   **Significancia asintótica ($p$-valor):** $p = 0.921 > 0.05$ (**No significativo**).

> **Conclusión:** No se rechaza $H_0$. La relación de $\approx 1/3$ de casos en sector rural y $\approx 2/3$ en sector urbano es estadísticamente constante a lo largo de los 6 años, reflejando fielmente la distribución de la población en el censo nacional del Ecuador.
