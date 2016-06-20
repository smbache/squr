#' Parameterize Insert Parameters
#'
#' @param .query An \code{sq} query object.
#' @param .label the insert block label.
#' @param .path see \code{sq_file}. As alternative to a path, one can
#'   also supply an \code{sq} object directly, which is used as is.
#'
#' @details The values will be prepared with \code{sq_value}
#'
#' @export
sq_set_include <- function(.query, .label, .path)
{
  include <- `if`(inherits(.path, "sq"), .path, sq_file(.path))

  pattern <- paste0("@", .label, ":include(?![[:alnum:]_#\\$\\@:])")

  result <- gsub(pattern, include, .query, perl = TRUE)

  sq_text(result)
}
