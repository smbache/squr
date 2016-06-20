#' Evaluate a Symbol as SQL Value
#'
#' @param symbol A symbol, an "AsIs" value, or a \code{sq_value}.
#' @param envir The environment or data in which to evaluate.
#' @param enclos The enclosing environment.
#'
#' @noRd
eval_sq <- function(symbol, envir, enclos)
{
  if (inherits(symbol, "AsIs") || inherits(symbol, "sq_value"))
    sq_value(symbol)
  else
    sq_value(eval(expr   = substitute(s, list(s = symbol)),
                  envir  = envir,
                  enclos = enclos))
}
