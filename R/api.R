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
#' @param new_data A named list of parameters to be updated/ patched.
#' @param file_path A path currently only important to patch an image to a recorder endpoint.
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


ecopi_api <- function(resource, ..., params = list(), new_data = list(), file_path) {
  params <- lapply(params, paste, collapse = ",")
  new_data <- lapply(new_data, paste, collapse = ",")
  req <- request("https://api.ecopi.de/api/v0.1") |>
    req_headers(Authorization = paste("Token", get_ecopiapi_key())) |>
    req_user_agent("ecopiapi") |>
    req_error(body = ecopi_error_body) |>
    req_template(resource, ...) |>
    req_url_query(!!!params) |>
    req_body_json(new_data) # neu eungefügt, wichtig für PATCH Funktionen

  if (missing(file_path)) {
    req_perform(req)
  } else {
    req <- req_body_multipart(req, image = curl::form_file(file_path))
    req_perform(req)
  } # neu eungefügt, wichtig für PATCH Funktionen
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
#' get_detections(project_name = "017_neeri", datetime__month = 3)
#'
#' @return A data.frame containing the detections that match the specified query parameters: \url(https://api.ecopi.de/api/v0.1/docs/#operation/detections_list)
#'
#' @export
get_detections <- function(...) {
  params <- list(...)
  ecopi_api("GET /detections/", params = params) |>
    resp_body_json_to_df()
}



#' PATCH detection
#'
#' Wrapper around the 'ListView Detections' endpoint to update detections parameters based on the specified query parameters.
#'
#' @param ... query paramaters. See \url(https://api.ecopi.de/api/v0.1/docs/#operation/detections_list)
#'
#' @examples
#' # Update the parameter confirmed of an example detection
#' patch_detections(id_or_uid = "64733fbc-7cc8-49f6-adf1-c9ec2d676959", confirmed = "yes")
#'
#' @return httr2_response
#'
#' @export

patch_detections <- function(..., id_or_uid, new_data) {
  # params <- list(...)
  new_data <- list(...)
  ecopi_api("PATCH /detections/{id_or_uid}/", id_or_uid = id_or_uid, new_data = new_data)
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
#' @return object of type "httr2_response". contains raw data in body (currently audio or image)
#'
#' @export
get_mediafile <- function(uid) {
  ecopi_api("GET /detections/media/{uid}", uid = uid)
}


# Recordings ------------------------------------------------------------------------------------------------------


#' Get recordings list.
#'
#' Wrapper around the 'ListView Recordings' endpoint to retrieve a dataframe of recordings based on the specified query parameters.
#'
#' @param ... query paramaters. See \url(https://api.ecopi.de/api/v0.1/docs/#operation/recordings_list)
#'
#'
#' @examples
#' # Retrieve a list of recordings for project '017_neeri' that occurred in March (month=3)
#' get_recordings(project_name = "017_neeri", datetime__month = 3)
#'
#' @return A data.frame containing the recordings that match the specified query parameters: \url(https://api.ecopi.de/api/v0.1/docs/#operation/recordings_list)
#'
#' @export
get_recordings <- function(...) {
  params <- list(...)
  ecopi_api("GET /recordings/", params = params) |>
    resp_body_json_to_df()
}


# Projects --------------------------------------------------------------------------------------------------------


#' Get projects list.
#'
#' Wrapper around the 'ListView Projects' endpoint to retrieve a list of projects based on the specified query parameters.
#'
#' @param ... query paramaters. See \url(https://api.ecopi.de/api/v0.1/docs/#operation/projects_list)
#'
#' @examples
#' # retrieve a dataframe of all projects
#' get_projects()
#'
#' # Retrieve a list of projects that contain 'red_panda' or 'green_banana' in their name
#' get_projects(project_name__in = "red_panda, green_banana")
#'
#' @return A dataframe containing the projects that match the specified query parameters: \url{https://api.ecopi.de/api/v0.1/docs/#operation/projects_list}.
#'
#' @export
get_projects <- function(...) {
  params <- list(...)
  ecopi_api("GET /projects/", params = params) |>
    resp_body_json_to_df()
}


#' Get project info.
#'
#' Wrapper around the 'projects_read' endpoint to retrieve information about a specific project.
#'
#' @param ... query paramaters. See \url{https://api.ecopi.de/api/docs/#operation/projects_read}.
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
    project_name = project_name
  ) |>
    resp_body_json_to_df()
}



