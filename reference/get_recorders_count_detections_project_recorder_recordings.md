# Get a count of detections per recorder grouped by rerecording.

Wrapper around the
'aggregations_project_recorders_count_detections_project_recorder_recordings'
endpoint to retrieve a count of detections for each recorder and grouped
by recording.

## Usage

``` r
get_recorders_count_detections_project_recorder_recordings(
  project_name,
  recorder_field_id,
  ...,
  get_response = FALSE
)
```

## Arguments

- project_name:

  Name of the project to get a count on detetcions class and recorder

- recorder_field_id:

  Recorder field ID

- ...:

  query paramaters. See
  <https://api.ecopi.de/api/docs/#tag/v0.2/operation/v0.2_aggregations_projects_recorders_recordings_count_detections_retrieve>

- get_response:

  Logical. If TRUE, returns a list containing both the original response
  and the data frame.

## Value

If get_response is FALSE (default), returns a summary containing species
counts per recorder per recording. If get_response is TRUE, returns a
list with 'data' (the summary) and 'response' (the original API
response).

## Examples

``` r
# Retrieve a count of detections for each ecoPi at each recording. (Project x , with 3 ecoPi'S is scheduled to record at 10 times per day. I want to extract a count of detections for each ecoPi and each scheduled recording session )
if (FALSE) { # \dontrun{
get_recorders_count_detections_project_recorder_recordings(project_name = "pam_in_chemnitz", recorder_field_id = 1)
} # }
```
