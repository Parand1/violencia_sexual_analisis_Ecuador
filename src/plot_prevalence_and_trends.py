"""
======================================================================================
PROYECTO: Rompiendo el silencio estadístico: Violencia sexual contra niñas y adolescentes en Ecuador
AUTOR: Pablo Andrés Japón Calva
SCRIPT: plot_prevalence_and_trends.py
DESCRIPCIÓN: Genera los gráficos de prevalencia de diagnósticos de maltrato (CIE-10 T74)
             y la brecha de género hospitalaria con el efecto escalera 2020-2024.
======================================================================================
"""

import os
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

sns.set_theme(style="whitegrid", font="sans-serif")
plt.rcParams.update({
    "font.size": 11,
    "axes.labelsize": 12,
    "axes.titlesize": 13,
    "figure.titlesize": 14,
    "figure.dpi": 300
})

fig_dir = os.path.join(os.path.dirname(__file__), "..", "presentation", "figures")
os.makedirs(fig_dir, exist_ok=True)

# -------------------------------------------------------------
# 1. GRÁFICO DE PREVALENCIA T74 (78.04% Abuso Sexual)
# -------------------------------------------------------------
diagnosticos = [
    "Abuso sexual\n(T74.2)",
    "Abuso físico\n(T74.1)",
    "Negligencia / Abandono\n(T74.0)",
    "Maltrato no especificado\n(T74.9)",
    "Otros síndromes\n(T74.8)",
    "Abuso psicológico\n(T74.3)"
]
casos = [1613, 206, 105, 94, 26, 23]
total = sum(casos)
pcts = [(c / total) * 100 for c in casos]

fig, ax = plt.subplots(figsize=(10, 5.5))
colores = ["#C53030", "#4A5568", "#718096", "#A0AEC0", "#CBD5E0", "#E2E8F0"]
bars = ax.barh(diagnosticos[::-1], casos[::-1], color=colores[::-1], edgecolor="#2D3748", height=0.6)

for bar, c, p in zip(bars, casos[::-1], pcts[::-1]):
    ax.text(bar.get_width() + 25, bar.get_y() + bar.get_height() / 2,
            f"{c} casos ({p:.1f}%)", va="center", ha="left", fontsize=10, fontweight="bold", color="#1A202C")

ax.set_title("Prevalencia de Egresos Hospitalarios por Síndromes de Maltrato (CIE-10 T74)\nEcuador Acumulado 2019-2024 (INEC - Total: 2,067 ingresos)", pad=15)
ax.set_xlabel("Número de Casos Hospitalarios Acumulados")
ax.set_xlim(0, 1850)
plt.tight_layout()
fig.savefig(os.path.join(fig_dir, "prevalencia_sindromes_maltrato_t74.png"), dpi=300)
plt.close()
print("[OK] Gráfico de prevalencia T74 guardado.")

# -------------------------------------------------------------
# 2. GRÁFICO DE BRECHA DE GÉNERO Y EFECTO ESCALERA
# -------------------------------------------------------------
anios = [2019, 2020, 2021, 2022, 2023, 2024]
mujeres = [230, 143, 166, 233, 332, 363]
hombres = [19, 19, 21, 25, 37, 25]

fig, ax = plt.subplots(figsize=(10, 6))
x = np.arange(len(anios))
width = 0.38

b1 = ax.bar(x - width/2, mujeres, width, label="Mujeres (91.0% de la carga hospitalaria)", color="#9B2C2C", edgecolor="#742A2A")
b2 = ax.bar(x + width/2, hombres, width, label="Hombres (9.0%)", color="#4A5568", edgecolor="#2D3748")

for bar, val in zip(b1, mujeres):
    ax.text(bar.get_x() + bar.get_width()/2, bar.get_height() + 8, f"{val}", ha="center", fontsize=9, fontweight="bold", color="#9B2C2C")

for bar, val in zip(b2, hombres):
    ax.text(bar.get_x() + bar.get_width()/2, bar.get_height() + 8, f"{val}", ha="center", fontsize=9, color="#4A5568")

# Línea de escalera visual en mujeres post-2020
ax.plot(x[1:] - width/2, mujeres[1:], color="#E53E3E", marker="o", lw=2, linestyle=":", label="Efecto Escalera Ascendente (2020-2024)")

ax.set_title("Evolución de Egresos Hospitalarios por Abuso Sexual (T74.2) por Sexo\nEcuador 2019-2024 (INEC)", pad=15)
ax.set_xlabel("Año de Egreso Hospitalario")
ax.set_ylabel("Número de Casos Hospitalarios")
ax.set_xticks(x)
ax.set_xticklabels(anios)
ax.set_ylim(0, 420)
ax.legend(loc="upper left")
plt.tight_layout()
fig.savefig(os.path.join(fig_dir, "brecha_genero_escalera_2019_2024.png"), dpi=300)
plt.close()
print("[OK] Gráfico de brecha de género guardado.")
