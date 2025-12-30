# Count of detections & sum of recorded minutes per user defined interval for a !!recorder!! of a project.

Wrapper around the 'aggregations_project_recorder_time_series' endpoint
to retrieve a count of detections & sum of recorded minutes per user
defined interval for a recorder of a project.

## Usage

``` r
get_aggregations_project_recorder_time_series(
  project_name,
  recorder_field_id,
  ...
)
```

## Arguments

- project_name:

  Name of the project to get a count on detetcions

- recorder_field_id:

  Recorder field id from which to derive data

- ...:

  query paramaters. See
  <https://api.ecopi.de/api/v0.2/aggregations/projects/%7Bproject_name%7D/recorders/%7Brecorder_field_id%7D/time_series>

## Value

A list of meta information of the api request and a dataframe of the
counts of detections for a specified project, recorder number and
interval (stored in the list "\$result"):
<https://api.ecopi.de/api/docs/#tag/v0.2/operation/v0.2_aggregations_projects_recorders_time_series_retrieve>.

## Examples

``` r
# Retrieve a count of detections for a every 5 minutes from recorder 1 in the PAM chemitz project. (default )
if (FALSE) { # \dontrun{
get_aggregations_project_recorder_time_series(project_name = "pam_in_chemnitz", recorder_field_id = 1, interval_unit = "minute", interval_size = 5)
} # }

# $results
```
