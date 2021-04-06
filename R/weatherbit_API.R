weathebitJSONtodf <- function(content){
  content$data[[1]] %>% names() %>%
    as.list() %>%
    lapply(function(var.name){
      lapply(content$data, "[[", var.name) %>% unlist
    }) -> l

  names(l) <- names(content$data[[1]])

  l[["weather"]] <- lapply(content$data, "[[", "weather") %>%
    lapply("[[", "description") %>% unlist

  df <- as.data.frame(l)

  cbind(timestamp_utc = df$timestamp_utc,
        df[,!names(df) %in% c("timestamp_utc")])

  data.frame(timestamp_utc   = df$timestamp_utc,
             timestamp_local = df$timestamp_local,
             df[,!names(df) %in% c("timestamp_utc", "timestamp_local")])
}


getWeatherBit <- function(lat, long, KEY) {

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


  paste0("https://api.weatherbit.io/v2.0/forecast/hourly?lat=",lat,"&lon=",long,"&key=", KEY,"&hours=48") -> DIR
  r<-httr::GET(DIR,
               httr::add_headers(content_type = "application/json"),
               httr::add_headers('api_key' = KEY))

  r$status_code
  content <- httr::content(r)

  return(weathebitJSONtodf(content))
}
