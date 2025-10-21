# 📊 Análisis del Desempleo Femenino en Estados Unidos (1948–2024)

![Poster Econometría 2024-2](https://raw.githubusercontent.com/jmeza-data/unemployment-female-usa-arma/main/Econometría_2024_2.png)

**Autor:** Jhoan Meza  
**Lenguaje:** R  
**Proyecto académico – Econometría 2024-2**

---

## 🧠 Descripción general
Este proyecto presenta un **análisis econométrico del desempleo femenino en Estados Unidos** mediante la **metodología Box–Jenkins (ARMA)**.  
Se utilizó la serie mensual **“Unemployment Level – Women”** del *Bureau of Labor Statistics (BLS)*, abarcando el período **1948–2024**.

El objetivo principal es **identificar patrones temporales y generar un pronóstico del comportamiento del desempleo femenino**, evaluando la influencia de eventos económicos relevantes como la crisis de 2008 o la pandemia de COVID-19.

---

## 🧩 Contenido del repositorio
- 📁 `Desempleo_mujer.R` → Código en R para la estimación del modelo ARMA(2,2).  
- 🖼️ `Econometría_2024_2.png` → Visualización final del análisis con gráficos, FAC/FACP y pronóstico.

---

## ⚙️ Metodología
Metodología **Box–Jenkins (ARMA)** aplicada en cinco etapas:
1. **Identificación:** análisis de FAC y FACP.  
2. **Transformación:** diferenciación y eliminación de tendencia.  
3. **Estimación:** comparación de modelos ARMA(p,q) usando AIC y BIC.  
4. **Validación:** pruebas Ljung-Box, Jarque-Bera y ARCH.  
5. **Pronóstico:** proyección de desempleo femenino para 2025–2026 con intervalos al 95%.

---

## 📈 Resultados
- Modelo final: **ARMA(2,2)**.  
- Los residuos cumplen los supuestos de **normalidad, homocedasticidad y no autocorrelación**.  
- Se observa una tendencia de estabilización posterior al pico de 2020.  
- El pronóstico sugiere una recuperación gradual del empleo femenino post-pandemia.

---

## 🧮 Herramientas utilizadas
- **R Studio** (`forecast`, `tseries`, `ggplot2`, `urca`)  
- **Excel / CSV** para manejo de datos  
- **Canva / Power BI** para la visualización final  

---

## 📂 Fuente de datos
U.S. Bureau of Labor Statistics – *Unemployment Level: Women (LNS13000002)*  
🔗 [https://fred.stlouisfed.org/series/LNS13000002](https://fred.stlouisfed.org/series/LNS13000002)

---

## ✨ Sobre el autor
👋 **Jhoan Meza**  
Economista (en formación) – Universidad Nacional de Colombia  
Apasionado por el análisis de datos, econometría y visualización aplicada a economía laboral y políticas públicas.  

🔗 [LinkedIn](https://www.linkedin.com/in/jmeza-data)  
📧 [Tu correo profesional o académico]  

---

© 2024 Jhoan Meza. Proyecto académico sin fines comerciales.
