# Guion de Presentación: Conferencia Magistral

*   **Evento:** I Congreso Intersectorial sobre Violencia de Género y Mujeres en Situación de Vulnerabilidad
*   **Fecha:** 05 de diciembre de 2025
*   **Conferencista:** Pablo Andrés Japón Calva (Cierre oficial del evento)
*   **Ponencia:** *Rompiendo el silencio estadístico: Descifrando el patrón de violencia sexual contra niñas y adolescentes en Ecuador a través del análisis de datos.*

---

## Slide 1: Portada / Introducción Metodológica
> *"Muy buenas tardes con todas y todos. Es un verdadero privilegio tener la responsabilidad de cerrar este Primer Congreso Intersectorial. Sé que han sido dos días intensos de mucho aprendizaje y reflexión, por lo que agradezco profundamente su presencia y compromiso al acompañarnos hasta este momento final.*
> 
> *Muchas gracias, Dra. Angélica, por esa excelente introducción que nos sitúa en la realidad humana y social del problema.*
> 
> *Para complementar lo expuesto, mi intervención dará un giro hacia los **Métodos**. Quiero invitarles a mirar esta problemática desde una lente distinta: la de los datos. En los próximos minutos, no solo hablaremos de herramientas técnicas, sino de cómo la ciencia de datos se convierte en un instrumento crucial para transformar registros hospitalarios en evidencia sólida, visibilizando patrones que son urgentes para la toma de decisiones."*

---

## Slide 2: Desvelando la Violencia (Ciencia y Análisis de Datos)
> *"Para dimensionar la violencia, primero debemos clarificar cómo la estudiamos. En este trabajo he fusionado dos roles esenciales. Como **Analista de Datos**, mi tarea es descriptiva: contarles 'qué pasó'. Pero como **Científico de Datos**, voy un paso más allá: uso modelos para entender el 'por qué' y proyectar tendencias futuras.*
> 
> *¿Por qué es indispensable esta distinción técnica? Porque no estamos analizando una pequeña muestra manual. Hemos unificado las bases de datos del INEC desde 2019 hasta 2024, procesando un volumen masivo de **más de 6 millones de registros hospitalarios**.*
> 
> *Manejar este 'monstruo' de información requiere herramientas poderosas. Usamos **SQL en Google BigQuery** para minar esta montaña de datos que Excel no soportaría, y aplicamos **SPSS y Python** para el rigor estadístico. No nos basamos en intuiciones; usamos la matemática para asegurar que lo que verán a continuación no es casualidad, sino evidencia científica."*

---

## Slide 3: Portada Sección Resultados Descriptivos (CIE-10 T74)
> *"Pasemos ahora a los hallazgos descriptivos. Para rastrear la violencia en estos millones de datos, utilizamos el estándar internacional de salud, el **CIE-10**. Específicamente, filtramos todos los diagnósticos bajo el código **T74**, que corresponde a 'Síndromes del maltrato'. Esto es lo que la base de datos oficial nos revela cuando buscamos la huella clínica de la violencia."*

---

## Slide 4: Hallazgo Principal - Predominancia del Abuso Sexual (78.04%)
> *"El primer resultado es contundente. Al analizar los más de 2,000 ingresos específicos por síndromes de maltrato acumulados en estos 6 años, el gráfico habla por sí solo. La barra que ven dominando la pantalla corresponde al código **T74.2: Abuso Sexual**, representando el **78.04%** de todos los casos.*
> 
> *Pero quiero hacer una pausa vital aquí. **¿Por qué estos casos están en un hospital?***
> *No estamos hablando de denuncias en comisaría. Estamos hablando de ingresos hospitalarios. Para que una víctima llegue a esta estadística, ha existido una necesidad clínica severa: traumas físicos, desgarros, necesidad de cirugía, profilaxis urgente de infecciones o estabilización de crisis agudas.*
> 
> *Entender esto hace que ese 78% sea mucho más pesado. La evidencia nos obliga a poner el foco aquí. Por eso, de ahora en adelante, todo el análisis se centrará exclusivamente en el abuso sexual."*

---

## Slide 5: La Brecha de Género Hospitalaria
> *"Al profundizar en ese abuso sexual, nos encontramos con una realidad visualmente impactante. Este gráfico desglosa los casos por sexo y año.*
> 
> *Primero, la brecha es estructural: frente a 146 hombres, tenemos **1,467 mujeres**, quienes soportan más del 90% de la carga hospitalaria. Pero quiero que dirijan su atención a la forma que toman las barras femeninas a partir del año 2020.*
> 
> *Lo que ven no es aleatorio; se dibuja una **perfecta escalera ascendente**. Año tras año, sin excepción, los ingresos han ido escalando (143 -> 166 -> 233 -> 332 -> 363). Esta progresión visual, sostenida y alarmante, es el primer indicio de una tendencia crítica post-pandemia que validaremos científicamente en un momento."*

---

## Slide 6: Evolución Geográfica - Focos de Alerta
> *"Cuando desagregamos esa 'escalera' por territorio, identificamos tres focos críticos que han liderado sistemáticamente las estadísticas desde 2019.*
> 
> ***Morona Santiago** muestra un comportamiento endémico; siempre presente en los primeros lugares. **Guayas**, por su parte, mantiene una tendencia relativamente estable proporcional a su gran población.*
> 
> *Pero la verdadera alerta salta a la vista en **Tungurahua**. Observen el quiebre dramático en 2022. La curva deja de ser lineal y se dispara verticalmente. Pasamos de cifras moderadas a liderar la estadística nacional en 2023. Esta anomalía estadística en el centro del país no es ruido en los datos; es un grito de alerta que nos obliga a preguntarnos: ¿Ha aumentado la violencia o finalmente hemos mejorado nuestra capacidad de detectarla en esa provincia?"*

