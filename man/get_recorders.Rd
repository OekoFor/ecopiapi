% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/api.R
\name{get_recorders}
\alias{get_recorders}
\title{Get recorders list.}
\usage{
get_recorders(...)
}
\arguments{
\item{...}{query paramaters. See \url{https://api.ecopi.de/api/docs/#tag/v0.2/operation/v0.2_recorders_list}.}
}
\value{
A dataframe containing the recorders that match the specified query parameters: \url{https://api.ecopi.de/api/docs/#tag/v0.2/operation/v0.2_recorders_list}.
}
\description{
Wrapper around the 'recorders_list' endpoint to retrieve a list of recorders based on the specified query parameters.
}
\examples{
# Retrieve a list of recorders for project '017_neeri'
\dontrun{
get_recorders(project_name = "017_neerach_ried")
}

}
