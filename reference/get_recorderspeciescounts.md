# Get a count of detections per species and recorder for a specific project.

Wrapper around the
'meta_project_detections_recorderspeciescounts_retrieve' endpoint to
retrieve a count of species detections for each recorder in a given
project.

## Usage

``` r
get_recorderspeciescounts(
  project_name,
  include_validation_status = FALSE,
  ...,
  get_response = FALSE
)
```

## Arguments

- project_name:

  Name of the project to get a count on detetcions class and recorder

- include_validation_status:

  Boolean to include validation status in the response

- ...:

  query paramaters. See
  <https://api.ecopi.de/api/docs/#tag/v0.2/operation/v0.2_meta_project_detections_recorderspeciescounts_retrieve>

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
get_recorderspeciescounts(project_name = "pam_in_chemnitz")
} # }
# You can specify a start_date and end_date to get a count for specific time interval.
# Limit 'countable' detections by setting a confidence threshold
if (FALSE) { # \dontrun{
get_recorderspeciescounts(project_name = "pam_in_chemnitz", start_date = "2023-01-01", end_date = "2023-12-31", min_confidence = 0.85)
} # }
```
