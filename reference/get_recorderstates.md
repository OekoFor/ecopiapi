# Get recorder states list.

Wrapper around the 'recorderstates_list' endpoint to retrieve a list of
recorder states based on the specified query parameters.

## Usage

``` r
get_recorderstates(..., get_response = FALSE)
```

## Arguments

- ...:

  query paramaters. See
  <https://api.ecopi.de/api/docs/#tag/v0.2/operation/v0.2_recorderstates_list>

- get_response:

  Logical. If TRUE, returns a list containing both the original response
  and the data frame.

## Value

If get_response is FALSE (default), returns a data frame containing the
recorder states. If get_response is TRUE, returns a list with 'data'
(the data frame) and 'response' (the original API response).

## Examples

``` r
# Retrieve all recorder states
if (FALSE) { # \dontrun{
get_recorderstates()
} # }

# Retrieve a list of recorder states for recorder '00000000d76d0bf9'
if (FALSE) { # \dontrun{
get_recorderstates(recorder_name = "00000000d76d0bf9")
} # }
```
