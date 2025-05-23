% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/api.R
\name{get_recordergroups}
\alias{get_recordergroups}
\title{Get recorder groups list.}
\usage{
get_recordergroups(..., get_response = FALSE)
}
\arguments{
\item{...}{query paramaters. Leave empty to get all recordergroups. See \url{https://api.ecopi.de/api/docs/#tag/v0.2/operation/v0.2_recordergroups_list}.}

\item{get_response}{Logical. If TRUE, returns a list containing both the original response and the data frame.}
}
\value{
If get_response is FALSE (default), returns a list containing the recorder groups.
If get_response is TRUE, returns a list with 'data' (the recorder groups) and 'response' (the original API response).
}
\description{
Wrapper around the 'recordergroups_list' endpoint to retrieve a list of recorder groups based on the specified query parameters.
This contains the configurations and species list
}
\examples{
# Retrieve a data frame of recorder groups for project 'oekofor'
\dontrun{
get_recordergroups(project_name = "oekofor")
}

}
