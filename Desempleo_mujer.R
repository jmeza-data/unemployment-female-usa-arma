#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
#                           UNIVERSIDAD NACIONAL DE COLOMBIA
#                   Facultad de Ciencias Económicas | 2024 - 02
#                                  Econometría II | 
#          Metodología Box-Jenkins para la Serie de tiempo desempleo en mujeres
#  SolangeValentina Felix Guerrero - Jhoan Sebastian Meza Garcia - Karol Mora Albarracin
#                                  
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#

# Cargamos librerías 
library(pacman)
pacman::p_load(
  
  forecast,   # Para hacer pronósticos con modelos arima
  lmtest,     # Significancia individual de los coeficientes ARIMA
  urca,       # Prueba de raíz unitaria
  tseries,    # Para estimar modelos de series de tiempo y hacer pruebas de supuestos
  stargazer,  # Para presentar resultados más estéticos
  psych,      # Para hacer estadísticas descriptiva
  seasonal,   # Para desestacionalizar series
  aTSA,       # Para hacer la prueba de efectos ARCH
  astsa,      # Para estimar, validar y hacer pronósticos para modelos ARIMA/SARIMA
  xts,        # Para utilizar objetos xts 
  tidyverse,  # Conjunto de paquetes (incluye dplyr y ggplot2)
  readxl,     # Para leer archivos excel 
  car,        # Para usar la función qqPlot
  mFilter,    # Para aplicar el Filtro Hodrick-Prescott
  quantmod,    
  fable,      # Forma moderna de hacer pronóstiocs en R (se recomienda su uso)  
  tsibble,    # Para poder emplear objetos de series de tiempo tsibble
  feasts      # Provee una colección de herramientas para el análisis de datos de series de tiempo 
)


#         Se carga la base de datos "Unemployment Level - Women (LNS13000002)"
#         Link: https://fred.stlouisfed.org/series/LNS13000002
#         Esta contiene información sobre el Desempleo femenino en Estados Unidos. 
#         Estos datos se encuentran ajustados estacionalmente.
#         Características claves:
#         Frecuencia: Mensual - Desde enero de 1948 a Noviembre de 2024
#         Unidad: Miles de personas.
#         información es recopilada a partir de la Current Population Survey realizada
#         por la Oficina de Estadísticas Laborales (BLS) de los EE. UU.(U.S.BOREAU OF LABOR STATISTIC)
#         Link: https://www.bls.gov/
# 

mi_base <- read_excel("C:\\Users\\Jhoan meza\\Documents\\Econometria II\\DESEMPLEO MUJER.xls")
file.choose()
# Visualización de la base de datos



#~~~~~~~~~~~~~~        1) Transformaciones iniciales       ~~~~~~~~~~~~#

# Convertir en serie de tiempo

empleo = ts(mi_base$INDPRO, start = 1948, frequency = 12) #ts para convertirlo en serie de tiempo




#****** 1.1) Análisis gráfico  ----#


autoplot(empleo, col="darkorange", 
         xlab = "Fecha", ylab="Miles", lwd=1)+ 
  theme_light()+
  ggtitle("Nivel desempleo mujeres Estados Unidos",
          subtitle = "1948-2024")




#       ~~~          GRÁFICOS DE LAS FAC Y FACP de la serie en nivel              ~~~ #
lags=24

#x11()
par(mfrow=c(1,2))
acf(empleo, lag.max = lags, plot=T, lwd=2,xlab='',main='FAC del Desempleo\n Femenino de USA') 
pacf(empleo,lag.max=lags,plot=T,lwd=2,xlab='',main='FACP del Desempleo\n Femenino de USA')
par(mfrow=c(1,1))
# Como podemos ver, la FAC tiene un decaimento lento a cero,lo que nos da indicios 
# de que el proceso no es estacionario.

# 




#~~~~~~~~~~~~~~~~~~~~~        DIFERENCIACIÓN    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#           ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~    #
#####             1.3. Transformación para volver estacionaria la serie #### 
#             ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~    #

