# Post a new detection

Wrapper around the 'detections_create' endpoint. If you want to create a
new detection and include a media file, you need to do it in two steps.
First create the detection using `post_detection()` and then upload the
mediafile with
[`patch_detections()`](https://oekofor.github.io/ecopiapi/reference/patch_detections.md)
TIP: Assigning your own uuid before posting makes it easier to patch a
file.

## Usage

``` r
post_detection(...)
```

## Arguments

- ...:

  Find required parameters here
  <https://api.ecopi.de/api/docs/#tag/v0.2/operation/v0.2_detections_create>

## Value

httr2_response

## Examples

``` r
if (FALSE) { # \dontrun{
post_detection(
  recorder_name = "000000002e611dde",
  datetime = lubridate::now() |> lubridate::with_tz(tzone = "UTC") |> format("%Y-%m-%dT%H:%M:%S") |> paste0("Z") |> as.character(), # lubridate::now(tzone = "UTC") |> format("%Y-%m-%dT%H:%M:%S%Z") |> as.character(), # "2019-08-24T14:15:22Z",
  start = 1,
  end = 4,
  species_code = "Frosch",
  confidence = -1
)
} # }
```
