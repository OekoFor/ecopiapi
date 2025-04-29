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
#' @param ... Path parameters, that point to a specific resource, to be passed to the req_template() function.
#' @param params Query parameters that modify the reuqest.
#' @param new_data A named list of parameters to be updated/ patched.
#' @param file_path A path currently only important to patch an image to a recorder endpoint (Watchout! If file_path given, new_data gets ignored (cannot patch multiple types)).
#' @return A `response` object from the httr2 package containing the API response.
#' @examples
#' \dontrun{
#' # Send a request to the 'detections' endpoint. Only get detections in the project '017_neeri'
#' response <- ecopi_api("GET /detections/", params = list("project" = "017_neeri"))
#' }
#' @import httr2
#' @export
ecopi_api <- function(resource, ...,
                      params = list(),
                      new_data = list(),
                      file_path,
                      base_url = getOption("ecopiapi.base_url", "https://api.ecopi.de/api/v0.2")) {
  params <- lapply(params, paste, collapse = ",")
  new_data <- lapply(new_data, function(x) if (identical(x, "")) jsonlite::unbox(NULL) else paste(x, collapse = ","))

  if (!missing(file_path) && length(unlist(new_data)) > 0) {
    warning("The 'new_data' parameter is ignored when 'file_path' is provided.")
  }

  req <- request(base_url) |>
    req_headers(Authorization = paste("Token", get_ecopiapi_key())) |>
    req_user_agent("ecopiapi") |>
    req_error(body = ecopi_error_body) |>
    req_template(resource, ...) |>
    req_url_query(!!!params)

  if (missing(file_path)) {
    req <- req_body_json(req, new_data)
    req_perform(req)
  } else {
    req <- req_body_multipart(req, image = curl::form_file(file_path))
    req_perform(req)
  }
}


#' Convert API Response Body to Data Frame
#'
#' This function takes an API response object and converts its JSON body to a data frame if the response contains a body. If the response does not contain a body, a warning is issued with the response status code.
#'
#' @param api_response Response object from the API, expected to be of class `httr2_response`.
#'
#' @return A data frame containing the JSON content of the response body if it exists; otherwise, `NULL`.
#' @export
#' @examplesIf interactive()
#' response <- ecopi_api("GET /detections/", params = list("project" = "017_neeri"))
#' resp_body_json_to_df(response)
#'
#' @importFrom httr2 resp_body_json
#' @importFrom httr2 resp_status
#' @importFrom httr2 resp_has_body
resp_body_json_to_df <- function(api_response) {
  resp_body_not_empty <- resp_has_body(api_response)
  if (resp_body_not_empty) {
    api_response |>
      resp_body_json(simplifyVector = TRUE)
  } else {
    warning("The response does not contain a body. Status code: ", resp_status(api_response))
    NULL
  }
}

# Detections ------------------------------------------------------------------------------------------------------


#' Get detections list.
#'
#' Wrapper around the 'detections_list' endpoint to retrieve a list of detections based on the specified query parameters.
#'
#' @param ... query paramaters. See \url{https://api.ecopi.de/api/docs/#tag/v0.2/operation/v0.2_detections_list}
#'
#' @examples
#' # Retrieve a list of detections for project '017_neeri' that occurred in March (month=3)
#' \dontrun{
#' get_detections(project_name = "017_neeri", datetime__month = 3)
#' }
#'
#' @return A data.frame containing the detections that match the specified query parameters: \url{https://api.ecopi.de/api/docs/#tag/v0.2/operation/v0.2_detections_list}
#'
#' @export
get_detections <- function(...) {
  params <- list(...)
  ecopi_api("GET /detections/", params = params) |>
    resp_body_json_to_df()
}


#' Get detections retrieve.
#'
#' Wrapper around the 'Retrieve Detections' endpoint to retrieve a single detection based on uid
#'
#' @param id_or_uid The database ID or UID of the respective detection
#'
#' @examples
#' # Retrieve a single detection for a specific uid
#' get_detections_retrieve(id_or_uid = "64733fbc-7cc8-49f6-adf1-c9ec2d676959")
#'
#' @return A list containing the detection that match the specified query parameters: \url{https://api.ecopi.de/api/v0.2/docsco/#operation/detections_list}
#'
#' @export
get_detections_retrieve <- function(id_or_uid) {
  ecopi_api("GET /detections/{id_or_uid}/", id_or_uid = id_or_uid) |>
    resp_body_json_to_df()
}



