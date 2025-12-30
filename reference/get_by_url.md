# Get data from a linked URL endpoint (mostly provided from other gtes)

Get data from a linked URL endpoint (mostly provided from other gtes)

## Usage

``` r
get_by_url(
  full_url,
  base_url = "https://api.ecopi.de/api/v0.2",
  get_response = FALSE
)
```

## Arguments

- full_url:

  URL of linked endpoint

- get_response:

  Logical. If TRUE, returns a list containing both the original response
  and the data frame.

## Value

If get_response is FALSE (default), returns the data from the specified
URL. If get_response is TRUE, returns a list with 'data' (the retrieved
data) and 'response' (the original API response).

## Examples

``` r
# Retrieve a ecopiapp release from a linked URL
if (FALSE) { # \dontrun{
get_by_url("https://api.ecopi.de/api/v0.2/releases/69/")
} # }
```
