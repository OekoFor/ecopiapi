% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/api.R
\name{get_recordings}
\alias{get_recordings}
\title{Get recordings list.}
\usage{
get_recordings(...)
}
\arguments{
\item{...}{query paramaters. See \url{https://api.ecopi.de/api/docs/#tag/v0.1/operation/v0.1_recordings_list}}
}
\value{
A data.frame containing the recordings that match the specified query parameters: \url{https://api.ecopi.de/api/docs/#tag/v0.1/operation/v0.1_recordings_list}
}
\description{
Wrapper around the 'recordings_list' endpoint to retrieve a dataframe of recordings based on the specified query parameters.
}
\examples{
# Retrieve a list of recordings for project '017_neeri' that occurred in March (month=3)
\dontrun{
get_recordings(project_name = "017_neeri", datetime__month = 3)
}

}
