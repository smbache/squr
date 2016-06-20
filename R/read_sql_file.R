#' Read a SQL File
#'
#' @param path The path to the file to be read.
#' @param remove_ignored logical indicating whether ignore blocks should be removed.
#'
#' @return character with file contents.
#' @noRd
read_sql_file <- function(path, remove_ignored = TRUE)
{
  content <- paste(readLines(path, warn = FALSE), collapse = "\n")

}
