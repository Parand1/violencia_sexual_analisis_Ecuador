"""
======================================================================================
PROYECTO: Rompiendo el silencio estadistico: Violencia sexual contra ninas y adolescentes en Ecuador
AUTOR: Pablo Andres Japon Calva
SCRIPT: linear_regression_forecast.py
DESCRIPCION: Validacion del modelo inferencial de Regresion Lineal Simple para
             analizar la tendencia de hospitalizaciones por abuso sexual (CIE-10 T74.2)
             en mujeres y generar la proyeccion para el ano 2025.
REPRODUCE: Resultados de SPSS documentados en ANALISIS_INFERENCIAL_VIOLENCIA.md
======================================================================================
"""

import os
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import statsmodels.api as sm

# Configuracion de estilo visual para graficos de publicacion
sns.set_theme(style="whitegrid", font="sans-serif")
plt.rcParams.update({
    "font.size": 11,
    "axes.labelsize": 12,
    "axes.titlesize": 13,
    "xtick.labelsize": 10,
    "ytick.labelsize": 10,
    "figure.titlesize": 14,
    "figure.dpi": 300
})

def run_regression_analysis():
    # -------------------------------------------------------------
    # 1. CARGA DE DATOS (2019-2024)
    # -------------------------------------------------------------
    data = {
        "anio": [2019, 2020, 2021, 2022, 2023, 2024],
        "casos_mujeres": [230, 143, 166, 233, 332, 363]
    }
    df = pd.DataFrame(data)

    print("=" * 70)
    print("ANALISIS INFERENCIAL 1: REGRESION LINEAL DE CASOS T74.2 EN MUJERES")
    print("=" * 70)
    print(df.to_string(index=False))
    print("-" * 70)

    # -------------------------------------------------------------
    # 2. MODELO 1: PERIODO POST-PANDEMIA (2020 - 2024) - MODELO PRINCIPAL
    # -------------------------------------------------------------
    df_post = df[df["anio"] >= 2020].copy()
    X_post = sm.add_constant(df_post["anio"])
    y_post = df_post["casos_mujeres"]

    model_post = sm.OLS(y_post, X_post).fit()

    b0_post = model_post.params["const"]
    b1_post = model_post.params["anio"]
    r2_post = model_post.rsquared
    p_val_post = model_post.pvalues["anio"]

    # Proyeccion para el ano 2025
    pred_2025 = model_post.get_prediction([1, 2025]).summary_frame(alpha=0.05)
    casos_pred_2025 = pred_2025["mean"].values[0]
    ci_lower = pred_2025["mean_ci_lower"].values[0]
    ci_upper = pred_2025["mean_ci_upper"].values[0]
    pi_lower = pred_2025["obs_ci_lower"].values[0]
    pi_upper = pred_2025["obs_ci_upper"].values[0]

    print("\n>>> MODELO 1.1: TENDENCIA POST-PANDEMIA (2020-2024)")
    print(f"Ecuacion: Casos = ({b1_post:.3f} * Ano) + ({b0_post:.3f})")
    print(f"R2 (Coeficiente de determinacion): {r2_post:.4f} ({r2_post*100:.1f}% variabilidad explicada)")
    print(f"Pendiente (Aumento promedio anual): +{b1_post:.2f} casos/ano")
    print(f"P-valor (Significancia de la tendencia): {p_val_post:.4f} (p < 0.01: ALTAMENTE SIGNIFICATIVO)")
    print(f"Prediccion para el ano 2025: {casos_pred_2025:.1f} casos (~{round(casos_pred_2025)} casos)")
    print(f"Intervalo de confianza 95% para la media: [{ci_lower:.1f}, {ci_upper:.1f}]")
    print(f"Intervalo de prediccion 95% para la observacion: [{pi_lower:.1f}, {pi_upper:.1f}]")

    # -------------------------------------------------------------
    # 3. MODELO 2: PERIODO COMPLETO (2019 - 2024) - CONTRASTE METODOLOGICO
    # -------------------------------------------------------------
    X_full = sm.add_constant(df["anio"])
    y_full = df["casos_mujeres"]

    model_full = sm.OLS(y_full, X_full).fit()
    b0_full = model_full.params["const"]
    b1_full = model_full.params["anio"]
    r2_full = model_full.rsquared
    p_val_full = model_full.pvalues["anio"]

    print("\n>>> MODELO 1.2: TENDENCIA GENERAL (2019-2024 - Incluye choque estructural de 2020)")
    print(f"Ecuacion: Casos = ({b1_full:.3f} * Ano) + ({b0_full:.3f})")
    print(f"R2: {r2_full:.4f}")
    print(f"P-valor: {p_val_full:.4f} (p > 0.05: No significativo al 95% debido a la anomalia de 2020)")

    # -------------------------------------------------------------
    # 4. GENERACION DE GRAFICO PROFESIONAL
    # -------------------------------------------------------------
    fig_dir = os.path.join(os.path.dirname(__file__), "..", "figures")
    os.makedirs(fig_dir, exist_ok=True)
    fig_path = os.path.join(fig_dir, "regresion_lineal_proyeccion_2025.png")

    fig, ax = plt.subplots(figsize=(10, 6))

    # Puntos historicos
    ax.scatter(df["anio"], df["casos_mujeres"], color="#1A365D", s=90, zorder=5, label="Casos Observados (2019-2024)")

    # Resaltar la caida anomala del 2020 (confinamiento)
    ax.annotate("Caída por confinamiento\nCOVID-19 (Subregistro)", 
                xy=(2020, 143), xytext=(2019.2, 80),
                arrowprops=dict(facecolor="#D69E2E", arrowstyle="->", lw=1.5),
                fontsize=9, fontweight="bold", color="#744210",
                bbox=dict(boxstyle="round,pad=0.3", fc="#FEFCBF", ec="#D69E2E", lw=1))

    # Linea de regresion 2020-2025
    x_vals = np.linspace(2020, 2025, 100)
    y_vals = b1_post * x_vals + b0_post
    ax.plot(x_vals, y_vals, color="#E53E3E", lw=2.5, linestyle="--", label=f"Tendencia Post-Pandemia (R² = {r2_post:.2f}, p = {p_val_post:.3f})")

    # Proyeccion 2025 punto destacado
    ax.scatter([2025], [casos_pred_2025], color="#C53030", s=140, marker="*", zorder=6, label=f"Proyección 2025: ~{round(casos_pred_2025)} casos")
    ax.annotate(f"Proyección 2025:\n{casos_pred_2025:.1f} casos", 
                xy=(2025, casos_pred_2025), xytext=(2024.1, 445),
                arrowprops=dict(facecolor="#C53030", arrowstyle="->", lw=1.5),
                fontsize=10, fontweight="bold", color="#9B2C2C",
                bbox=dict(boxstyle="round,pad=0.4", fc="#FED7D7", ec="#E53E3E", lw=1.2))

    # Rotulos en los puntos
    for _, row in df.iterrows():
        ax.annotate(f"{int(row['casos_mujeres'])}", (row["anio"], row["casos_mujeres"] + 10),
                    ha="center", fontsize=9, fontweight="bold", color="#2D3748")

    ax.set_title("Proyección de Egresos Hospitalarios por Abuso Sexual en Mujeres (Ecuador 2019-2025)\nModelo de Regresión Lineal Simple (INEC CIE-10 T74.2)", pad=15)
    ax.set_xlabel("Año de Egreso Hospitalario")
    ax.set_ylabel("Número Anual de Casos en Mujeres")
    ax.set_xlim(2018.5, 2025.5)
    ax.set_ylim(50, 480)
    ax.set_xticks(range(2019, 2026))
    ax.legend(loc="upper left", frameon=True)
    plt.tight_layout()

    fig.savefig(fig_path, dpi=300)
    plt.close()
    print(f"\n[OK] Grafico de regresion guardado exitosamente en: {fig_path}")

if __name__ == "__main__":
    run_regression_analysis()
