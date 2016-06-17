#' Is a Value a Scalar of Character Type?
#'
#' @param value A value to be tested.
#' @return logical
#' @noRd
is_scalar_character <- function(value)
{
  is.character(value) && length(value) == 1
}