# recordergroups --------------------------------------------------------------------------------------------------

#' Get recorder groups list.
#'
#' Wrapper around the 'ListView RecorderGroups' endpoint to retrieve a list of recorder groups based on the specified query parameters.
#' This contains the configurations and species list
#'
#' @param ... query paramaters. See \url{https://api.ecopi.de/api/v0.1/docs/#operation/recordergroups_list}.
#'
#' @examples
#' # Retrieve a data frame of recorder groups for project 'oekofor'
#' get_recordergroups(project_name = "oekofor")
#'
#' @return A list containing the recorder groups that match the specified query parameters: \url{https://api.ecopi.de/api/v0.1/docs/#operation/recordergroups_list}.
#'
#' @export
get_recordergroups <- function(...) {
  params <- list(...)
  ecopi_api("GET /recordergroups/", params = params) |>
    resp_body_json_to_df()
}


#' PATCH recordergroups
#'
#' Wrapper around the 'DetailView RecorderGroup' endpoint to update recordergroups parameters based on the specified query parameters.
#'
#' @param ... query paramaters. See \url(https://api.ecopi.de/api/v0.1/docs/#operation/detections_list)
#'
#' @examples
#' # Update the parameter confirmed of an example detection
#' patch_recordergroups(id = "44", description="patch test")
#'
#' @return httr2_response
#'
#' @export

