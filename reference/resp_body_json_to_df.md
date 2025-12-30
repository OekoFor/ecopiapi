# Convert API Response Body to Data Frame

This function takes an API response object and converts its JSON body to
a data frame if the response contains a body. If the response does not
contain a body, a warning is issued with the response status code.

## Usage

``` r
resp_body_json_to_df(api_response, get_response = FALSE)
```

## Arguments

- api_response:

  Response object from the API, expected to be of class
  `httr2_response`.

- get_response:

  Logical. If TRUE, returns a list containing both the original response
  and the data frame.

## Value

If get_response is FALSE (default), returns a data frame containing the
JSON content of the response body if it exists; otherwise, `NULL`. If
get_response is TRUE, returns a list with two elements: `data` (the data
frame) and `response` (the original API response).

## Examples

``` r
if (FALSE) { # interactive()
response <- ecopi_api("GET /detections/", params = list("project" = "017_neeri"))
resp_body_json_to_df(response)
}
```
