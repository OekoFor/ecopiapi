% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/api.R
\name{get_detections_list}
\alias{get_detections_list}
\title{Get detections list.}
\usage{
get_detections_list(params = list())
}
\arguments{
\item{params}{A list of key-value pairs representing the query parameters to be sent with the API request.}
}
\value{
A tibble containing the detections that match the specified query parameters: \url(https://api.ecopi.de/api/docs/#operation/detections_list)
}
\description{
Wrapper around the 'detections_list' endpoint to retrieve a list of detections based on the specified query parameters.
}
\details{
The 'params' parameter is a list of key-value pairs that represent the query parameters to be sent with the API request.
Each key represents a query parameter, and each value represents the value of the query parameter.
For example, to retrieve detections for a specific project, you can set the 'project_name' parameter to the name of the project.
The available query parameters are documented in the EcoPi API documentation: \url(https://api.ecopi.de/api/docs/#operation/detections_list).
}
\examples{
# Retrieve a list of detections for project '017_neeri' that occurred in March (month=3)
get_detections_list(params = list("project_name" = "017_neeri", "datetime__month" = 3))

}