#' Post a new detection
#'
#' Wrapper around the 'detections_create' endpoint.
#' If you want to create a new detection and include a media file, you need to do it in two steps.
#' First create the detection using `post_detection()` and then upload the mediafile with `patch_detections()`
#' TIP: Assigning your own uuid before posting makes it easier to patch a file.
#'
#' @param ... Find required parameters here \url{https://api.ecopi.de/api/docs/#tag/v0.2/operation/v0.2_detections_create}
#'
#' @examples
#' \dontrun{
#' post_detection(
#'   recorder_name = "000000002e611dde",
#'   datetime = lubridate::now() |> lubridate::with_tz(tzone = "UTC") |> format("%Y-%m-%dT%H:%M:%S") |> paste0("Z") |> as.character(), # lubridate::now(tzone = "UTC") |> format("%Y-%m-%dT%H:%M:%S%Z") |> as.character(), # "2019-08-24T14:15:22Z",
#'   start = 1,
#'   end = 4,
#'   species_code = "Frosch",
#'   confidence = -1
#' )
#' }
#' @return httr2_response
#' @export
post_detection <- function(...) {
  params <- list(...)
  ecopi_api("POST /detections/", new_data = params)
}


#' PATCH detection
#'
#' Wrapper around the 'detections_partial_update' endpoint to update detections parameters based on the specified query parameters.
#'
#' @param ... query paramaters. See \url{https://api.ecopi.de/api/docs/#tag/v0.2/operation/v0.2_detections_partial_update}
#' @param id_or_uid The database ID or UID of the respective detection
#' @param file_path Path to file to upload (Watchout! If file_path given, new_data gets ignored (cannot patch multiple types)).
#'
#' @examples
#' # Update the parameter confirmed of an example detection
#' \dontrun{
#' patch_detections(id_or_uid = "64733fbc-7cc8-49f6-adf1-c9ec2d676959", confirmed = "YES")
#' }
#'
#' @return httr2_response
#'
#' @export

patch_detections <- function(..., id_or_uid, file_path) {
  params <- list(...)
  # important to make emppty/ blank comments (i.o.w. deleting old comments)
  if ("comment" %in% names(params) && params[["comment"]] == "") {
    params[["comment"]] <- "" # Explicit empty string for 'comment'
  }
  ecopi_api("PATCH /detections/{id_or_uid}/", id_or_uid = id_or_uid, new_data = params, file_path = file_path)
}



#' Get media file.
#'
#' Wrapper around the 'detections_media_retrieve' endpoint to retrieve a media file from a detection.
#'
#' @param uid uid of that specifiy detection. See \url{https://api.ecopi.de/api/docs/#tag/v0.2/operation/v0.2_detections_media_retrieve}
#'
#' @examples
#' \dontrun{
#' get_mediafile("c8c155f9-c05b-4e86-b842-88b80829e36c")
#' }
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
#' Wrapper around the 'recordings_list' endpoint to retrieve a dataframe of recordings based on the specified query parameters.
#'
#' @param ... query paramaters. See \url{https://api.ecopi.de/api/docs/#tag/v0.2/operation/v0.2_recordings_list}
#'
#'
#' @examples
#' # Retrieve a list of recordings for project '017_neeri' that occurred in March (month=3)
#' \dontrun{
#' get_recordings(project_name = "017_neeri", datetime__month = 3)
#' }
#'
#' @return A data.frame containing the recordings that match the specified query parameters: \url{https://api.ecopi.de/api/docs/#tag/v0.2/operation/v0.2_recordings_list}
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
#' Wrapper around the 'projects_list' endpoint to retrieve a list of projects based on the specified query parameters.
#'
#' @param ... query paramaters. See \url{https://api.ecopi.de/api/docs/#tag/v0.2/operation/v0.2_projects_list}
#'
#' @examples
#' # retrieve a dataframe of all projects
#' \dontrun{
#' get_projects()
#' }
#'
#' # Retrieve a list of projects that contain 'red_panda' or 'green_banana' in their name
#' \dontrun{
#' get_projects(project_name__in = "red_panda, green_banana")
#' }
#'
#' @return A dataframe containing the projects that match the specified query parameters: \url{https://api.ecopi.de/api/docs/#tag/v0.2/operation/v0.2_projects_list}.
#'
#' @export
get_projects <- function(...) {
  params <- list(...)
  ecopi_api("GET /projects/", params = params) |>
    resp_body_json_to_df()
}


