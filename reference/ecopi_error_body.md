# Extract error message from JSON body of an HTTP response

Extract error message from JSON body of an HTTP response

## Usage

``` r
ecopi_error_body(resp)
```

## Arguments

- resp:

  An HTTP response object.

## Value

A named character vector representing the flattened JSON content of the
HTTP response body.

## Examples

``` r
if (FALSE) { # \dontrun{
# Assuming an HTTP response object 'response' with a JSON error body
error_body <- ecopi_error_body(response)
} # }
```
