# Get projects list.

Wrapper around the 'projects_list' endpoint to retrieve a list of
projects based on the specified query parameters.

## Usage

``` r
get_projects(..., get_response = FALSE)
```

## Arguments

- ...:

  query paramaters. See
  <https://api.ecopi.de/api/docs/#tag/v0.2/operation/v0.2_projects_list>

- get_response:

  Logical. If TRUE, returns a list containing both the original response
  and the data frame.

## Value

If get_response is FALSE (default), returns a data frame containing the
projects. If get_response is TRUE, returns a list with 'data' (the data
frame) and 'response' (the original API response).

## Examples

``` r
# retrieve a dataframe of all projects
if (FALSE) { # \dontrun{
get_projects()
} # }

# Retrieve a list of projects that contain 'red_panda' or 'green_banana' in their name
if (FALSE) { # \dontrun{
get_projects(project_name__in = "red_panda, green_banana")
} # }
```
