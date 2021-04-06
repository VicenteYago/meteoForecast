# meteoForecast
A R package for obtain weather forecasts from well-known sources.

```{r}
install.packages("devtools")
library(devtools)
install_github("VicenteYago/meteoForecast")
library("meteoForecast")
```

### AEMET
#### 48 hour forecast

```{r}
key.aemet <- "AEMET-API-KEY"
aemet.df <- getForecastAEMET(codigo = "03140", KEY = key.aemet)
head(aemet.df) 
                  date temp HR prec    viento
1  2021-02-03 01:00:00   11 74    0 3.6111111
2  2021-02-03 02:00:00   11 73    0 3.8888889
3  2021-02-03 03:00:00   11 74    0 3.8888889
4  2021-02-03 04:00:00   11 75    0 3.8888889
5  2021-02-03 05:00:00   10 75    0 4.1666667
```

### OPENWEATHER
#### 48 hour forecast
```{r}
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
####  current weather
```{r}
getCurrentOpenWeather(lat = "37.9929600", long = "-1.5366100", KEY = key.ow)

                 date  temp HR windSpeed windDegree pres clouds condID conditionsDesc
1 2021-04-06 13:43:11 25.25 41      0.51        170 1012      0    800      clear sky
```

### WEATHERBIT
#### 48 hour forecast
```{r}
wb.df <- getWeatherBit(lat = "37.9929600", long = "-1.5366100", KEY = key.wb)
str(wd.df)

'data.frame':	6 obs. of  32 variables:
 $ timestamp_utc  : chr  "2021-04-06T19:00:00" "2021-04-06T20:00:00" "2021-04-06T21:00:00" "2021-04-06T22:00:00" ...
 $ timestamp_local: chr  "2021-04-06T21:00:00" "2021-04-06T22:00:00" "2021-04-06T23:00:00" "2021-04-07T00:00:00" ...
 $ wind_cdir      : chr  "SSW" "SW" "WSW" "WSW" ...
 $ rh             : int  44 39 39 45 51 55
 $ pod            : chr  "n" "n" "n" "n" ...
 $ pres           : num  965 966 966 966 966 ...
 $ solar_rad      : num  0 0 0 0 0 0
 $ ozone          : num  340 338 336 336 336 ...
 $ weather        : chr  "Overcast clouds" "Overcast clouds" "Overcast clouds" "Overcast clouds" ...
 $ wind_gust_spd  : num  6.2 5.56 3.99 3.28 2.65 ...
 $ snow_depth     : int  0 0 0 0 0 0
 $ clouds         : int  100 89 100 86 71 52
 $ ts             : int  1617735600 1617739200 1617742800 1617746400 1617750000 1617753600
 $ wind_spd       : num  3.38 2.84 2.28 1.42 1.59 ...
 $ pop            : int  0 0 0 0 0 0
 $ wind_cdir_full : chr  "south-southwest" "southwest" "west-southwest" "west-southwest" ...
 $ slp            : num  1009 1010 1010 1011 1011 ...
 $ dni            : num  0 0 0 0 0 0
 $ dewpt          : num  7.7 5.5 5.5 6.3 6.6 6.3
 $ snow           : int  0 0 0 0 0 0
 $ uv             : num  0 0 0 0 0 0
 $ wind_dir       : int  212 223 237 248 262 261
 $ clouds_hi      : int  100 55 99 62 38 27
 $ precip         : num  0 0 0 0 0 0
 $ vis            : num  24.1 24.1 24.1 24.1 24.1 ...
 $ dhi            : num  0 0 0 0 0 0
 $ app_temp       : num  19.2 18.2 17.6 17.7 16.5 14.8
 $ datetime       : chr  "2021-04-06:19" "2021-04-06:20" "2021-04-06:21" "2021-04-06:22" ...
 $ temp           : num  20 19.2 18.6 17.7 16.5 14.8
 $ ghi            : num  0 0 0 0 0 0
 $ clouds_mid     : int  58 87 77 68 52 35
 $ clouds_low     : int  0 0 0 0 0 0
