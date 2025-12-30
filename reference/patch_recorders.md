# PATCH recorder.

Wrapper around the 'recorders_partial_update' endpoint to update
recorders parameters based on the specified body schema.

## Usage

``` r
patch_recorders(..., recorder_name, file_path)
```

## Arguments

- ...:

  query paramaters. See
  <https://api.ecopi.de/api/docs/#tag/v0.2/operation/v0.2_recorders_partial_update>.

- recorder_name:

  The name of the recorder to update information from.

- file_path:

  Path to file to upload (Watchout! If file_path given, new_data gets
  ignored (cannot patch multiple types)).

## Value

httr2_response

## Examples

``` r
# Update the parameter description of the recorder 00041aefd7jgg1014
if (FALSE) { # \dontrun{
patch_recorders(recorder_name = "008041aefd7ee1015", description = "This a recorder ...", lat = 48)
} # }
# OR with image
if (FALSE) { # \dontrun{
patch_recorders(recorder_name = "00041aefd7jgg1014", description = "Teeeest ...", lat = 48, file_path = "/sample_path/sample.jpeg")
} # }
```
