# Get historical projects list.

Wrapper around the 'historicalprojects_list' endpoint to retrieve a list
of historical projects based on the specified query parameters.

## Usage

``` r
get_historicalprojects(..., get_response = FALSE)
```

## Arguments

- ...:

  query paramaters. See
  <https://api.ecopi.de/api/docs/#tag/v0.2/operation/v0.2_historicalprojects_list>

- get_response:

  Logical. If TRUE, returns a list containing both the original response
  and the data frame.

## Value

If get_response is FALSE (default), returns a data frame containing the
historical projects. If get_response is TRUE, returns a list with 'data'
(the data frame) and 'response' (the original API response).

## Examples

``` r
# retrieve a dataframe of all historical projects
if (FALSE) { # \dontrun{
get_historicalprojects()
} # }

# Retrieve a list of projects that contain 'red_panda' or 'green_banana' in their name
if (FALSE) { # \dontrun{
get_historicalprojects(project_name__in = c("pam_in_chemnitz"))
} # }
```
