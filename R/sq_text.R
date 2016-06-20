#' Inline SQL Query
#'
#' @param text A character SQL query.
#'
#' @return An \code{sq} object.
#'
#' @export
sq_text <- function(text)
{
  if (!is_scalar_character(text))
    stop("Argument 'text' should be a scalar character value")

  structure(text, class = "sq")
}
