#' Wrapper for vapply
#'
#' @param values An iterable object
#' @param f A function returning scalar character
#' @param ... Further arguments for vapply
#'
#' @noRd
map_character <- function(values, f = as.character, ...)
{
  vapply(values, f, character(1), ...)
}

#' Wrapper for vapply
#'
#' @param values An iterable object
#' @param f A function returning scalar integer
#' @param ... Further arguments for vapply
#'
#' @noRd
map_integer <- function(values, f = as.integer, ...)
{
  vapply(values, f, integer(1), ...)
}
