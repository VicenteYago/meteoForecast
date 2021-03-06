% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/aemet_API.R
\name{getForecastAEMET}
\alias{getForecastAEMET}
\title{Get 48 h forecast from AEMET (http://www.aemet.es/).}
\usage{
getForecastAEMET(codigo, KEY)
}
\arguments{
\item{codigo}{character with Municipality Code. See \href{https://www.ine.es/daco/daco42/codmun/codmunmapa.htm}{link}.}

\item{KEY}{character API key. Users must register to obtain it. See \href{https://opendata.aemet.es/centrodedescargas/altaUsuario?}{link}.}
}
\description{
The forecast are retrived from Specific Forecasts by Municipality \href{https://opendata.aemet.es/centrodedescargas/productosAEMET?}{link}.
}
\details{
\code{getForecastAEMET} returns a dataframe with date, temperature (Celsius scale), relative humidity (RH)(\%), rainfall (mm) and wind (m/s).
}
\examples{
\dontrun{
key.aemet <- "AEMET-API-KEY"
getForecastAEMET(codigo = "03140", KEY = key.aemet)  # Villena, Alicante, Spain
}
}
