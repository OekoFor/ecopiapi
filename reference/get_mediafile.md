# Get media file.

Wrapper around the 'detections_media_retrieve' endpoint to retrieve a
media file from a detection.

## Usage

``` r
get_mediafile(uid)
```

## Arguments

- uid:

  uid of that specifiy detection. See
  <https://api.ecopi.de/api/docs/#tag/v0.2/operation/v0.2_detections_media_retrieve>

## Value

object of type "httr2_response". contains raw data in body (currently
audio or image)

## Examples

``` r
if (FALSE) { # \dontrun{
get_mediafile("c8c155f9-c05b-4e86-b842-88b80829e36c")
} # }
```
