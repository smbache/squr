#' Prepare Value for an SQL Query
#'
#' @details \code{NA}s are converted to NULL, other values are coerced to character representation
#'  with \code{as.character}, and non-numeric and non-NULL values are (single) quoted. Lists
#'  are wrapped in parentheses and values are separated with commas. The \code{quote} parameter
#'  is useful for dynamically specifying e.g. columns, or table names.
#'
#' @param value A value to be used in an SQL query.
#' @param quote The character to be used to quote the (non-numeric) value(s).
#'   For brackets, use the opening bracket.
#' @return character: A character representation appropriate for SQL queries.
#'
#' @export
sq_value <- function(value, quote = "'")
{
  if (inherits(value, "sq_value"))
    return(value)

  right_quote <- switch(quote, "(" = ")", "{" = "}", "[" = "]", quote)

  if (is.list(value)) {
    out <- paste0("(", paste(vapply(value, sq_value, character(1), quote = quote), collapse = ","), ")")
  } else {
    out <- rep("NULL", length(value))
    if (is.numeric(value)) {
      out[!is.na(value)] <- as.character(value)
    } else {
      out[!is.na(value)] <- paste0(quote, as.character(value), right_quote)
    }
  }

  structure(out, class = c("sq_value", "character"))
}
