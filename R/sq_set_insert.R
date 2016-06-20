#' Parameterize Insert Parameters
#'
#' @param .query An \code{sq} query object.
#' @param .into The name of the table to insert into.
#' @param .label the insert block label.
#' @param ... Names of the values to insert, either as character or one-sided formulas.
#'   It is also possible to specify \code{AsIs} variables by wrapping the value in \code{I(.)}.
#' @param .data Data or environment to lookup the names.
#' @param .split integer specifying the maximum number of value-pairs in each \code{INSERT} block.
#'
#' @details The values will be prepared with \code{sq_value}
#'
#' @export
sq_set_insert <- function(.query, .label, .into, ..., .data = parent.frame(), .split = 999)
{
  insert <- sq_insert(.into, ..., .data = .data, .split = .split)

  pattern <- paste0("@", .label, ":insert(?![[:alnum:]_#\\$\\@:])")

  result <- gsub(pattern, insert, .query, perl = TRUE)

  sq_text(result)
}
