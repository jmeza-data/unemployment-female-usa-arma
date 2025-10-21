# 📊 Análisis del Desempleo Femenino en Estados Unidos (1948–2024)
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
- `Econometría_2024_2.png` → Poster del análisis con resultados gráficos y pronóstico.  
- `script_arma_females.R` → Código utilizado para el procesamiento, estimación y validación del modelo.  
- `data/` → Carpeta con la serie original y versiones transformadas.  
- `results/` → Tablas de resultados, gráficos y diagnóstico del modelo.

---

## ⚙️ Metodología
Se aplicó la metodología **Box–Jenkins**, siguiendo las etapas de:
1. **Identificación:** análisis de FAC y FACP, detección de no estacionariedad.  
2. **Transformación:** diferenciación de la serie y eliminación de tendencia.  
3. **Estimación:** comparación de modelos ARMA(p,q) usando AIC y BIC.  
4. **Validación:** pruebas Ljung-Box, Jarque-Bera y ARCH para verificar supuestos.  
5. **Pronóstico:** proyección de desempleo femenino para 2025–2026 con intervalos al 95%.

---

## 📈 Resultados principales
- Modelo final seleccionado: **ARMA(2,2)**.  
- Los residuos cumplen los supuestos de **normalidad, homocedasticidad y no autocorrelación**.  
- Se observa una **tendencia de estabilización posterior a los picos de 2020**, evidenciando la recuperación tras la pandemia.  
- El pronóstico muestra una **suave convergencia hacia niveles pre-COVID**, con variaciones estacionales leves.

---

## 🧮 Herramientas utilizadas
- **R Studio** (paquetes `forecast`, `tseries`, `ggplot2`, `urca`)  
- **Excel / CSV** para manipulación de datos  
- **Power BI / Canva** para visualización final  

---

## 📂 Fuente de datos
U.S. Bureau of Labor Statistics – *Unemployment Level: Women (LNS13000002)*  
[https://fred.stlouisfed.org/series/LNS13000002](https://fred.stlouisfed.org/series/LNS13000002)

---

## 📚 Referencias
- Box, G. E. P., Jenkins, G. M., & Reinsel, G. C. (2015). *Time Series Analysis: Forecasting and Control.*  
- Hyndman, R. J., & Athanasopoulos, G. (2021). *Forecasting: Principles and Practice.*  
- Bureau of Labor Statistics (2024). *Unemployment statistics.*

---

## ✨ Sobre el autor
👋 **Jhoan Meza**  
Economista (en formación) – Universidad Nacional de Colombia  
Apasionado por el análisis de datos, econometría y visualización de información aplicada a políticas públicas y desarrollo económico.  

🔗 [LinkedIn](https://www.linkedin.com/in/jmeza-data)  
📧 [Correo académico o profesional]  
🌐 [Portafolio o GitHub Pages si lo tienes]

---

© 2024 Jhoan Meza. Proyecto académico sin fines comerciales.