patch_recordergroups <- function(..., id, new_data) {
  # params <- list(...)
  new_data <- list(...)
  ecopi_api("PATCH /recordergroups/{id}/", id= id, new_data = new_data)
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
# get_recordergroup_info <-
#   function(project_name, recordergroup_name) {
#     ecopi_api(
#       "GET /recordergroups/{project_name}/{recordergroup_name}/",
#       project_name = project_name,
#       recordergroup_name = recordergroup_name
#     ) |>
#       resp_body_json_to_df()
#   }


# Logs ------------------------------------------------------------------------------------------------------------

#' Get recorder logs list.
#'
#' Wrapper around the 'ListView RecorderLogs' endpoint to retrieve a list of recorder logs based on the specified query parameters.
#'
#' @param ... query paramaters. See \url{https://api.ecopi.de/api/v0.1/docs/#tag/recorderlogs}.
#'
#'
#' @examples
#' # Retrieve a dataframe of recorder logs for project '017_neeri'
#' get_recorderlogs(project_name = "017_neeri")
#'
#' @return A dataframe containing the recorder logs that match the specified query parameters: \url{https://api.ecopi.de/api/v0.1/docs/#tag/recorderlogs}.
#'
#' @export
get_recorderlogs <- function(...) {
  params <- list(...)
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
#' get_recorderlog_info(recorder_name = "00000000d76d0bf9")
#'
#' @details
#' This function retrieves information about a specific recorder log, based on the recorder name provided in the 'recorder_name' parameter.
#' The available information about a recorder log is documented in the EcoPi API documentation: \url{https://api.ecopi.de/api/docs/#operation/recorderlogs_read}.
#'
#' @return A list containing information about the specified recorder log: \url{https://api.ecopi.de/api/docs/#operation/recorderlogs_read}.
#'
#' @export
# get_recorder_log_info <- function(recorder_name) {
#   ecopi_api("GET /recorderlogs/{recorder_name}/",
#     recorder_name = recorder_name
#   ) |>
#     resp_body_json_to_df()
# }



# Recorders -------------------------------------------------------------------------------------------------------

#' Get recorders list.
#'
#' Wrapper around the 'ListView Recorders' endpoint to retrieve a list of recorders based on the specified query parameters.
#'
#' @param ... query paramaters. See \url{https://api.ecopi.de/api/v0.1/docs/#operation/recorders_list}.
#'
#' @examples
#' # Retrieve a list of recorders for project '017_neeri'
#' get_recorders(project_name = "017_neerach_ried")
#'
#' @return A dataframe containing the recorders that match the specified query parameters: \url{https://api.ecopi.de/api/v0.1/docs/#operation/recorders_list}.
#'
#' @export
get_recorders <- function(...) {
  params <- list(...)
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
#' get_recorderinfo(recorder_name = "00000000d76d0bf9")
#'
#' @details
#' This function retrieves information about a specific recorder, based on the recorder name provided in the 'recorder_name' parameter.
#' The available information about a recorder is documented in the EcoPi API documentation: \url{https://api.ecopi.de/api/docs/#operation/recorders_read}.
#'
#' @return A list containing information about the specified recorder: \url{https://api.ecopi.de/api/docs/#operation/recorders_read}.
#'
#' @export
# get_recorder_info <- function(recorder_name) {
#   ecopi_api("GET /recorders/{recorder_name}/",
#     recorder_name = recorder_name
#   ) |>
#     resp_body_json_to_df()
# }




#' PATCH recorder parameters.
#'
#' Wrapper around the 'DetailView Recorder' endpoint to update recorders parameters based on the specified body schema.
#'
#' @param ... query paramaters. See \url{https://api.ecopi.de/api/v0.1/docs/#operation/recorders_partial_update}.
#' @param recorder_name The name of the recorder to update information from.
#'
#' @examples
#' # Update the parameter description of the recorder 00041aefd7jgg1014
#' patch_recorders(recorder_name = "008041aefd7ee1015", description = "This a recorder ...", lat = 48)
#' # OR with image
#' patch_recorders(recorder_name = "00041aefd7jgg1014", description = "Teeeest ...", lat = 48, file_path = "/sample_path/sample.jpeg")
#'
#' @return httr2_response
#'
#' @export

patch_recorders <- function(..., recorder_name, new_data, file_path) {
  # params = list(...)
  new_data <- list(...)
  ecopi_api("PATCH /recorders/{recorder_name}/", recorder_name = recorder_name, new_data = new_data, file_path = file_path)
}



# Recorderstates --------------------------------------------------------------------------------------------------
#' Get recorder states list.
#'
#' Wrapper around the 'ListView RecorderStates' endpoint to retrieve a list of recorder states based on the specified query parameters.
#'
#' @param ... query paramaters. See \url{https://api.ecopi.de/api/v0.1/docs/#operation/recorderstates_list}
#'
#' @examples
#' # Retrieve all recorder states
#' get_recorderstates()
#'
#' # Retrieve a list of recorder states for recorder '00000000d76d0bf9'
#' get_recorderstates(recorder_name = "00000000d76d0bf9")
#'
#' @return A dataframe containing the recorder states that match the specified query parameters: \url{https://api.ecopi.de/api/docs/#operation/recorderstates_list}.
#'
#' @export
get_recorderstates <- function(...) {
  params <- list(...)
  ecopi_api("GET /recorderstates/", params = params) |>
    resp_body_json_to_df()
}


# Summaryfiles --------------------------------------------------------------------------------------------------
#' Get summary files of detections.
#'
#' Wrapper around the 'Summary of species counts per recorder within a project' endpoint to retrieve a count of species detections for each recorder in a given project.
#'
#' @param ... query paramaters. See \url{https://api.ecopi.de/api/v0.1/docs/#tag/meta}
#'
#' @examples
#' # Retrieve a summary of species counts per recorder within a project
#' get_recorderstates()
#'
#' # Retrieve a list of recorder states for recorder '00000000d76d0bf9'
#' get_summary(project_name = "039_zitro")
#'
#' @return A summary containing species counts per recorder within a project that match the specified query parameters: \url{https://api.ecopi.de/api/v0.1/docs/#tag/meta}.
#'
#' @export
get_recorderspeciescounts <- function(project_name, ...) {
  params <- list(...)
  ecopi_api("GET /meta/project/{project_name}/detections/recorderspeciescounts/", project_name = project_name, params = params) |>
    resp_body_json_to_df()
}
