"""
======================================================================================
PROYECTO: Rompiendo el silencio estadistico: Violencia sexual contra ninas y adolescentes en Ecuador
AUTOR: Pablo Andres Japon Calva
SCRIPT: inferential_tests.py
DESCRIPCION: Validacion de las pruebas de hipotesis no parametricas (Chi-cuadrado):
             1. Prueba Chi-cuadrado de Bondad de Ajuste: Uniformidad etaria (T74.2 en mujeres).
             2. Prueba Chi-cuadrado de Independencia: Distribucion geografica Rural vs. Urbana (2019-2024).
REPRODUCE: Resultados de SPSS documentados en ANALISIS_INFERENCIAL_VIOLENCIA.md
======================================================================================
"""

import os
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
from scipy import stats

sns.set_theme(style="whitegrid", font="sans-serif")
plt.rcParams.update({
    "font.size": 11,
    "axes.labelsize": 12,
    "axes.titlesize": 13,
    "figure.titlesize": 14,
    "figure.dpi": 300
})

def run_age_goodness_of_fit():
    print("=" * 70)
    print("HIPOTESIS 2: PRUEBA CHI-CUADRADO DE BONDAD DE AJUSTE (GRUPOS DE EDAD)")
    print("=" * 70)
    print("Pregunta: Se distribuyen los casos de abuso sexual (T74.2) uniformemente entre edades?")
    print("H0: Los casos se distribuyen uniformemente entre los 5 grupos de edad.")
    print("H1: Existen diferencias significativas en la concentracion por edad.")

    grupos = ["0-4 anos", "5-9 anos", "10-14 anos", "15-19 anos", "20+ anos"]
    observados = np.array([85, 179, 615, 330, 258])
    total = observados.sum()
    esperados = np.full(len(observados), total / len(observados)) # 293.4

    # Chi-cuadrado
    chi2_stat, p_val = stats.chisquare(f_obs=observados, f_exp=esperados)
    dof = len(observados) - 1

    # Residuos estandarizados: (O - E) / sqrt(E)
    std_residuals = (observados - esperados) / np.sqrt(esperados)

    df_res = pd.DataFrame({
        "Grupo de Edad": grupos,
        "Casos Observados (O)": observados,
        "Casos Esperados (E)": esperados,
        "Porcentaje (%)": np.round(observados * 100 / total, 2),
        "Residuo Estandarizado": np.round(std_residuals, 2)
    })
    print("\n" + df_res.to_string(index=False))
    print(f"\nResultados Chi-cuadrado (SPSS/SciPy):")
    print(f"Chi-cuadrado (Chi2): {chi2_stat:.3f}")
    print(f"Grados de libertad (gl): {dof}")
    print(f"P-valor asintotico: {p_val:.4e} (p < 0.001)")
    print("CONCLUSION: Se rechaza H0 contundentemente. El grupo de 10 a 14 anos presenta")
    print("un residuo de +18.78 (desviacion extrema sobre el valor esperado), confirmando")
    print("que las ninas y adolescentes de 10 a 14 anos concentran el foco critico de vulnerabilidad.")

    # Grafico de distribucion etaria
    fig_dir = os.path.join(os.path.dirname(__file__), "..", "figures")
    os.makedirs(fig_dir, exist_ok=True)
    fig_path = os.path.join(fig_dir, "distribucion_etaria_mujeres_chi2.png")

    fig, ax = plt.subplots(figsize=(9, 5.5))
    colores = ["#CBD5E0", "#A0AEC0", "#E53E3E", "#F56565", "#718096"]
    bars = ax.bar(["0-4 años", "5-9 años", "10-14 años", "15-19 años", "20+ años"], observados, color=colores, width=0.6, edgecolor="#4A5568", lw=1)

    # Linea de valor esperado bajo H0
    ax.axhline(esperados[0], color="#2B6CB0", linestyle="--", lw=2, label=f"Frecuencia Esperada uniforme (E = {esperados[0]:.1f})")

    for bar, val in zip(bars, observados):
        pct = (val / total) * 100
        ax.text(bar.get_x() + bar.get_width() / 2, bar.get_height() + 12,
                f"{val}\n({pct:.1f}%)", ha="center", va="bottom", fontsize=10, fontweight="bold")

    ax.set_title("Distribución de Casos de Abuso Sexual (T74.2) en Mujeres por Grupo de Edad (2019-2024)\nPrueba de Bondad de Ajuste χ² = 553.98, gl = 4, p < 0.001", pad=15)
    ax.set_xlabel("Grupo de Edad")
    ax.set_ylabel("Total de Casos Hospitalarios Acumulados")
    ax.set_ylim(0, 720)
    ax.legend(loc="upper left")
    plt.tight_layout()
    fig.savefig(fig_path, dpi=300)
    plt.close()
    print(f"[OK] Grafico de grupos de edad guardado en: {fig_path}")