#' Get historical projects list.
#'
#' Wrapper around the 'historicalprojects_list' endpoint to retrieve a list of historical projects based on the specified query parameters.
#'
#' @param ... query paramaters. See \url{https://api.ecopi.de/api/docs/#tag/v0.2/operation/v0.2_historicalprojects_list}
#'
#' @examples
#' # retrieve a dataframe of all historical projects
#' \dontrun{
#' get_historicalprojects()
#' }
#'
#' # Retrieve a list of projects that contain 'red_panda' or 'green_banana' in their name
#' \dontrun{
#' get_historicalprojects(project_name__in = c("pam_in_chemnitz"))
#' }
#'
#' @return A dataframe containing the historical projects that match the specified query parameters: \url{https://api.ecopi.de/api/docs/#tag/v0.2/operation/v0.2_historicalprojects_list}.
#'
#' @export
get_historicalprojects <- function(...) {
  params <- list(...)
  ecopi_api("GET /historicalprojects/", params = params) |>
    resp_body_json_to_df()
}


#' Get project info.
#'
#' Wrapper around the 'projects_retrieve' endpoint to retrieve information about a specific project.
#'
#' @param project_name Name of the project.
#'
#' @examples
#' # Retrieve information about the '017_neeri' project
#' \dontrun{
#' get_project_info(project_name = "017_neeri")
#' }
#'
#' @details
#' This function retrieves information about a specific project, based on the project name provided in the 'project_name' parameter.
#'
#' @return A list containing information about the specified project: \url{https://api.ecopi.de/api/docs/#tag/v0.2/operation/v0.2_projects_list}.
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
#' Wrapper around the 'recordergroups_list' endpoint to retrieve a list of recorder groups based on the specified query parameters.
#' This contains the configurations and species list
#'
#' @param ... query paramaters. Leave empty to get all recordergroups. See \url{https://api.ecopi.de/api/docs/#tag/v0.2/operation/v0.2_recordergroups_list}.
#'
#' @examples
#' # Retrieve a data frame of recorder groups for project 'oekofor'
#' \dontrun{
#' get_recordergroups(project_name = "oekofor")
#' }
#'
#' @return A list containing the recorder groups that match the specified query parameters: \url{https://api.ecopi.de/api/docs/#tag/v0.2/operation/v0.2_recordergroups_list}.
#'
#' @export
get_recordergroups <- function(...) {
  params <- list(...)
  ecopi_api("GET /recordergroups/", params = params) |>
    resp_body_json_to_df()
}


#' Get historical recorder groups list.
#'
#' Wrapper around the 'historicalrecordergroups_list' endpoint to retrieve a list of recorder groups based on the specified query parameters.
#' This contains the configurations and species list
#'
#' @param ... query paramaters. See \url{https://api.ecopi.de/api/docs/#tag/v0.2/operation/v0.2_historicalrecordergroups_list}.
#'
#' @examples
#' # Retrieve a data frame of historical recorder groups for project 'oekofor'
#' \dontrun{
#' get_historicalrecordergroups(project_name = "oekofor")
#' }
#'
#' @return A list containing the historical recorder groups that match the specified query parameters: \url{https://api.ecopi.de/api/docs/#tag/v0.2/operation/v0.2_historicalrecordergroups_list}.
#'
#' @export
get_historicalrecordergroups <- function(...) {
  params <- list(...)
  ecopi_api("GET /historicalrecordergroups/", params = params) |>
    resp_body_json_to_df()
}