---

## Slide 7: Perfil Demográfico (Reflejo Nacional)
> *"A menudo se tiende a pensar que la violencia afecta más a ciertos grupos étnicos o áreas rurales. Sin embargo, los datos desmienten ese sesgo y nos muestran un **'espejo demográfico'**.*
> 
> *Las barras aquí reflejan casi exactamente la estructura poblacional del Ecuador: un 81% de casos en población mestiza y un 16% en población indígena. Igualmente, la relación Urbano/Rural (66% vs 34%) es consistente con dónde vive la gente.*
> 
> *¿Qué significa esto? Que la violencia sexual no es exclusiva de un nicho; **es transversal**. Ocurre donde está la población, sin distinción significativa de etnia o zona geográfica. Es un problema nacional, no focalizado."*

---

## Slide 8: Portada Sección Resultados Inferenciales
> *"Hasta aquí hemos descrito lo que ha ocurrido. Pero la ciencia de datos no se conforma con mirar al pasado. Ahora entramos a la fase de **Resultados Inferenciales**. Aquí es donde aplicamos pruebas estadísticas para validar si lo que vimos es azar o si existen patrones matemáticos que nos permitan predecir el futuro inmediato."*

---

## Slide 9: Hipótesis 1 - Tendencia Post-Pandemia (Regresión Lineal)
> *"Pasamos a la Hipótesis 1. Vimos esa 'escalera' visual, pero ¿es real matemáticamente? Para responderlo, recurrí a la **Regresión Lineal Simple**.*
> 
> *Aplicamos este modelo al período post-pandemia (2020-2024) y los números son contundentes:*
> *1. **R cuadrado (0.960):** El 96% del aumento se explica linealmente por el paso del tiempo.*
> *2. **Valor P (0.003):** Con un 95% de confianza estándar, un p-valor de 0.003 nos otorga certeza estadística absoluta de que esto **no es azar**.*
> *3. **Coeficiente B (+60.6):** Cada año se suman en promedio **60 nuevas víctimas mujeres** a la cifra del año anterior."*

---

## Slide 10: Proyección 2025 - La Advertencia Matemática
> *"¿Y qué nos dice esa ventana al futuro para el cierre de 2025?*
> 
> *Si aplicamos la ecuación que acabamos de validar, la proyección matemática arroja **429 casos**.*
> *Empezamos el análisis en 2020 con 143 casos. En solo cinco años, la cifra estaría a punto de triplicarse.*
> 
> *Quiero ser muy claro: este número, 429, no es un destino escrito en piedra; es una **advertencia estadística**. Es la cifra a la que llegaremos si esa inercia de 60 casos por año persiste y si nuestras estrategias de prevención no intervienen para quebrar la curva."*

---

## Slide 11: Hipótesis 2 - Grupos Etarios (Chi-Cuadrado)
> *"Para nuestra segunda hipótesis, analizamos si el riesgo es igual para todas las edades mediante la prueba **Chi-Cuadrado de Bondad de Ajuste**.*
> 
> *Obtenemos un **Chi-cuadrado de 553.98** y un **Valor P asintótico de 0.000** ($p < 0.001$).*
> 
> *Rechazamos categóricamente la hipótesis nula de uniformidad. Los datos demuestran que el grupo de **10 a 14 años** es la **Zona de Máximo Riesgo**, con 615 casos (el 41.92% del total) y un residuo estandarizado de **+18.78**. No es azar, es un patrón sistemático de vulnerabilidad en la niñez y pubertad temprana."*

---

## Slide 12: Hipótesis 3 - Estabilidad Geográfica (Chi-Cuadrado Independencia)
> *"Finalmente, averiguamos si la distribución territorial está mutando. Aplicamos Chi-Cuadrado de Independencia sobre las tablas de contingencia rural/urbana año a año.*
> 
> *El resultado es contundente: $\chi^2 = 1.431$, con un **p-valor de 0.921** ($p > 0.05$).*
> *No hay cambios significativos: la relación 66.3% urbana y 33.7% rural es estadísticamente constante a lo largo de los seis años. La violencia no se mueve de un sector a otro; está enraizada en todo el territorio."*

---

## Slide 13: Portada Conclusiones y Recomendaciones
> *"La evidencia nos deja cuatro certezas ineludibles:*
> *1. **Tendencia Creciente Sostenida:** Ritmo de +60 hospitalizaciones de mujeres por año ($R^2 = 0.960$).*
> *2. **Zona Crítica:** Niñas de 10 a 14 años en el epicentro de la emergencia.*
> *3. **Distribución Estructural:** Proporciones demográficas y territoriales transversales ($p = 0.921$).*
> *4. **Focos Regionales:** Explosión atípica en Tungurahua a partir de 2022.*
> 
> *Y cuatro recomendaciones urgentes:*
> *1. Prevención escolar focalizada antes de los 10 años.*
> *2. Auditoría e intervención territorial prioritaria en Tungurahua.*
> *3. Fortalecimiento de la calidad del dato clínico en el sistema hospitalario.*
> *4. Incorporación de **talento especializado en Ciencia de Datos** en el sector público para transformar datos en vidas salvadas."*

---

## Slide 14: Cierre
> *"Para concluir: Hemos hablado hoy de curvas, de valores P y de regresiones. Pero no olvidemos nunca que **detrás de cada número, hay un nombre, una historia y una familia** esperando respuestas.*
> 
> *La ciencia de datos nos da el mapa; ustedes tienen el volante. Utilicemos este mapa para cambiar el destino.*
> 
> *Muchas gracias."*
