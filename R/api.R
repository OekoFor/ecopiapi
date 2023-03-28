#' Extract error message from JSON body of an HTTP response
#'
#' @param resp An HTTP response object.
#' @return A named character vector representing the flattened JSON content of the HTTP response body.
#' @examples
#' \dontrun{
#'   # Assuming an HTTP response object 'response' with a JSON error body
#'   error_body <- ecopi_error_body(response)
#' }
#' @export
ecopi_error_body <- function(resp) {
  resp |> httr2::resp_body_json()  |>  unlist()
}


#' Make API requests to the Ecopi API
#'
#' This function sends an API request to the Ecopi API with the specified resource, parameters, and optional arguments.
#'
#' @param resource A character string specifying the API resource to request.
#' @param ... Additional arguments to be passed to the req_template() function.
#' @param params A named list of query parameters to include in the request.
#' @return A `response` object from the httr2 package containing the API response.
#' @examples
#' \dontrun{
#'   # Send a request to the 'detections' endpoint. Only get detections in the project '017_neeri'
#'   response <- ecopi_api("GET /detections/", params = list("project" = "017_neeri"))
#'
#'   #
#' }
#' @import httr2
#' @export

ecopi_api <- function(resource, ..., params = list()) {
  request("https://api.ecopi.de/api/") |>
    req_headers(Authorization = paste("Token", get_api_key())) |>
    req_user_agent("ecopiapi") |>
    req_error(body = ecopi_error_body) |>
    req_template(resource, ...)  |>
    req_url_query(!!!params) |>
    req_perform()
}

#' Convert response body to data frame
#'
#' @param api_response Response from API
#'
#' @return Data frame
#' @export
#' @examples
#' response <- ecopi_api("example", params = list(param1 = "value1"))
#' resp_body_json_to_df(response)
#' @importFrom httr2 resp_body_json
resp_body_json_to_df <- function(api_response) {
  api_response |>
    resp_body_json() |>
    data.table::rbindlist() |>
    tibble::as_tibble()
}