#          

# Aplicar diff(serie_original) 
= diff(empleo)  # Diferencia 


plot.ts(, xlab="",ylab="",
        main="Variación del nivel de desempleo femenino\n en Estados Unidos (1948-2023)",lty=1, 
        lwd=2, col="darkorange")



# Ahora hacemos la ACF y la PACF, para la diferencia del desempleo femenino
# ACF cae a cero, correlación 

x11()
lags=30

par(mfrow=c(1,2))

acf(,lag.max=lags,plot=T,lwd=2,xlab='',
    main='FAC de la variación\n del Desempleo Femenino') 
pacf(,lag.max=lags,plot=T,lwd=2,xlab='',
     main='FACP de la variación\n del Desempleo Femenino')

par(mfrow=c(1,1))

#### 1.4. Identificación Modelo Arima ####
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#

# Método manual para identificar el ARIMA usando criterios de información 

# Ahora vamos a ver lo que muestran los criterios AIC y BIC

AR.m <- 6 #Supondremos que el rezago autorregresivo máximo es 6 (pmax)
MA.m <- 6 #Supondremos que el rezago de promedio móvil máximo es 6. (qmax)


# FUNCIONES VISTAS EN LA CLASE ANTERIOR

arma_seleccion_df = function(ts_object, AR.m, MA.m, d, bool_trend, metodo){
  
  index = 1
  df = data.frame(p = double(), d = double(), q = double(), AIC = double(), BIC = double())
  for (p in 0:AR.m) {
    for (q in 0:MA.m)  {
      fitp <- arima(ts_object, order = c(p, d, q), include.mean = bool_trend, 
                    method = metodo)
      df[index,] = c(p, d, q, AIC(fitp), BIC(fitp))
      index = index + 1
    }
  }  
  return(df)
}

#~~~ FUNCIÓN PARA SELECCIONAR ARIMA POR MENOR AIC ~~~#

arma_min_AIC = function(df){
  df2 = df %>% 
    filter(AIC == min(AIC))
  return(df2)
}

#~~~ FUNCIÓN PARA SELECCIONAR ARIMA POR MENOR BIC ~~~#


arma_min_BIC = function(df){
  df2 = df %>% 
    filter(BIC == min(BIC))
  return(df2)
}

# Llamo la función arma_selection_df para construir un data frame con todos los 
# posibles modelos ARIMA(p, d, q).

# Para nuestro caso D = 0 ya que ya hemos diferenciado.

# Usaremos la función que hemos creado denominada arma_seleccion_df para escoger 
# el ARIMA a usar, con los máximos rezagos que hemos fix  jado (p = 6, q = 6).

mod_d0_indprod = arma_seleccion_df(, AR.m, MA.m, d = 0, TRUE, "ML")


# Veamos los criterios.
View(mod_d0_indprod)

# Selecciono el mejor modelo según menor valor de los criterios AIC y BIC.

min_aic_dlindprod = arma_min_AIC(mod_d0_indprod)
min_aic_dlindprod # ARIMA (1.0.5)

min_bic_dlindprod = arma_min_BIC(mod_d0_indprod)
min_bic_dlindprod # ARIMA (2.0.2)

# Ambos criterios de información sugieren un ARIMA (2,2) --> Por eso, usaremos la diferenciada


#         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
####   2. Segundo paso: Estimación -- Modelo en diferencia ####
#     ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~   #

arima_2.0.4_dempleo = arima(, order = c(2,0,2), 
                              include.mean = T, method = "ML")

summary(arima_2.0.4_dempleo) # modelamiento ARIMA(2,0,2)



#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
#### 3. Tercer paso: Validación de supuestos ####
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
##### 3.1. No autocorrelación de los errores ####
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#

# Se dice que la cantidad "ideal" de lags es un cuarto de la muestra
lags.test = length()/4;lags.test

#--> ARIMA(2,0,2)

# Argumento gráfico para verificar correlación y (heterocedasticidad) no estoy segura

