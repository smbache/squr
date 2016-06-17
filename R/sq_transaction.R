#' Wrap SQL Queries in a Transaction
#'
#' The provided queries are concatenated and wrapped in
#' \code{BEGIN TRANSACTION ... COMMIT TRANSACTION}.
#'
#' @param ... \code{sq} objects.
#' @param name Optional name for the transaction.
#' @export
sq_transaction <- function(..., name = "")
{
  queries <- list(...)
  if (!all(vapply(queries, inherits, logical(1), what = "sq")))
    stop("Some arguments are not 'sq' objects.")

  sq_text(sprintf("BEGIN TRANSACTION %s;", name)) +
  Reduce(`+`, queries) +
  sq_text(sprintf("COMMIT TRANSACTION %s;", name))
}
