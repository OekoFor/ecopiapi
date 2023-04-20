#' Retrieve API key from environment variables
#'
#' This function retrieves the value of an API key from the environment variables by its name.
#' The name must be "ECOPI_API_KEY"
#'
#' @return A character string representing the value of the API key.
#' @noRd
get_ecopiapi_key <- function() {
  key <- Sys.getenv("ECOPI_API_KEY")
  if (identical(key, "")) {
    stop("No key found")
  }
  key
}
