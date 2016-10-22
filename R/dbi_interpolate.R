#' Wrapper for DBIs sqlInterpolate
#'
#' This function uses `sqlInterpolate` to parse character values.
#' The quote par
#'
#' @param value The value to be quoted.
#' @param quote Optional quoting character to use; can be one of '[' and '"'.
#'   If this is NULL, DBI's default is used.
#' @importFrom DBI sqlInterpolate ANSI
#'
#' @noRd
dbi_interpolate <- function(value, quote = NULL)
{
  if (length(value) > 1) {
    map_character(value, dbi_interpolate)
  } else {

    right_quote <-
      if (!is.null(quote)) switch(quote, "[" = "]", '"' = '"', "'" = "'",
                                  stop("Invalid quote character."))

    out <- sqlInterpolate(ANSI(), "?value", value = value)

    if (!is.null(quote)) {
      gsub("^[^[:alnum:]]", quote, gsub("[^[:alnum:]]$", right_quote, out))
    } else {
      out
    }
  }
}
