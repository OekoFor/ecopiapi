#' Extract error message from JSON body of an HTTP response
#'
#' @param resp An HTTP response object.
#' @return A named character vector representing the flattened JSON content of the HTTP response body.
#' @examples
#' \dontrun{
#' # Assuming an HTTP response object 'response' with a JSON error body
#' error_body <- ecopi_error_body(response)
#' }
#' @export
ecopi_error_body <- function(resp) {
  resp |>
    httr2::resp_body_json() |>
    unlist()
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
#' # Send a request to the 'detections' endpoint. Only get detections in the project '017_neeri'
#' response <- ecopi_api("GET /detections/", params = list("project" = "017_neeri"))
#'
#' #
#' }
#' @import httr2
#' @export

ecopi_api <- function(resource, ..., params = list()) {
  request("https://api.ecopi.de/api/v0.1") |>
    req_headers(Authorization = paste("Token", get_ecopiapi_key())) |>
    req_user_agent("ecopiapi") |>
    req_error(body = ecopi_error_body) |>
    req_template(resource, ...) |>
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
#' \dontrun{
#' response <- ecopi_api("GET /detections/", params = list("project" = "017_neeri"))
#' resp_body_json_to_df(response)
#' }
#' @importFrom httr2 resp_body_json
resp_body_json_to_df <- function(api_response) {
  api_response |>
    resp_body_json(simplifyVector = TRUE)
  # |>
  #   data.table::rbindlist(fill = TRUE) |>
  #   tibble::as_tibble()
}


# Detections ------------------------------------------------------------------------------------------------------


#' Get detections list.
#'
#' Wrapper around the 'ListView Detections' endpoint to retrieve a list of detections based on the specified query parameters.
#'
#' @param ... query paramaters. See \url(https://api.ecopi.de/api/v0.1/docs/#operation/detections_list)
#'
#' @examples
#' # Retrieve a list of detections for project '017_neeri' that occurred in March (month=3)
#' get_detections_list(project_name = "017_neeri", datetime__month = 3)
#'
#' @return A data.frame containing the detections that match the specified query parameters: \url(https://api.ecopi.de/api/v0.1/docs/#operation/detections_list)
#'
#' @export
get_detections <- function(...) {
  params = list(...)
  ecopi_api("GET /detections/", params = params) |>
    resp_body_json_to_df()
}

#' Get media file.
#'
#' Wrapper around the 'MediaFile Detection' endpoint to retrieve a media file from a detection.
#'
#' @param uid uid of that specifiy detection. See \url(https://api.ecopi.de/api/v0.1/docs/#operation/detections_media_read)
#'
#' @examples
#' get_mediafile("c8c155f9-c05b-4e86-b842-88b80829e36c")
#'
#' @return object of type "httr2_response". contains raw audio in body
#'
#' @export
get_mediafile <- function(uid) {
  ecopi_api("GET /detections/media/{uid}", uid = uid)
}


# Recordings ------------------------------------------------------------------------------------------------------


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


# Projects --------------------------------------------------------------------------------------------------------


#' Get projects list.
#'
#' Wrapper around the 'projects_list' endpoint to retrieve a list of projects based on the specified query parameters.
#'
#' @param params A list of key-value pairs representing the query parameters to be sent with the API request.
#'
#' @examples
#' # retrieve a list of all projects
#' get_projects_list()
#'
#' # Retrieve a list of projects that contain 'red_panda' or 'green_banana' in their name
#' get_projects_list(params = list("project_name__in" = "red_panda, green_banana"))
#'
#' @details
#' The 'params' parameter is a list of key-value pairs that represent the query parameters to be sent with the API request.
#' Each key represents a query parameter, and each value represents the value of the query parameter.
#' For example, to retrieve projects that contain a specific string in their name, you can set the 'name__contains' parameter to the string to search for.
#' The available query parameters are documented in the EcoPi API documentation: \url{https://api.ecopi.de/api/docs/#operation/projects_list}.
#'
#' @return A tibble containing the projects that match the specified query parameters: \url{https://api.ecopi.de/api/docs/#operation/projects_list}.
#'
#' @export
get_projects_list <- function(params = list()) {
  ecopi_api("GET /projects/", params = params) |>
    resp_body_json_to_df()
}


#' Get project info.
#'
#' Wrapper around the 'projects_read' endpoint to retrieve information about a specific project.
#'
#' @param project_name The name of the project to retrieve information about.
#'
#' @examples
#' # Retrieve information about the '017_neeri' project
#' get_project_info(project_name = "017_neeri")
#'
#' @details
#' This function retrieves information about a specific project, based on the project name provided in the 'project_name' parameter.
#' The available information about a project is documented in the EcoPi API documentation: \url{https://api.ecopi.de/api/docs/#operation/projects_read}.
#'
#' @return A list containing information about the specified project: \url{https://api.ecopi.de/api/docs/#operation/projects_read}.
#'
#' @export
get_project_info <- function(project_name) {
  ecopi_api("GET /projects/{project_name}/",
            project_name = project_name) |>
    resp_body_json_to_df()
}



# recordergroups --------------------------------------------------------------------------------------------------

#' Get recorder groups list.
#'
#' Wrapper around the 'recordergroups_list' endpoint to retrieve a list of recorder groups based on the specified query parameters.
#' This contains the configurations and species list
#'
#' @param params A list of key-value pairs representing the query parameters to be sent with the API request.
#'
#' @examples
#' # Retrieve a list of recorder groups for project 'oekofor'
#' get_recordergroups_list(params = list("project_name" = "oekofor"))
#'
#' @details
#' The 'params' parameter is a list of key-value pairs that represent the query parameters to be sent with the API request.
#' Each key represents a query parameter, and each value represents the value of the query parameter.
#' For example, to retrieve recorder groups for a specific project, you can set the 'project_name' parameter to the name of the project.
#' The available query parameters are documented in the EcoPi API documentation: \url{https://api.ecopi.de/api/docs/#operation/recordergroups_list}.
#'
#' @return A list containing the recorder groups that match the specified query parameters: \url{https://api.ecopi.de/api/docs/#operation/recordergroups_list}.
#'
#' @export
get_recordergroups_list <- function(params = list()) {
  ecopi_api("GET /recordergroups/", params = params) |>
    resp_body_json_to_df()
}


#' Get recorder group info.
#'
#' Wrapper around the 'recordergroups_read' endpoint to retrieve information about a specific recorder group.
#'
#' @param project_name The name of the project that the recorder group belongs to.
#' @param recordergroup_name The name of the recorder group to retrieve information about.
#'
#' @examples
#' # Retrieve information about the 'default' recorder group for project 'oekofor'
#' get_recordergroup_info(project_name = "oekofor", recordergroup_name = "default")
#'
#' @details
#' This function retrieves information about a specific recorder group, based on the project name and recorder group name provided in the 'project_name' and 'recordergroup_name' parameters, respectively.
#' The available information about a recorder group is documented in the EcoPi API documentation: \url{https://api.ecopi.de/api/docs/#operation/recordergroups_read}.
#'
#' @return A list containing information about the specified recorder group: \url{https://api.ecopi.de/api/docs/#operation/recordergroups_read}.
#'
#' @export
get_recordergroup_info <-
  function(project_name, recordergroup_name) {
    ecopi_api(
      "GET /recordergroups/{project_name}/{recordergroup_name}/",
      project_name = project_name,
      recordergroup_name = recordergroup_name
    ) |>
      resp_body_json_to_df()
  }


# Logs ------------------------------------------------------------------------------------------------------------

#' Get recorder logs list.
#'
#' Wrapper around the 'recorderlogs_list' endpoint to retrieve a list of recorder logs based on the specified query parameters.
#'
#' @param params A list of key-value pairs representing the query parameters to be sent with the API request.
#'
#' @examples
#' # Retrieve a list of recorder logs for project '017_neeri'
#' get_recorder_logs_list(params = list("project_name" = "017_neeri"))
#'
#' @details
#' The 'params' parameter is a list of key-value pairs that represent the query parameters to be sent with the API request.
#' Each key represents a query parameter, and each value represents the value of the query parameter.
#' For example, to retrieve recorder logs for a specific project, you can set the 'project_name' parameter to the name of the project.
#' The available query parameters are documented in the EcoPi API documentation: \url{https://api.ecopi.de/api/docs/#operation/recorderlogs_list}.
#'
#' @return A tibble containing the recorder logs that match the specified query parameters: \url{https://api.ecopi.de/api/docs/#operation/recorderlogs_list}.
#'
#' @export
get_recorder_logs_list <- function(params = list()) {
  ecopi_api("GET /recorderlogs/", params = params) |>
    resp_body_json_to_df()
}

#' Get recorder log info.
#'
#' Wrapper around the 'recorderlogs_read' endpoint to retrieve information about a specific recorder log.
#'
#' @param recorder_name The name of the recorder to retrieve information about.
#'
#' @examples
#' # Retrieve information about the recorder log for recorder '00000000d76d0bf9'
#' get_recorder_log_info(recorder_name = "00000000d76d0bf9")
#'
#' @details
#' This function retrieves information about a specific recorder log, based on the recorder name provided in the 'recorder_name' parameter.
#' The available information about a recorder log is documented in the EcoPi API documentation: \url{https://api.ecopi.de/api/docs/#operation/recorderlogs_read}.
#'
#' @return A list containing information about the specified recorder log: \url{https://api.ecopi.de/api/docs/#operation/recorderlogs_read}.
#'
#' @export
get_recorder_log_info <- function(recorder_name) {
  ecopi_api("GET /recorderlogs/{recorder_name}/",
            recorder_name = recorder_name) |>
    resp_body_json_to_df()
}



# Recorders -------------------------------------------------------------------------------------------------------

#' Get recorders list.
#'
#' Wrapper around the 'recorders_list' endpoint to retrieve a list of recorders based on the specified query parameters.
#'
#' @param params A list of key-value pairs representing the query parameters to be sent with the API request.
#'
#' @examples
#' # Retrieve a list of recorders for project '017_neeri'
#' get_recorders_list(params = list("project_name" = "017_neeri"))
#'
#' @details
#' The 'params' parameter is a list of key-value pairs that represent the query parameters to be sent with the API request.
#' Each key represents a query parameter, and each value represents the value of the query parameter.
#' For example, to retrieve recorders for a specific project, you can set the 'project_name' parameter to the name of the project.
#' The available query parameters are documented in the EcoPi API documentation: \url{https://api.ecopi.de/api/docs/#operation/recorders_list}.
#'
#' @return A list containing the recorders that match the specified query parameters: \url{https://api.ecopi.de/api/docs/#operation/recorders_list}.
#'
#' @export
get_recorders_list <- function(params = list()) {
  ecopi_api("GET /recorders/", params = params) |>
    resp_body_json_to_df()
}

#' Get recorder info.
#'
#' Wrapper around the 'recorders_read' endpoint to retrieve information about a specific recorder.
#'
#' @param recorder_name The name of the recorder to retrieve information about.
#'
#' @examples
#' # Retrieve information about the recorder '00000000d76d0bf9'
#' get_recorder_info(recorder_name = "00000000d76d0bf9")
#'
#' @details
#' This function retrieves information about a specific recorder, based on the recorder name provided in the 'recorder_name' parameter.
#' The available information about a recorder is documented in the EcoPi API documentation: \url{https://api.ecopi.de/api/docs/#operation/recorders_read}.
#'
#' @return A list containing information about the specified recorder: \url{https://api.ecopi.de/api/docs/#operation/recorders_read}.
#'
#' @export
get_recorder_info <- function(recorder_name) {
  ecopi_api("GET /recorders/{recorder_name}/",
            recorder_name = recorder_name) |>
    resp_body_json_to_df()
}



# Recorderstates --------------------------------------------------------------------------------------------------
#' Get recorder states list.
#'
#' Wrapper around the 'recorderstates_list' endpoint to retrieve a list of recorder states based on the specified query parameters.
#'
#' @param params A list of key-value pairs representing the query parameters to be sent with the API request.
#'
#' @examples
#'
#' # Retrieve all recorder states
#' get_recorder_states_list()
#'
#' # Retrieve a list of recorder states for recorder '00000000d76d0bf9'
#' get_recorder_states_list(params = list("recorder_name" = "00000000d76d0bf9"))
#'
#' @details
#' The 'params' parameter is a list of key-value pairs that represent the query parameters to be sent with the API request.
#' Each key represents a query parameter, and each value represents the value of the query parameter.
#' For example, to retrieve recorder states for a specific recorder, you can set the 'recorder_name' parameter to the name of the recorder.
#' The available query parameters are documented in the EcoPi API documentation: \url{https://api.ecopi.de/api/docs/#operation/recorderstates_list}.
#'
#' @return A tibble containing the recorder states that match the specified query parameters: \url{https://api.ecopi.de/api/docs/#operation/recorderstates_list}.
#'
#' @export
get_recorder_states_list <- function(params = list()) {
  ecopi_api("GET /recorderstates/", params = params) |>
    resp_body_json_to_df()
}


#' Get latest recorder states.
#'
#' Wrapper around the 'recorderstates_recorder_read' endpoint to retrieve the latest recorder states for a specific recorder.
#'
#' @param recorder_name The name of the recorder to retrieve the latest states for.
#' @param latest The number of latest recorder states to retrieve (default is 100).
#'
#' @examples
#' # Retrieve the latest 100 recorder states for recorder '00000000d76d0bf9'
#' get_latest_recorder_states(recorder_name = "00000000d76d0bf9")
#'
#' # Retrieve the latest 50 recorder states for recorder '00000000d76d0bf9'
#' get_latest_recorder_states(recorder_name = "00000000d76d0bf9", latest = 50)
#'
#' @details
#' This function retrieves the latest recorder states for a specific recorder, based on the recorder name provided in the 'recorder_name' parameter.
#' The available information about recorder states is documented in the EcoPi API documentation: \url{https://api.ecopi.de/api/docs/#operation/recorderstates_recorder_read}.
#'
#' @return A tibble containing the latest recorder states for the specified recorder: \url{https://api.ecopi.de/api/docs/#operation/recorderstates_recorder_read}.
#'
#' @export
get_latest_recorder_states <-
  function(recorder_name, latest = 100) {
    ecopi_api(
      "GET /recorderstates/latest{latest}/recorder/{recorder_name}/",
      recorder_name = recorder_name,
      latest = latest
    ) |>
      resp_body_json_to_df()
  }
