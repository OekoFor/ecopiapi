# Get project info.

Wrapper around the 'projects_retrieve' endpoint to retrieve information
about a specific project.

## Usage

``` r
get_project_info(project_name, get_response = FALSE)
```

## Arguments

- project_name:

  Name of the project.

- get_response:

  Logical. If TRUE, returns a list containing both the original response
  and the data frame.

## Value

If get_response is FALSE (default), returns a list containing
information about the specified project. If get_response is TRUE,
returns a list with 'data' (the project info) and 'response' (the
original API response).

## Details

This function retrieves information about a specific project, based on
the project name provided in the 'project_name' parameter.

## Examples

``` r
# Retrieve information about the '017_neeri' project
if (FALSE) { # \dontrun{
get_project_info(project_name = "017_neeri")
} # }
```
