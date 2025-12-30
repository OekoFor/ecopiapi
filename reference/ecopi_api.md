# Make API requests to the Ecopi API

This function sends an API request to the Ecopi API with the specified
resource, parameters, and optional arguments.

## Usage

``` r
ecopi_api(
  resource,
  ...,
  params = list(),
  new_data = list(),
  file_path,
  base_url = getOption("ecopiapi.base_url", "https://api.ecopi.de/api/v0.2")
)
```

## Arguments

- resource:

  A character string specifying the API resource to request.

- ...:

  Path parameters, that point to a specific resource, to be passed to
  the req_template() function.

- params:

  Query parameters that modify the reuqest.

- new_data:

  A named list of parameters to be updated/ patched.

- file_path:

  A path currently only important to patch an image to a recorder
  endpoint (Watchout! If file_path given, new_data gets ignored (cannot
  patch multiple types)).

## Value

A `response` object from the httr2 package containing the API response.

## Examples

``` r
if (FALSE) { # \dontrun{
# Send a request to the 'detections' endpoint. Only get detections in the project '017_neeri'
response <- ecopi_api("GET /detections/", params = list("project" = "017_neeri"))
} # }
```
