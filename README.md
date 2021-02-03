# meteoForecast
A R package for obtain weather forecasts from well-known sources.

```{r}
install.packages("devtools")
library(devtools)
install_github("VicenteYago/meteoForecast")
library("meteoForecast")

# AEMET 48 hour forecast
key.aemet <- "AEMET-API-KEY"
aemet.df <- getForecastAEMET(codigo = "03140", KEY = key.aemet)
head(aemet.df) 
                  date temp HR prec    viento
1  2021-02-03 01:00:00   11 74    0 3.6111111
2  2021-02-03 02:00:00   11 73    0 3.8888889
3  2021-02-03 03:00:00   11 74    0 3.8888889
4  2021-02-03 04:00:00   11 75    0 3.8888889
5  2021-02-03 05:00:00   10 75    0 4.1666667


# OPENWEATHER 48 hour forecast
key.ow <- "OW-API-KEY"
ow.df <-getForecastOpenWeather(lat = "37.9929600", long = "-1.5366100", KEY = key.ow)
head(ow.df)
                  date  temp HR prec viento
1  2021-02-03 10:00:00 12.85 87   NA   1.89
2  2021-02-03 11:00:00 13.91 66   NA   1.60
3  2021-02-03 12:00:00 15.73 49   NA   1.54
4  2021-02-03 13:00:00 17.24 40   NA   1.49
5  2021-02-03 14:00:00 18.18 36   NA   1.61



```