res_arima_1.0.0_dlindprod = residuals(arima_2.0.4_dempleo)
par(mfrow=c(1,2))
acf(res_arima_1.0.0_dlindprod,lag.max=24,plot=T,lwd=1,xlab='',
    main='FAC residuales') 
pacf(res_arima_1.0.0_dlindprod,lag.max=24,plot=T,lwd=1,xlab='',
     main='FACP residuales')
par(mfrow=c(1,1))



# PRUEBAS FORMALES
#~~ BOX-PIERCE TEST ~~# 


#Ho = No autocorrelación 
#Ha = Hay autocorrelación


Box.test(res_arima_1.0.0_dlindprod, lag=lags.test, type = c("Box-Pierce")) # NO Rechazamos H0
Box.test(res_arima_1.0.0_dlindprod, lag=10, type='Box-Pierce') # NO Rechazamos H0


# Se concluye: No se rechaza la Hipótesis nula --> Se cumple no autocorrelación serial para el modelo ARMA (2,2)


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
##### 3.2. Homocedasticidad de los residuales ####
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#

# La prueba ARCH nos dice si los residuales son homocedasticos.


#Ho = Homocedasticidad 
#Ha = heterocedasticidad


# Hay dos formas de hacer la prueba: Un test Pormenteau y un Test tipo 
# multiplicadores de Lagrange.

#--> ARIMA(2,0,2)

arch_dlindprod_arima_1.0.0 = arch.test(arima_2.0.4_dempleo, output=TRUE)

#Por prueba ARCH
arch_dlindprod_arima_2.0.4 = arch.test(arima_2.0.4_dempleo, output=TRUE)

# No rechazamos H0, se cumple la Homocedasticidad

# Otro método:  podemos buscar un único P-value
# Hallamos los residuos 
residuos <- residuals(arima_2.0.4_dempleo)

#Realizamos la prueba - Método basado en multiplicadores de Lagrange
ArchTest(residuos, lags = 5)

# Se confirma que No se rechaza la Ho, entonces, se cumple el supuesto de Homocedasticidad.
install.packages("FinTS")
install.packages("lmtest")  
library(lmtest)  
library(FinTS)

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
##### 3.3. Normalidad en los residuales ####
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
# Prueba formal: Jarque-Bera Test


#Ho = Normalidad
#Ha = No hay normalidad

qqPlot(res_arima_1.0.0_dlindprod, ylab = "ARMA(2,2)", main = "Verificación de normalidad mediante QQ-Plot para ARMA(2,2)")
jarque.bera.test(res_arima_1.0.0_dlindprod) 


# Se rechaza la Ho. No se cumple con el supuesto de normalidad
# Gráficamente podemos notar que no se cumple con el supuesto de normalidad.


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
##### 4.1. Pronósticos futuros ####
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#

# ARIMA (2,0,2)

arima_2.1.4_lindprod_fable  = as_tsibble() %>%
  model(arima214 = ARIMA(value ~ pdq(2,0,2) + PDQ(0, 0, 0)))


# Fable realiza el proceso de boostraping automaticamente con boostrap = TRUE.
forecast_arima_2.1.4_lindprod = arima_2.1.4_lindprod_fable %>% 
  forecast(h = 10, bootstrap = TRUE, times = 10000)

forecast_arima_2.1.4_lindprod


#~~ Pronóstico por intervalos al 95% ~~#

pronosticos_2.1.4_lindprod = forecast_arima_2.1.4_lindprod %>% 
  hilo(level = c(95))

View(pronosticos_2.1.4_lindprod)

# Pronósticos a nivel

exp(pronosticos_2.1.4_lindprod$.mean)
exp(pronosticos_2.1.4_lindprod$`95%`)

#~~ GRÁFICOS DEL PRONÓSTICO ~~#

#--> Gráfico de

pronostico = forecast(arima_2.1.4_lindprod, level = c(95), h = 10)

