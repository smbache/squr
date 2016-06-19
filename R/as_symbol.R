#' Convert Character/One-Sided Formulas to Symbols
#'
#' Note that \code{AsIs} objects are returned as is.
#'
#' @param value a scalar character value, or a symbol wrapped in a one-sided formula.
#' @return A symbol or an "AsIs" value.
#' @noRd
as_symbol <- function(value)
{
  if (inherits(value, "AsIs"))
    value
  else if (inherits(value, "formula") && length(value) == 2)
    value[[2L]]
  else if (is_scalar_character(value))
    as.symbol(value)
  else
    stop("Cannot coerce to a symbol.")
}
