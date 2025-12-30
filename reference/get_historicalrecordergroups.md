# Get historical recorder groups list.

Wrapper around the 'historicalrecordergroups_list' endpoint to retrieve
a list of recorder groups based on the specified query parameters. This
contains the configurations and species list

## Usage

``` r
get_historicalrecordergroups(..., get_response = FALSE)
```

## Arguments

- ...:

  query paramaters. See
  <https://api.ecopi.de/api/docs/#tag/v0.2/operation/v0.2_historicalrecordergroups_list>.

- get_response:

  Logical. If TRUE, returns a list containing both the original response
  and the data frame.

## Value

If get_response is FALSE (default), returns a list containing the
historical recorder groups. If get_response is TRUE, returns a list with
'data' (the historical recorder groups) and 'response' (the original API
response).

## Examples

``` r
# Retrieve a data frame of historical recorder groups for project 'oekofor'
if (FALSE) { # \dontrun{
get_historicalrecordergroups(project_name = "oekofor")
} # }
```