autoplot(pronostico, color = 'firebrick1',
         predict.linetype = 'dashed', conf.int = FALSE, ylab = "Δ desempleo femenino")+
  ggtitle("Pronóstico del desempleo femenino en Estados Unidos (Serie Diferenciada)\nModelo ARIMA (2,0,2)")


#--> Gráfico en Niveles

pronostico_nivel = predict(arima_2.1.4_lindprod, n.ahead = 10)
pronostico_nivel

# Pronosticar 10 trimestres futuros

prediccion_nivel_10Q = exp(pronostico_nivel$pred)

# Añadir margen de error

intervalo_sup = prediccion_nivel_10Q + qnorm(0.95, 0, 1) * exp(pronostico_nivel$se)
intervalo_inf = prediccion_nivel_10Q - qnorm(0.95, 0, 1) * exp(pronostico_nivel$se)

ts.plot(empleo, prediccion_nivel_10Q, intervalo_sup, intervalo_inf,
        col=c('black', 'blue', "orange", "orange"),lty = c(1,2,2,2), 
        main = "Pronóstico del IPI")






#~~~~~~~~~~~~~~~~~~~~~        TASA DE CRECIMIENTO CASO - NO CUMPLE  ~~~~~~~~~~~~~~~~~~~~~~~~~~
#           ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~    #
#####             1.3. Transformación para volver estacionaria la serie #### 
#             ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~    #

#          
#   +++++++++++++++++++++++++++++++++
# Aplicar diff(log(serie_original)): 
dl.empleo= diff(log(empleo))*100   # Diferencia de logaritmos de la serie 
# (tasa de crecimiento)

# IMPORTANTE: Primero se aplica log y luego diff si van a usar ambos. 


plot.ts(dl.empleo, xlab="",ylab="",
        main="Tasa de crecimiento del Desempleo femenino para Estados Unidos",lty=1, 
        lwd=2, col="lightgreen")

#Aplicando el filtro a las tres transformaciónes para apreciar el efecto de cada una 
#sobre la serie original.:

hpf_dl = hpfilter(dl.empleo, freq = 14400)

#Efecto de la diferencia del logaritmo sobre la serie
x11()
plot(hpf_dl)


# Ahora hacemos la ACF y la PACF, para la tasa de crecimiento del indprod donde 
# evidenciamos un proceso débilmente dependiente. 

x11()
lags=30

par(mfrow=c(1,2))

acf(dl.empleo,lag.max=lags,plot=T,lwd=2,xlab='',
    main='ACF de la tasa de crecimiento del Desempleo Femenino') 
pacf(dl.empleo,lag.max=lags,plot=T,lwd=2,xlab='',
     main='PACF de la tasa de crecimiento del Desempleo Femenino')

par(mfrow=c(1,1))

# Se observa en la ACF la típica caída "geométrica" que uno esperaría observar 
# de una serie estacionaria, lo cual es un indicativo de que la diferenciación 
# si eliminó la raíz unitaria. 

# Prueba Dickey Fuller para comprobar si es estacionaria
ADF.dl.empleo <- ur.df(dl.empleo, type= "none", selectlags = "AIC")
summary(ADF.dl.empleo) 
# Respuestas: ---------->  test-statistic is: -21.8838 
#             ---------->   Critical values:  -1.95

# Análisis: ------------>  test-statistic(Valor calculado) <  Critical values = Rechaza Ho
#           ------------>  Ho: NO estacionareidad
#           ------------> Entonces, al rechazarla confirmamos que la serie es estacionaria

# Rechazamos Ho, así que la tasa de crecimiento del desempleo femenido es estados Unidos es estacionaria en 
# sentido débil.

# Vamos a analizar las estadísticas descriptivas de la serie en primera diferencia. 

describe(dl.empleo) # Parece que la media es distina a cero. Intercepto

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
##### 1.4. Identificación Modelo Arima ####
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#

# Método manual para identificar el ARIMA usando criterios de información 

# Ahora vamos a ver lo que muestran los criterios AIC y BIC

