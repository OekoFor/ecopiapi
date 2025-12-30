# Get a count of detections per recorder grouped by given parameters.

Wrapper around the 'aggregations_project_recorders_count_detections'
endpoint to retrieve a count of detections for each recorder and grouped
by the specified query parameters.

## Usage

``` r
get_recorders_count_detections(project_name, ..., get_response = FALSE)
```

## Arguments

- project_name:

  Name of the project to get a count on detetcions class and recorder

- ...:

  query paramaters. See
  <http://192.168.10.30:8001/api/docs/#tag/v0.2/operation/v0.2_aggregations_project_recorder_recordings_count_detections_retrieve>

- get_response:

  Logical. If TRUE, returns a list containing both the original response
  and the data frame.

## Value

If get_response is FALSE (default), returns a summary containing species
counts per recorder. If get_response is TRUE, returns a list with 'data'
(the summary) and 'response' (the original API response).

## Examples

``` r
# Retrieve a count pre species and recorders. By default, the count is returned for today
if (FALSE) { # \dontrun{
get_recorders_count_detections(project_name = "pam_in_chemnitz")
} # }
# You can specify a start_date and end_date to get a count for specific time interval.
# Limit 'countable' detections by setting a confidence threshold
if (FALSE) { # \dontrun{
get_recorders_count_detections(project_name = "pam_in_chemnitz", start_datetime = "2023-01-01", end_datetime = "2023-12-31", min_confidence = 0.85)
} # }
```
