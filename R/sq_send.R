#' Send a Query
#'
#' Small function that invokes another given function for sending
#' a query to the database. The benefit of using this wrapper is
#' to keep database/driver boilerplate code separate from functions
#' that sends queries.
#'
#' @param .query A character/sq query string.
#' @param .with function with which to send the query.
#' @param ... further parameters passed to \code{with}.
sq_send <- function(.query, .with, ...)
{
  .with(.query, ...)
}
