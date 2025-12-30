# Get detections retrieve.

Wrapper around the 'Retrieve Detections' endpoint to retrieve a single
detection based on uid

## Usage

``` r
get_detections_retrieve(id_or_uid, get_response = FALSE)
```

## Arguments

- id_or_uid:

  The database ID or UID of the respective detection

- get_response:

  Logical. If TRUE, returns a list containing both the original response
  and the data frame.

## Value

If get_response is FALSE (default), returns a list containing the
detection. If get_response is TRUE, returns a list with 'data' (the
detection data) and 'response' (the original API response).

## Examples

``` r
# Retrieve a single detection for a specific uid
get_detections_retrieve(id_or_uid = "64733fbc-7cc8-49f6-adf1-c9ec2d676959")
#> Error in get_ecopiapi_key(): No key found
```
