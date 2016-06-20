#' Append sql Extension to Path if Missing
#'
#' @param path The path to a \code{.sql} file, possibly without extension.
#' @noRd
append_sql_extension <- function(path)
{
  `if`(grepl(".*\\.sql$", path, ignore.case = TRUE), path, paste0(path, ".sql"))
}
