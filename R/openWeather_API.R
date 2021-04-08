#' meteoForecast: A package for obtain weather forecasts from well-known sources.
#'
#' Each forecast provider has its own particularities when it comes to data availability, this package aims to standardize the data in a single format.
#'
#'At the moment the following variables are retrieved: temperature (Celsius scale), relative humidity (RH)(\%), rainfall (mm) and wind (m/s). Each forecast provider updates its forecasts at a different rate, which creates differences for the start and end date of the forecasts.
#'

#' @docType package
#' @name meteoForecast
#' @importFrom magrittr %>%
NULL



openWeatherJSONtodf <- function(content.JSON, variable) {
  data.frame(date  = lapply(content.JSON$hourly, "[[", "dt") %>% unlist() %>% as.POSIXct(origin  = "1970-01-01"),
             value = lapply(content.JSON$hourly, "[[", variable) %>% unlist()) -> res

  if (variable == "temp" || variable == "dew_point" ) {
    res[,2] <- res[,2] - 273.15
  }
  return(res)
}

#' Get 48 h forecast from OpenWeather (https://openweathermap.org/).
#'
#' The forecast are retrived from Open Weather One Call API \href{https://openweathermap.org/api/one-call-api}{link}.
#'
#' \code{getForecastOpenWeather} returns a dataframe with date, temperature (Celsius scale), relative humidity (RH)(\%), rainfall (mm) and wind (m/s).
#'  In not all locations OpenWeather provides rain data, in this case the dataframe contains NA for the precipitation column.
#'
#' @param  lat character latitude
#' @param  long character longitude
#' @param  KEY character API key. Users must register to obtain it. See \href{https://openweathermap.org/appid}{link}.
#'@examples
#' \dontrun{
#' key.ow <- "OW-API-KEY"
#' getForecastOpenWeather(lat = "37.9929600", long = "-1.5366100", KEY = key.ow)
#' }

#' @export
getForecastOpenWeather <- function(lat, long, KEY){

  if (missing(lat)) {
    stop("argument 'lat' is missing, with no default")
  }

  if (missing(long)) {
    stop("argument 'long' is missing, with no default")
  }

  if (missing(KEY)) {
    stop("argument 'KEY' is missing, with no default")
  }

  if (!is.character(lat)) {
    stop("argument 'lat' must be a character")
  }

  if (!is.character(long)) {
    stop("argument 'long' must be a character")
  }

  if (!is.character(KEY)) {
    stop("argument 'KEY' must be a character")
  }



  paste0("lat=", lat, "&lon=", long) -> coords

  paste0("https://api.openweathermap.org/data/2.5/onecall?", coords,
         "&exclude=current,minutely,daily&appid=", KEY) -> DIR

  r<-httr::GET(DIR,
         httr::add_headers(content_type = "application/json"),
         httr::add_headers('api_key' = KEY))
  r$status_code
  content <- httr::content(r)

  temp <- openWeatherJSONtodf(content, "temp")
  HR   <- openWeatherJSONtodf(content, "humidity")
  prec <- ifelse(is.null(content$hourly[[1]]$rain),NA, openWeatherJSONtodf(content, "rain")) # rain its not always provided
  viento <- openWeatherJSONtodf(content, "wind_speed")

  data.frame(date = temp[,1],
             temp = temp[,2],
             HR   = HR[,2],
             prec = prec,
             viento = viento[,2])
}



#' Get current weather from OpenWeather (https://openweathermap.org/).
#'
#' The forecast are retrived from Open Weather One Call API \href{https://openweathermap.org/api/one-call-api}{link}.
#'
#' \code{getCurrentOpenWeather} returns a dataframe with date, temperature (Celsius scale), relative humidity (RH)(\%),
#'  windSpeed (m/s), windDegree, pressure, clouds, and conditionsID and description \href{https://openweathermap.org/weather-conditions#Weather-Condition-Codes-2}{link}
#'
#'  In not all locations OpenWeather provides rain data, in this case the dataframe contains NA for the precipitation column.
#'
#'  The `date` variable is given in local timezone.
#'
#' @param  lat character latitude
#' @param  long character longitude
#' @param  KEY character API key. Users must register to obtain it. See \href{https://openweathermap.org/appid}{link}.
#'@examples
#' \dontrun{
#' key.ow <- "OW-API-KEY"
#' getForecastOpenWeather(lat = "37.9929600", long = "-1.5366100", KEY = key.ow)
#' }
#'
#' @export
getCurrentOpenWeather <- function(lat, long, KEY){

  if (missing(lat)) {
    stop("argument 'lat' is missing, with no default")
  }

  if (missing(long)) {
    stop("argument 'long' is missing, with no default")
  }

  if (missing(KEY)) {
    stop("argument 'KEY' is missing, with no default")
  }

  if (!is.character(lat)) {
    stop("argument 'lat' must be a character")
  }

  if (!is.character(long)) {
    stop("argument 'long' must be a character")
  }

  if (!is.character(KEY)) {
    stop("argument 'KEY' must be a character")
  }


  paste0("http://api.openweathermap.org/data/2.5/weather?lat=",lat,"&lon=",long,"&appid=", KEY) -> DIR


  r<-httr::GET(DIR,
               httr::add_headers(content_type = "application/json"),
               httr::add_headers('api_key' = KEY))
  r$status_code
  content <- httr::content(r)
  temp <- content$main$temp - 273.15
  hum <- content$main$humidity
  pressure <- content$main$pressure
  conditionsId  <- content$weather[[1]]$id
  conditionsDesc  <- content$weather[[1]]$description
  windSpeed <- content$wind$speed
  windDegree <- content$wind$deg
  clouds <- content$clouds$all


  data.frame(date = Sys.time(),
             temp = temp,
             HR   = hum,
             windSpeed = windSpeed,
             windDegree = windDegree,
             pres = pressure,
             clouds = clouds,
             condID = conditionsId,
             conditionsDesc = conditionsDesc
             )
}


