#' Infer if Call is Made From Package
#'
#' @return logical
#' @noRd
is_packaged <- function()
{
  exists(".packageName", calling_env(), mode = "character", inherits = TRUE)
}

#' Get Package Name
#'
#' Find the name of the first non-squr package.
#' If not packaged, an empty character value is returned.
#'
#' @return logical
#' @noRd
package_name <- function()
{
  tryCatch(get(".packageName", envir    = calling_env(),
                               mode     = "character",
                               inherits = TRUE),
           error = function(e) character(0)
  )
}
