# Get a count of detections per project by default and per group(s) if specified.

Wrapper around the 'aggregations_project_detections_count' endpoint to
retrieve a count of detections for each project and per group(s) if
specified.

## Usage

``` r
get_aggregations_project_detections_count(
  project_name,
  ...,
  get_response = FALSE
)
```

## Arguments

- project_name:

  Name of the project to get a count on detetcions

- ...:

  query paramaters. See
  <https://api.ecopi.de/api/v0.2/aggregations/projects/%7Bproject_name%7D/detections_count>

- get_response:

  Logical. If TRUE, returns a list containing both the original response
  and the data frame.

## Value

If get_response is FALSE (default), returns a list of meta information
and a dataframe of the counts of detections. If get_response is TRUE,
returns a list with 'data' (the counts information) and 'response' (the
original API response).

## Examples

``` r
# Retrieve a count of detections for a specific project
if (FALSE) { # \dontrun{
get_aggregations_project_detections_count(project_name = "pam_in_chemnitz")
} # }
# Retrieve a count of detections for a specific project per specified group(s), here in the example per recorder and species
if (FALSE) { # \dontrun{
get_aggregations_project_detections_count(project_name = "pam_in_chemnitz", group_by = "recorder_field_id,scientific_name")
} # }
```
