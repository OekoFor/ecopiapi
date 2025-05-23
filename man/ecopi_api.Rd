% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/api.R
\name{ecopi_api}
\alias{ecopi_api}
\title{Make API requests to the Ecopi API}
\usage{
ecopi_api(
  resource,
  ...,
  params = list(),
  new_data = list(),
  file_path,
  base_url = getOption("ecopiapi.base_url", "https://api.ecopi.de/api/v0.2")
)
}
\arguments{
\item{resource}{A character string specifying the API resource to request.}

\item{...}{Path parameters, that point to a specific resource, to be passed to the req_template() function.}

\item{params}{Query parameters that modify the reuqest.}

\item{new_data}{A named list of parameters to be updated/ patched.}

\item{file_path}{A path currently only important to patch an image to a recorder endpoint (Watchout! If file_path given, new_data gets ignored (cannot patch multiple types)).}
}
\value{
A \code{response} object from the httr2 package containing the API response.
}
\description{
This function sends an API request to the Ecopi API with the specified resource, parameters, and optional arguments.
}
\examples{
\dontrun{
# Send a request to the 'detections' endpoint. Only get detections in the project '017_neeri'
response <- ecopi_api("GET /detections/", params = list("project" = "017_neeri"))
}
}
