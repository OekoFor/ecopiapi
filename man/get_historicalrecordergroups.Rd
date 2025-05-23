% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/api.R
\name{get_historicalrecordergroups}
\alias{get_historicalrecordergroups}
\title{Get historical recorder groups list.}
\usage{
get_historicalrecordergroups(..., get_response = FALSE)
}
\arguments{
\item{...}{query paramaters. See \url{https://api.ecopi.de/api/docs/#tag/v0.2/operation/v0.2_historicalrecordergroups_list}.}

\item{get_response}{Logical. If TRUE, returns a list containing both the original response and the data frame.}
}
\value{
If get_response is FALSE (default), returns a list containing the historical recorder groups.
If get_response is TRUE, returns a list with 'data' (the historical recorder groups) and 'response' (the original API response).
}
\description{
Wrapper around the 'historicalrecordergroups_list' endpoint to retrieve a list of recorder groups based on the specified query parameters.
This contains the configurations and species list
}
\examples{
# Retrieve a data frame of historical recorder groups for project 'oekofor'
\dontrun{
get_historicalrecordergroups(project_name = "oekofor")
}

}
