% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/api.R
\name{post_detection}
\alias{post_detection}
\title{Post a new detection}
\usage{
post_detection(...)
}
\arguments{
\item{...}{Find required parameters here \url{https://api.ecopi.de/api/docs/#tag/v0.2/operation/v0.2_detections_create}}
}
\value{
httr2_response
}
\description{
Wrapper around the 'detections_create' endpoint.
If you want to create a new detection and include a media file, you need to do it in two steps.
First create the detection using \code{post_detection()} and then upload the mediafile with \code{patch_detections()}
TIP: Assigning your own uuid before posting makes it easier to patch a file.
}
\examples{
\dontrun{
post_detection(
  recorder_name = "000000002e611dde",
  datetime = lubridate::now() |> lubridate::with_tz(tzone = "UTC") |> format("\%Y-\%m-\%dT\%H:\%M:\%S") |> paste0("Z") |> as.character(), # lubridate::now(tzone = "UTC") |> format("\%Y-\%m-\%dT\%H:\%M:\%S\%Z") |> as.character(), # "2019-08-24T14:15:22Z",
  start = 1,
  end = 4,
  species_code = "Frosch",
  confidence = -1
)
}
}
