# PATCH detection

Wrapper around the 'detections_partial_update' endpoint to update
detections parameters based on the specified query parameters.

## Usage

``` r
patch_detections(..., id_or_uid, file_path)
```

## Arguments

- ...:

  query paramaters. See
  <https://api.ecopi.de/api/docs/#tag/v0.2/operation/v0.2_detections_partial_update>

- id_or_uid:

  The database ID or UID of the respective detection

- file_path:

  Path to file to upload (Watchout! If file_path given, new_data gets
  ignored (cannot patch multiple types)).

## Value

httr2_response

## Examples

``` r
# Update the parameter confirmed of an example detection
if (FALSE) { # \dontrun{
patch_detections(id_or_uid = "64733fbc-7cc8-49f6-adf1-c9ec2d676959", confirmed = "YES")
} # }
```
