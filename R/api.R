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
    data.table::rbindlist(fill = TRUE) |>
    tibble::as_tibble()
}


#' Get detections list.
#'
#' Wrapper around the 'detections_list' endpoint to retrieve a list of detections based on the specified query parameters.
#'
#' @param params A list of key-value pairs representing the query parameters to be sent with the API request.
#'
#' @examples
#' # Retrieve a list of detections for project '017_neeri' that occurred in March (month=3)
#' get_detections_list(params = list("project_name" = "017_neeri", "datetime__month" = 3))
#'
#' @details
#' The 'params' parameter is a list of key-value pairs that represent the query parameters to be sent with the API request.
#' Each key represents a query parameter, and each value represents the value of the query parameter.
#' For example, to retrieve detections for a specific project, you can set the 'project_name' parameter to the name of the project.
#' The available query parameters are documented in the EcoPi API documentation: \url(https://api.ecopi.de/api/docs/#operation/detections_list).
#'
#' @return A tibble containing the detections that match the specified query parameters: \url(https://api.ecopi.de/api/docs/#operation/detections_list)
#'
#' @export
get_detections_list <- function(params = list()) {
  ecopi_api("GET /detections/", params = params) |>
    resp_body_json_to_df()
}

#' Get latest detections.
#'
#' Wrapper around the 'detections_read' endpoint to retrieve the latest detections.
#'
#' @param latest A numeric value indicating the number of latest detections to return (default 100).
#'
#' @return A tibble containing the latest detections.
#' @export
#'
#' @examples
#' # Get the latest 100 detections
#' get_latest_detections()
#'
#' # Get the latest 50 detections
#' get_latest_detections(50)
get_latest_detections <- function(latest = 100) {
  ecopi_api("GET /detections/latest{latest}", latest = latest) |>
    resp_body_json_to_df()
}


#' Get latest detections by project name.
#'
#' Wrapper around the 'detections_project_read' endpoint to retrieve the latest detections for a specific project.
#'
#' @param latest A numeric value indicating the number of latest detections to return (default 100).
#' @param project_name A character value indicating the name of the project to retrieve detections for.
#'
#' @return A tibble containing the latest detections for the specified project.
#' @export
#'
#' @examples
#' # Get the latest 100 detections for a project named 'my_project'
#' get_latest_detections_by_project(project_name = 'my_project')
#'
#' # Get the latest 50 detections for a project named 'my_project'
#' get_latest_detections_by_project(latest = 50, project_name = 'my_project')
get_latest_detections_by_project <-
  function(latest = 100, project_name) {
    ecopi_api(
      "GET /detections/latest{latest}/project/{project_name}/",
      latest = latest,
      project_name = project_name
    ) |>
      resp_body_json_to_df()
  }


#' Get latest detections by recorder name.
#'
#' Wrapper around the 'detections_recorder_read' endpoint to retrieve the latest detections for a specific recorder.
#'
#' @param latest A numeric value indicating the number of latest detections to return (default 100).
#' @param recorder_name A character value indicating the name of the recorder to retrieve detections for.
#'
#' @return A tibble containing the latest detections for the specified recorder.
#' @export
#'
#' @examples
#' # Get the latest 100 detections for a recorder named 'my_recorder'
#' get_latest_detections_by_recorder(recorder_name = 'my_recorder')
#'
#' # Get the latest 50 detections for a recorder named 'my_recorder'
#' get_latest_detections_by_recorder(latest = 50, recorder_name = 'my_recorder')
get_latest_detections_by_recorder <-
  function(latest = 100, recorder_name) {
    ecopi_api(
      "GET /detections/latest{latest}/recorder/{recorder_name}/",
      latest = latest,
      recorder_name = recorder_name
    ) |>
      resp_body_json_to_df()
  }

#' Get latest detections by recorder group.
#'
#' Wrapper around the 'detections_recordergroup_read' endpoint to retrieve the latest detections for a specific recorder group.
#'
#' @param latest A numeric value indicating the number of latest detections to return (default 100).
#' @param project_name A character value indicating the name of the project to retrieve detections for.
#' @param recordergroup_name A character value indicating the name of the recorder group to retrieve detections for. Default is 'default'.
#'
#' @return A tibble containing the latest detections for the specified recorder group.
#' @export
#'
#' @examples
#' # Get the latest 100 detections for the default recorder group in project 'my_project'
#' get_latest_detections_by_recordergroup(project_name = 'my_project')
#'
#' # Get the latest 50 detections for a recorder group named 'my_group' in project 'my_project'
#' get_latest_detections_by_recordergroup(latest = 50, project_name = 'my_project', recordergroup_name = 'my_group')
get_latest_detections_by_recordergroup <-
  function(latest = 100,
           project_name,
           recordergroup_name = 'default') {
    ecopi_api(
      "GET /detections/latest{latest}/recordergroup/{project_name}/{recordergroup_name}/",
      latest = latest,
      project_name = project_name,
      recordergroup_name = recordergroup_name
    ) |>
      resp_body_json_to_df()
  }


#' Get recordings list.
#'
#' Wrapper around the 'recordings_list' endpoint to retrieve a list of recordings based on the specified query parameters.
#'
#' @param params A list of key-value pairs representing the query parameters to be sent with the API request.
#'
#' @examples
#' # Retrieve a list of recordings for project '017_neeri' that occurred in March (month=3)
#' get_recordings_list(params = list("project_name" = "017_neeri", "datetime__month" = 3))
#'
#' @details
#' The 'params' parameter is a list of key-value pairs that represent the query parameters to be sent with the API request.
#' Each key represents a query parameter, and each value represents the value of the query parameter.
#' For example, to retrieve recordings for a specific project, you can set the 'project_name' parameter to the name of the project.
#' The available query parameters are documented in the EcoPi API documentation: \url{https://api.ecopi.de/api/docs/#tag/recordings_list}.
#'
#' @return A tibble containing the recordings that match the specified query parameters: \url{https://api.ecopi.de/api/docs/#tag/recordings_list}.
#'
#' @export
get_recordings_list <- function(params = list()) {
  ecopi_api("GET /recordings/", params = params) |>
    resp_body_json_to_df()
}
