% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/api.R
\name{get_recorderstates}
\alias{get_recorderstates}
\title{Get recorder states list.}
\usage{
get_recorderstates(...)
}
\arguments{
\item{...}{query paramaters. See \url{https://api.ecopi.de/api/docs/#tag/v0.1/operation/v0.1_recorderstates_list}}
}
\value{
A dataframe containing the recorder states that match the specified query parameters: \url{https://api.ecopi.de/api/docs/#tag/v0.1/operation/v0.1_recorderstates_list}.
}
\description{
Wrapper around the 'recorderstates_list' endpoint to retrieve a list of recorder states based on the specified query parameters.
}
\examples{
# Retrieve all recorder states
\dontrun{
get_recorderstates()
}

# Retrieve a list of recorder states for recorder '00000000d76d0bf9'
\dontrun{
get_recorderstates(recorder_name = "00000000d76d0bf9")
}

}
