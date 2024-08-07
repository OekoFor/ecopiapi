% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/api.R
\name{get_recordergroups}
\alias{get_recordergroups}
\title{Get recorder groups list.}
\usage{
get_recordergroups(...)
}
\arguments{
\item{...}{query paramaters. Leave empty to get all recordergroups. See \url{https://api.ecopi.de/api/docs/#tag/v0.1/operation/v0.1_recordergroups_list}.}
}
\value{
A list containing the recorder groups that match the specified query parameters: \url{https://api.ecopi.de/api/docs/#tag/v0.1/operation/v0.1_recordergroups_list}.
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
