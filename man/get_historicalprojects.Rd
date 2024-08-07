% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/api.R
\name{get_historicalprojects}
\alias{get_historicalprojects}
\title{Get historical projects list.}
\usage{
get_historicalprojects(...)
}
\arguments{
\item{...}{query paramaters. See \url{https://api.ecopi.de/api/docs/#tag/v0.1/operation/v0.1_historicalprojects_list}}
}
\value{
A dataframe containing the historical projects that match the specified query parameters: \url{https://api.ecopi.de/api/docs/#tag/v0.1/operation/v0.1_historicalprojects_list}.
}
\description{
Wrapper around the 'historicalprojects_list' endpoint to retrieve a list of historical projects based on the specified query parameters.
}
\examples{
# retrieve a dataframe of all historical projects
\dontrun{
get_historicalprojects()
}

# Retrieve a list of projects that contain 'red_panda' or 'green_banana' in their name
\dontrun{
get_historicalprojects(project_name__in = "red_panda, green_banana")
}

}
