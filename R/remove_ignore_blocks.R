#' Remove Ignore Blocks
#'
#' Ignore blocks are blocks encapsulated by \code{--rignore} and \code{--end}.
#'
#' @param sql The sql query text.
#' @noRd
remove_ignore_blocks <- function(sql)
{
  gsub("^(?:[\t ]*(?:\r?\n|\r))+", "", gsub("--rignore.*?--end", "", sql), perl = TRUE)
}
