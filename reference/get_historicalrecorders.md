# Get historical recorders list.

Wrapper around the 'historicalrecorders_list' endpoint to get a list of
recorders based on the specified query parameters.

## Usage

``` r
get_historicalrecorders(..., get_response = FALSE)
```

## Arguments

- ...:

  query paramaters. See
  <https://api.ecopi.de/api/docs/#tag/v0.2/operation/v0.2_historicalrecorders_list>.

- get_response:

  Logical. If TRUE, returns a list containing both the original response
  and the data frame.

## Value

If get_response is FALSE (default), returns a data frame containing the
historical recorders. If get_response is TRUE, returns a list with
'data' (the data frame) and 'response' (the original API response).

## Examples

``` r
# Retrieve a list of historical recorders for project '017_neeri'
if (FALSE) { # \dontrun{
get_historicalrecorders(project_name = "pam_in_chemnitz")
} # }
```
