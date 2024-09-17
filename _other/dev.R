#' Get recorder group info.
#'
#' Wrapper around the 'recordergroups_retrieve' endpoint to retrieve information about a specific recorder group.
#' @noRd
#' @param project_name The name of the project that the recorder group belongs to.
#' @param recordergroup_name The name of the recorder group to retrieve information about.
#'
#' @examples
#' # Retrieve information about the 'default' recorder group for project 'oekofor'
#' \dontrun{get_recordergroup_info(project_name = "oekofor", recordergroup_name = "default")}
#'
#' @details
#' This function retrieves information about a specific recorder group, based on the project name and recorder group name provided in the 'project_name' and 'recordergroup_name' parameters, respectively.
#' The available information about a recorder group is documented in the EcoPi API documentation: \url{https://api.ecopi.de/api/docs/#operation/recordergroups_read}.
#'
#' @return A list containing information about the specified recorder group: \url{https://api.ecopi.de/api/docs/#operation/recordergroups_read}.
#'
#' TODO export function
# get_recordergroup_info <-
#   function(project_name, recordergroup_name) {
#     ecopi_api(
#       "GET /recordergroups/{project_name}/{recordergroup_name}/",
#       project_name = project_name,
#       recordergroup_name = recordergroup_name
#     ) |>
#       resp_body_json_to_df()
#   }

#' Get recorder log info.
#'
#' Wrapper around the 'recorderlogs_read' endpoint to retrieve information about a specific recorder log.
#' @noRd
#' @param recorder_name The name of the recorder to retrieve information about.
#'
#' @examples
#' # Retrieve information about the recorder log for recorder '00000000d76d0bf9'
#' \dontrun{get_recorderlog_info(recorder_name = "00000000d76d0bf9")}
#'
#' @details
#' This function retrieves information about a specific recorder log, based on the recorder name provided in the 'recorder_name' parameter.
#' The available information about a recorder log is documented in the EcoPi API documentation: \url{https://api.ecopi.de/api/docs/#tag/v0.1/operation/v0.1_recorderlogs_retrieve}.
#'
#' @return A list containing information about the specified recorder log: \url{https://api.ecopi.de/api/docs/#tag/v0.1/operation/v0.1_recorderlogs_retrieve}.
#'
#' TODO export function
#' # get_recorder_log_info <- function(recorder_name) {#   ecopi_api("GET /recorderlogs/{recorder_name}/",#     recorder_name = recorder_name#   ) |>#     resp_body_json_to_df()#


#' Get recorder info.
#'
#' Wrapper around the 'recorders_read' endpoint to retrieve information about a specific recorder.
#' @noRd

#' @param recorder_name The name of the recorder to retrieve information about.
#'
#' @examples
#' # Retrieve information about the recorder '00000000d76d0bf9'
#' \dontrun{get_recorderinfo(recorder_name = "00000000d76d0bf9")}
#'
#' @details
#' This function retrieves information about a specific recorder, based on the recorder name provided in the 'recorder_name' parameter.
#' The available information about a recorder is documented in the EcoPi API documentation: \url{https://api.ecopi.de/api/docs/#operation/recorders_read}.
#'
#' @return A list containing information about the specified recorder: \url{https://api.ecopi.de/api/docs/#operation/recorders_read}.
#'
#' TODO export function
# get_recorder_info <- function(recorder_name) {
#   ecopi_api("GET /recorders/{recorder_name}/",
#     recorder_name = recorder_name
#   ) |>
#     resp_body_json_to_df()
# }
