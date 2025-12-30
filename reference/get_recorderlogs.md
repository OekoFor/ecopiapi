# Get recorder logs list.

Wrapper around the 'recorderlogs_list' endpoint to retrieve a list of
recorder logs based on the specified query parameters.

## Usage

``` r
get_recorderlogs(..., get_response = FALSE)
```

## Arguments

- ...:

  query paramaters. See
  <https://api.ecopi.de/api/docs/#tag/v0.2/operation/v0.2_recorderlogs_list>.

- get_response:

  Logical. If TRUE, returns a list containing both the original response
  and the data frame.

## Value

If get_response is FALSE (default), returns a data frame containing the
recorder logs. If get_response is TRUE, returns a list with 'data' (the
data frame) and 'response' (the original API response).

## Examples

``` r
# Retrieve a dataframe of recorder logs for project '017_neeri'
if (FALSE) { # \dontrun{
get_recorderlogs(project_name = "pam_in_chemnitz")
} # }
```