def run_rural_urban_independence():
    print("\n" + "=" * 70)
    print("HIPOTESIS 3: PRUEBA CHI-CUADRADO DE INDEPENDENCIA (RURAL VS. URBANO)")
    print("=" * 70)
    print("Pregunta: Varia la proporcion rural/urbana significativamente entre 2019 y 2024?")
    print("H0: El area de residencia y el ano son independientes (proporcion estable en el tiempo).")
    print("H1: Existen diferencias temporales significativas en la procedencia territorial.")

    anios = [2019, 2020, 2021, 2022, 2023, 2024]
    contingencia = np.array([
        [74, 156],
        [48, 95],
        [59, 107],
        [83, 150],
        [106, 226],
        [125, 238]
    ])

    chi2_stat, p_val, dof, esperados = stats.chi2_contingency(contingencia)

    df_tab = pd.DataFrame(contingencia, index=anios, columns=["Rural", "Urbano"])
    df_tab["Total"] = df_tab["Rural"] + df_tab["Urbano"]
    df_tab["% Rural"] = np.round(df_tab["Rural"] * 100 / df_tab["Total"], 1)
    df_tab["% Urbano"] = np.round(df_tab["Urbano"] * 100 / df_tab["Total"], 1)

    print("\n" + df_tab.to_string())
    print(f"\nResultados Chi-cuadrado de Independencia (SPSS/SciPy):")
    print(f"Chi-cuadrado de Pearson (Chi2): {chi2_stat:.3f}")
    print(f"Grados de libertad (gl): {dof}")
    print(f"Significacion asintotica (p-valor): {p_val:.3f} (p = 0.921 > 0.05: NO SIGNIFICATIVO)")
    print("CONCLUSION: NO se rechaza H0. La proporcion entre ambito rural (~33.7%) y urbano (~66.3%)")
    print("se mantiene notablemente constante a traves de todos los anos analizados, reflejando")
    print("la estructura demografica natural de la poblacion ecuatoriana.")

    # Grafico de barras apiladas porcentuales
    fig_dir = os.path.join(os.path.dirname(__file__), "..", "figures")
    fig_path = os.path.join(fig_dir, "estabilidad_rural_urbana_chi2.png")

    fig, ax = plt.subplots(figsize=(9, 5.5))
    x = np.arange(len(anios))
    width = 0.55

    p1 = ax.bar(x, df_tab["% Urbano"], width, label="Área Urbana (~66.3%)", color="#2B6CB0", edgecolor="#1A365D")
    p2 = ax.bar(x, df_tab["% Rural"], width, bottom=df_tab["% Urbano"], label="Área Rural (~33.7%)", color="#D69E2E", edgecolor="#744210")

    # Etiquetas dentro de las barras
    for i, row in enumerate(df_tab.itertuples()):
        ax.text(i, row._5 / 2, f"{row._5:.1f}%\n(n={row.Urbano})", ha="center", va="center", color="white", fontweight="bold", fontsize=9)
        ax.text(i, row._5 + row._4 / 2, f"{row._4:.1f}%\n(n={row.Rural})", ha="center", va="center", color="white", fontweight="bold", fontsize=9)

    ax.set_title("Estabilidad Temporal de la Distribución Territorial (2019-2024)\nPrueba de Independencia χ² = 1.431, gl = 5, p = 0.921 (No Significativo)", pad=15)
    ax.set_xlabel("Año de Egreso Hospitalario")
    ax.set_ylabel("Proporción Porcentual (%)")
    ax.set_xticks(x)
    ax.set_xticklabels(anios)
    ax.set_ylim(0, 105)
    ax.legend(loc="lower right")
    plt.tight_layout()
    fig.savefig(fig_path, dpi=300)
    plt.close()
    print(f"[OK] Grafico rural/urbano guardado en: {fig_path}")

if __name__ == "__main__":
    run_age_goodness_of_fit()
    run_rural_urban_independence()
