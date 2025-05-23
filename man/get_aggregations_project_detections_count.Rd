% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/api.R
\name{get_aggregations_project_detections_count}
\alias{get_aggregations_project_detections_count}
\title{Get a count of detections per project by default and per group(s) if specified.}
\usage{
get_aggregations_project_detections_count(
  project_name,
  ...,
  get_response = FALSE
)
}
\arguments{
\item{project_name}{Name of the project to get a count on detetcions}

\item{...}{query paramaters. See \url{https://api.ecopi.de/api/v0.2/aggregations/projects/{project_name}/detections_count}}

\item{get_response}{Logical. If TRUE, returns a list containing both the original response and the data frame.}
}
\value{
If get_response is FALSE (default), returns a list of meta information and a dataframe of the counts of detections.
If get_response is TRUE, returns a list with 'data' (the counts information) and 'response' (the original API response).
}
\description{
Wrapper around the 'aggregations_project_detections_count' endpoint to retrieve a count of detections for each project and per group(s) if specified.
}
\examples{
# Retrieve a count of detections for a specific project
\dontrun{
get_aggregations_project_detections_count(project_name = "pam_in_chemnitz")
}
# Retrieve a count of detections for a specific project per specified group(s), here in the example per recorder and species
\dontrun{
get_aggregations_project_detections_count(project_name = "pam_in_chemnitz", group_by = "recorder_field_id,scientific_name")
}

}
