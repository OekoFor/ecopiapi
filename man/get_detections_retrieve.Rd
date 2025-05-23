% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/api.R
\name{get_detections_retrieve}
\alias{get_detections_retrieve}
\title{Get detections retrieve.}
\usage{
get_detections_retrieve(id_or_uid, get_response = FALSE)
}
\arguments{
\item{id_or_uid}{The database ID or UID of the respective detection}

\item{get_response}{Logical. If TRUE, returns a list containing both the original response and the data frame.}
}
\value{
If get_response is FALSE (default), returns a list containing the detection.
If get_response is TRUE, returns a list with 'data' (the detection data) and 'response' (the original API response).
}
\description{
Wrapper around the 'Retrieve Detections' endpoint to retrieve a single detection based on uid
}
\examples{
# Retrieve a single detection for a specific uid
get_detections_retrieve(id_or_uid = "64733fbc-7cc8-49f6-adf1-c9ec2d676959")

}