# Logs ------------------------------------------------------------------------------------------------------------

#' Get recorder logs list.
#'
#' Wrapper around the 'recorderlogs_list' endpoint to retrieve a list of recorder logs based on the specified query parameters.
#'
#' @param ... query paramaters. See \url{https://api.ecopi.de/api/docs/#tag/v0.2/operation/v0.2_recorderlogs_list}.
#'
#'
#' @examples
#' # Retrieve a dataframe of recorder logs for project '017_neeri'
#' \dontrun{
#' get_recorderlogs(project_name = "pam_in_chemnitz")
#' }
#'
#' @return A dataframe containing the recorder logs that match the specified query parameters: \url{https://api.ecopi.de/api/docs/#tag/v0.2/operation/v0.2_recorderlogs_list}.
#'
#' @export
get_recorderlogs <- function(...) {
  params <- list(...)
  ecopi_api("GET /recorderlogs/", params = params) |>
    resp_body_json_to_df()
}


# Recorders -------------------------------------------------------------------------------------------------------

#' Get recorders list.
#'
#' Wrapper around the 'recorders_list' endpoint to retrieve a list of recorders based on the specified query parameters.
#'
#' @param ... query paramaters. See \url{https://api.ecopi.de/api/docs/#tag/v0.2/operation/v0.2_recorders_list}.
#'
#' @examples
#' # Retrieve a list of recorders for project '017_neeri'
#' \dontrun{
#' get_recorders(project_name = "017_neerach_ried")
#' }
#'
#' @return A dataframe containing the recorders that match the specified query parameters: \url{https://api.ecopi.de/api/docs/#tag/v0.2/operation/v0.2_recorders_list}.
#'
#' @export
get_recorders <- function(...) {
  params <- list(...)
  ecopi_api("GET /recorders/", params = params) |>
    resp_body_json_to_df()
}


#' Get historical recorders list.
#'
#' Wrapper around the 'historicalrecorders_list' endpoint to get a list of recorders based on the specified query parameters.
#'
#' @param ... query paramaters. See \url{https://api.ecopi.de/api/docs/#tag/v0.2/operation/v0.2_historicalrecorders_list}.
#'
#' @examples
#' # Retrieve a list of historical recorders for project '017_neeri'
#' \dontrun{
#' get_historicalrecorders(project_name = "pam_in_chemnitz")
#' }
#'
#' @return A dataframe containing the historical recorders that match the specified query parameters: \url{https://api.ecopi.de/api/docs/#tag/v0.2/operation/v0.2_historicalrecorders_list}.
#'
#' @export
get_historicalrecorders <- function(...) {
  params <- list(...)
  ecopi_api("GET /historicalrecorders/", params = params) |>
    resp_body_json_to_df()
}



#' PATCH recorder.
#'
#' Wrapper around the 'recorders_partial_update' endpoint to update recorders parameters based on the specified body schema.
#'
#' @param ... query paramaters. See \url{https://api.ecopi.de/api/docs/#tag/v0.2/operation/v0.2_recorders_partial_update}.
#' @param recorder_name The name of the recorder to update information from.
#' @param file_path Path to file to upload (Watchout! If file_path given, new_data gets ignored (cannot patch multiple types)).
#'
#' @examples
#' # Update the parameter description of the recorder 00041aefd7jgg1014
#' \dontrun{
#' patch_recorders(recorder_name = "008041aefd7ee1015", description = "This a recorder ...", lat = 48)
#' }
#' # OR with image
#' \dontrun{
#' patch_recorders(recorder_name = "00041aefd7jgg1014", description = "Teeeest ...", lat = 48, file_path = "/sample_path/sample.jpeg")
#' }
#'
#' @return httr2_response
#'
#' @export

patch_recorders <- function(..., recorder_name, file_path) {
  params <- list(...)
  ecopi_api("PATCH /recorders/{recorder_name}/", recorder_name = recorder_name, new_data = params, file_path = file_path)
}



