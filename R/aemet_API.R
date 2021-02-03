
aemetJSONtodf <- function(aemet.JSON, variable){
  df.glob <- data.frame()
  for (i in 1:length(aemet.JSON[[1]]$prediccion$dia)){
    aemet.JSON[[1]]$prediccion$dia[[i]]$fecha %>% as.POSIXct() -> d1

    if (variable == "viento"){

      (1:(aemet.JSON[[1]]$prediccion$dia[[i]]$vientoAndRachaMax %>% length()))[c(T,F)] -> idx.viento # los indices pares son rachaMax

      data.frame(
        hour =  d1 + lubridate::hours(aemet.JSON[[1]]$prediccion$dia[[i]]$vientoAndRachaMax[idx.viento] %>% lapply("[[", "periodo") %>% unlist() %>% as.numeric()),
        value =            aemet.JSON[[1]]$prediccion$dia[[i]]$vientoAndRachaMax[idx.viento] %>% lapply("[[", "velocidad") %>% unlist() %>% as.numeric()
      ) -> df


    } else {
      data.frame(
        hour  = d1 + lubridate::hours(aemet.JSON[[1]]$prediccion$dia[[i]][[variable]] %>% lapply("[[", "periodo") %>% unlist() %>% as.numeric()),
        value =            aemet.JSON[[1]]$prediccion$dia[[i]][[variable]] %>% lapply("[[", "value") %>% unlist() %>% as.numeric()
      ) -> df
    }


    df.glob <- rbind(df.glob,df)
  }
  return(df.glob)
}


#' Get 48 h forecast from AEMET (http://www.aemet.es/).
#'
#'The forecast are retrived from Specific Forecasts by Municipality \href{https://opendata.aemet.es/centrodedescargas/productosAEMET?}{link}.
#'
#' \code{getForecastAEMET} returns a dataframe with date, temperature (Celsius scale), relative humidity (RH)(\%), rainfall (mm) and wind (m/s).
#'
#'@param  codigo character with Municipality Code. See \href{https://www.ine.es/daco/daco42/codmun/codmunmapa.htm}{link}.
#'
#'@param KEY character API key. Users must register to obtain it. See \href{https://opendata.aemet.es/centrodedescargas/altaUsuario?}{link}.
#'@examples
#' \dontrun{
#' key.aemet <- "AEMET-API-KEY"
#'getForecastAEMET(codigo = "03140", KEY = key.aemet)  # Villena, Alicante, Spain
#' }
#' @export
getForecastAEMET<-function(codigo, KEY){

 if (missing(codigo)) {
    stop("argument 'codigo' is missing, with no default")
 }

  if (missing(KEY)) {
    stop("argument 'KEY' is missing, with no default")
  }

 if (!is.character(codigo)) {
   stop("argument 'codigo' must be a character")
 }


  if (!is.character(KEY)) {
    stop("argument 'KEY' must be a character")
  }
  # Returns link to json data
  DIR <- paste0("https://opendata.aemet.es/opendata/api/prediccion/especifica/municipio/horaria/", codigo)
  r<-httr::GET(DIR,
               httr::add_headers(content_type = "application/json"),
               httr::add_headers('api_key' = KEY))
  r$status_code
  content <- httr::content(r)

  # Returns raw json data
  r <-httr::GET(content$datos,
                httr::add_headers(content_type = "application/json"),
                httr::add_headers('api_key' = KEY))
  r$status_code
  content <- httr::content(r)

  tmpfile <- tempfile(pattern = codigo, tmpdir = tempdir(), fileext = ".json") # puede fallar si no hay directorio tmp
  content %>% write(file = tmpfile)
  aemet <- RJSONIO::fromJSON(tmpfile)
  unlink(tmpfile)
  temp  <- aemetJSONtodf(aemet, "temperatura")
  HR    <- aemetJSONtodf(aemet, "humedadRelativa")
  prec  <- aemetJSONtodf(aemet, "precipitacion")
  viento<- aemetJSONtodf(aemet, "viento")

  df <- data.frame(date = temp[,1],
                   temp  = temp[,2],
                   HR    = HR[,2],
                   prec  = prec[,2],
                   viento = viento[,2]/3.6)

  return(df)
}

