#' Set API key as an environment variable
#'
#' This function sets an API key as an environment variable using a provided key name and key value.
#' If the key value is not provided, the user will be prompted to enter it.
#'
#' @param api_key_name A character string specifying the name of the API key.
#' @param api_key A character string specifying the value of the API key. If not provided, the user will be prompted to enter it.
#' @return NULL. The function sets the API key as an environment variable and does not return a value.
#' @examples
#' \dontrun{
#' # Set an API key with a name 'API_KEY' and a value 'your_api_key'
#' set_api_key(api_key_name = "API_KEY", api_key = "your_api_key")
#' }
#' @export
set_api_key <- function(api_key_name = NULL,
                        api_key = NULL) {
  if (is.null(api_key_name)) {
    stop("Please provide a key name")
  }
  if (is.null(api_key)) {
    api_key <- askpass::askpass("Please enter your API key")
  }

  # Create a named list with the API key name as the name and the API key as the value
  env_value <- list(api_key)
  names(env_value) <- toupper(api_key_name)

  # Set the environment variable using the named list
  do.call(Sys.setenv, env_value)
}


#' Retrieve API key from environment variables
#'
#' This function retrieves the value of an API key from the environment variables by its name.
#'
#' @param api_key_name A character string specifying the name of the API key. Default is "API_KEY".
#' @return A character string representing the value of the API key.
#' @examples
#' \dontrun{
#' # Retrieve the value of an API key named 'API_KEY'
#' api_key_value <- get_api_key("API_KEY")
#' }
#' @export
get_api_key <- function(api_key_name = "API_KEY") {
  key <- Sys.getenv(api_key_name)
  if (identical(key, "")) {
    stop("No key found")
  }
  key
}