# Recorderstates --------------------------------------------------------------------------------------------------
#' Get recorder states list.
#'
#' Wrapper around the 'recorderstates_list' endpoint to retrieve a list of recorder states based on the specified query parameters.
#'
#' @param ... query paramaters. See \url{https://api.ecopi.de/api/docs/#tag/v0.2/operation/v0.2_recorderstates_list}
#'
#' @examples
#' # Retrieve all recorder states
#' \dontrun{
#' get_recorderstates()
#' }
#'
#' # Retrieve a list of recorder states for recorder '00000000d76d0bf9'
#' \dontrun{
#' get_recorderstates(recorder_name = "00000000d76d0bf9")
#' }
#'
#' @return A dataframe containing the recorder states that match the specified query parameters: \url{https://api.ecopi.de/api/docs/#tag/v0.2/operation/v0.2_recorderstates_list}.
#'
#' @export
get_recorderstates <- function(...) {
  params <- list(...)
  ecopi_api("GET /recorderstates/", params = params) |>
    resp_body_json_to_df()
}


#' Get data from a linked URL endpoint (mostly provided from other gtes)
#'
#' @param full_url URL of linked endpoint
#'
#' @examples
#' # Retrieve a ecopiapp release from a linked URL
#' \dontrun{
#' get_by_url("https://api.ecopi.de/api/v0.2/releases/69/")
#' }
#'
#' @return Depends on the input. Mostly a data frame of the requested data.
#'
#' @export
get_by_url <- function(full_url, base_url = "https://api.ecopi.de/api/v0.2") {
  if (is.na(full_url) || !nzchar(full_url)) {
    warning("Empty or NA URL provided.")
    return(NULL)
  }

  # Extract the relative path after /api/v0.2/
  relative_path <- sub(paste0("^", base_url), "", full_url)
  api_path <- paste("GET", relative_path)
  message("Fetching: ", api_path) # Debugging

  tryCatch(
    {
      ecopi_api(api_path) |> resp_body_json_to_df()
    },
    error = function(e) {
      warning(sprintf("Failed to fetch data from %s: %s", full_url, e$message))
      NULL
    }
  )
}


# Aggregation endpoints --- --- ---

#' Get a count of detections per species and recorder for a specific project.
#'
#' Wrapper around the 'meta_project_detections_recorderspeciescounts_retrieve' endpoint to retrieve a count of species detections for each recorder in a given project.
#'
#' @param project_name Name of the project to get a count on detetcions class and recorder
#' @param include_validation_status Boolean to include validation status in the response
#' @param ... query paramaters. See \url{https://api.ecopi.de/api/docs/#tag/v0.2/operation/v0.2_meta_project_detections_recorderspeciescounts_retrieve}
#'
#' @examples
#' # Retrieve a count pre species and recorders. By default, the count is returned for today
#' \dontrun{
#' get_recorderspeciescounts(project_name = "pam_in_chemnitz")
#' }
#' # You can specify a start_date and end_date to get a count for specific time interval.
#' # Limit 'countable' detections by setting a confidence threshold
#' \dontrun{
#' get_recorderspeciescounts(project_name = "pam_in_chemnitz", start_date = "2023-01-01", end_date = "2023-12-31", min_confidence = 0.85)
#' }
#'
#' @return A summary containing species counts per recorder within a project that match the specified query parameters: \url{https://api.ecopi.de/api/docs/#tag/v0.2/operation/v0.2_meta_project_detections_recorderspeciescounts_retrieve}.
#'
#' @export
get_recorderspeciescounts <- function(project_name, include_validation_status = FALSE, ...) {
  params <- list(...)
  if (include_validation_status) {
    params$include_validation_status <- "true"
  }
  ecopi_api("GET /meta/project/{project_name}/detections/recorderspeciescounts/",
    project_name = project_name,
    params = params
  ) |>
    resp_body_json_to_df()
}


