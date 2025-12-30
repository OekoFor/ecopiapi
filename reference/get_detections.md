# Get detections list.

Wrapper around the 'detections_list' endpoint to retrieve a list of
detections based on the specified query parameters.

## Usage

``` r
get_detections(..., get_response = FALSE)
```

## Arguments

- ...:

  query paramaters. See
  <https://api.ecopi.de/api/docs/#tag/v0.2/operation/v0.2_detections_list>

- get_response:

  Logical. If TRUE, returns a list containing both the original response
  and the data frame.

## Value

If get_response is FALSE (default), returns a data frame containing the
detections. If get_response is TRUE, returns a list with 'data' (the
data frame) and 'response' (the original API response).

## Examples

``` r
# Retrieve a list of detections for project '017_neeri' that occurred in March (month=3)
if (FALSE) { # \dontrun{
get_detections(project_name = "017_neeri", datetime__month = 3)
} # }
```