AR.m <- 6 #Supondremos que el rezago autorregresivo máximo es 6 (pmax)
MA.m <- 6 #Supondremos que el rezago de promedio móvil máximo es 6. (qmax)


# FUNCIONES VISTAS EN LA CLASE ANTERIOR

arma_seleccion_df = function(ts_object, AR.m, MA.m, d, bool_trend, metodo){
  
  index = 1
  df = data.frame(p = double(), d = double(), q = double(), AIC = double(), BIC = double())
  for (p in 0:AR.m) {
    for (q in 0:MA.m)  {
      fitp <- arima(ts_object, order = c(p, d, q), include.mean = bool_trend, 
                    method = metodo)
      df[index,] = c(p, d, q, AIC(fitp), BIC(fitp))
      index = index + 1
    }
  }  
  return(df)
}

#~~~ FUNCIÓN PARA SELECCIONAR ARIMA POR MENOR AIC ~~~#

arma_min_AIC = function(df){
  df2 = df %>% 
    filter(AIC == min(AIC))
  return(df2)
}

#~~~ FUNCIÓN PARA SELECCIONAR ARIMA POR MENOR BIC ~~~#


arma_min_BIC = function(df){
  df2 = df %>% 
    filter(BIC == min(BIC))
  return(df2)
}

# Llamo la función arma_selection_df para construir un data frame con todos los 
# posibles modelos ARIMA(p, d, q).

# Para nuestro caso D = 0 ya que ya hemos diferenciado.

# Usaremos la función que hemos creado denominada arma_seleccion_df para escoger 
# el ARIMA a usar, con los máximos rezagos que hemos fix  jado (p = 6, q = 6).

mod_d0_indprod = arma_seleccion_df(dl.empleo, AR.m, MA.m, d = 0, TRUE, "ML")

# Veamos los criterios.
View(mod_d0_indprod)

# Selecciono el mejor modelo según menor valor de los criterios AIC y BIC.

min_aic_dlindprod = arma_min_AIC(mod_d0_indprod)
min_aic_dlindprod # ARIMA (0.0.0)

min_bic_dlindprod = arma_min_BIC(mod_d0_indprod)
min_bic_dlindprod # ARIMA (0.0.0)

# Ambos criterios de información sugieren un ARIMA (0.0) --> Por eso, no usaremos la tasa de crecimiento




## -----------------------------------------------------------------------------##

# Bibliografía
#   1. U.S. Bureau of Labor Statistics, Unemployment Level - Women [LNS13000002],
#     retrieved from FRED, Federal Reserve Bank of St. 
#     Louis; https://fred.stlouisfed.org/series/LNS13000002, December 14, 2024.




# ~~~~~~~~~~~~~~~~ 1. Ajustar el modelo ARIMA ~~~~~~~~~~~~~~~~
# Ajustar un modelo ARIMA(2,0,2) a la serie diferenciada
modelo_arima <- arima(empleo, order = c(2, 0, 2), 
                      include.mean = TRUE, method = "ML")  # Ajuste por máxima verosimilitud

# ~~~~~~~~~~~~~~~~ 2. Realizar el pronóstico ~~~~~~~~~~~~~~~~
# Pronóstico de 12 períodos hacia adelante con intervalo de confianza del 95%
library(forecast)
pronostico <- forecast(modelo_arima, h = 12, level = c(95))

# ~~~~~~~~~~~~~~~~ 3. Visualizar el pronóstico ~~~~~~~~~~~~~~~~
# Visualización del pronóstico
autoplot(pronostico) +
  ggtitle("Pronóstico del nivel de desempleo femenino en EE.UU.") +
  xlab("Fecha") + ylab("Desempleo (en miles)") +
  theme_minimal()

# ~~~~~~~~~~~~~~~~ 4. Ver el resultado del pronóstico ~~~~~~~~~~~~~~~~
# Imprimir los valores pronosticados y el intervalo de confianza
print(pronostico)