#' Get a count of detections per recorder grouped by given parameters.
#'
#' Wrapper around the 'aggregations_project_recorders_count_detections' endpoint to retrieve a count of detections for each recorder and grouped by the specified query parameters.
#'
#' @param project_name Name of the project to get a count on detetcions class and recorder
#' @param ... query paramaters. See \url{http://192.168.10.30:8001/api/docs/#tag/v0.2/operation/v0.2_aggregations_project_recorder_recordings_count_detections_retrieve}
#'
#' @examples
#' # Retrieve a count pre species and recorders. By default, the count is returned for today
#' \dontrun{
#' get_recorders_count_detections(project_name = "pam_in_chemnitz")
#' }
#' # You can specify a start_date and end_date to get a count for specific time interval.
#' # Limit 'countable' detections by setting a confidence threshold
#' \dontrun{
#' get_recorders_count_detections(project_name = "pam_in_chemnitz", start_datetime = "2023-01-01", end_datetime = "2023-12-31", min_confidence = 0.85)
#' }
#'
#' @return A summary containing species counts per recorder within a project that match the specified query parameters: \url{http://192.168.10.30:8001/api/docs/#tag/v0.2/operation/v0.2_aggregations_project_recorder_recordings_count_detections_retrieve}.
#'
#' @export
get_recorders_count_detections <- function(project_name, ...) {
  params <- list(...)
  ecopi_api("GET /aggregations/projects/{project_name}/recorders/count_detections",
    project_name = project_name,
    params = params
  ) |>
    resp_body_json_to_df()
}


#' Get a count of detections per recorder grouped by rerecording.
#'
#' Wrapper around the 'aggregations_project_recorders_count_detections_project_recorder_recordings' endpoint to retrieve a count of detections for each recorder and grouped by recording.
#'
#' @param project_name Name of the project to get a count on detetcions class and recorder
#' @param recorder_field_id Recorder field ID
#' @param ... query paramaters. See \url{https://api.ecopi.de/api/docs/#tag/v0.2/operation/v0.2_aggregations_projects_recorders_recordings_count_detections_retrieve}
#'
#' @examples
#' # Retrieve a count of detections for each ecoPi at each recording. (Project x , with 3 ecoPi'S is scheduled to record at 10 times per day. I want to extract a count of detections for each ecoPi and each scheduled recording session )
#' \dontrun{
#' get_recorders_count_detections_project_recorder_recordings(project_name = "pam_in_chemnitz", recorder_field_id = 1)
#' }
#'
#' @return A summary containing species counts per recorder per recording within a project that match the specified query parameters: \url{https://api.ecopi.de/api/docs/#tag/v0.2/operation/v0.2_aggregations_projects_recorders_recordings_count_detections_retrieve}.
#'
#' @export
get_recorders_count_detections_project_recorder_recordings <- function(project_name, recorder_field_id, ...) {
  params <- list(...)
  ecopi_api("GET /aggregations/projects/{project_name}/recorders/{recorder_field_id}/recordings/count_detections",
    project_name = project_name,
    recorder_field_id = recorder_field_id,
    params = params
  ) |>
    resp_body_json_to_df()
}


#' Get a count of detections per project by default and per group(s) if specified.
#'
#' Wrapper around the 'aggregations_project_detections_count' endpoint to retrieve a count of detections for each project and per group(s) if specified.
#'
#' @param project_name Name of the project to get a count on detetcions
#' @param ... query paramaters. See \url{https://api.ecopi.de/api/v0.2/aggregations/projects/{project_name}/detections_count}
#'
#' @examples
#' # Retrieve a count of detections for a specific project
#' \dontrun{
#' get_aggregations_project_detections_count(project_name = "pam_in_chemnitz")
#' }
#' # Retrieve a count of detections for a specific project per specified group(s), here in the example per recorder and species
#' \dontrun{
#' get_aggregations_project_detections_count(project_name = "pam_in_chemnitz", group_by = "recorder_field_id,scientific_name")
#' }
#'
#' @return A list of meta information of the api request and a dataframe of the counts of detections for a specified project and per specified group (stored in the list "$result"): \url{https://api.ecopi.de/api/v0.2/aggregations/projects/{project_name}/detections_count}.
#'
#' @export
get_aggregations_project_detections_count <- function(project_name, ...) {
  params <- list(...)
  ecopi_api("GET /aggregations/projects/{project_name}/detections_count",
    project_name = project_name,
    params = params
  ) |>
    resp_body_json_to_df()
}
