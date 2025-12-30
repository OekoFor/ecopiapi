# Count of detections & sum of recorded minutes per user defined interval for a project.

Wrapper around the 'aggregations_project_time_series' endpoint to
retrieve a count of detections & sum of recorded minutes per user
defined interval for a project.

## Usage

``` r
get_aggregations_project_time_series(project_name, ...)
```

## Arguments

- project_name:

  Name of the project to get a count on detetcions

- ...:

  query paramaters. See
  <https://api.ecopi.de/api/docs/#tag/v0.2/operation/v0.2_aggregations_projects_time_series_retrieve>

## Value

A list of meta information of the api request and a dataframe of the
counts of detections for a specified project and interval (stored in the
list "\$result"):
<https://api.ecopi.de/api/docs/#tag/v0.2/operation/v0.2_aggregations_projects_recorders_time_series_retrieve>.

## Examples

``` r
# Retrieve a count of detections for a every 5 minutes in the PAM chemitz project.
if (FALSE) { # \dontrun{
get_aggregations_project_time_series(project_name = "pam_in_chemnitz", interval_unit = "minute", interval_size = 5)
} # }

# $results
```
