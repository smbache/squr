#' Read The Contents of an SQL File
#'
#' @param path character specifying the path to an SQL file. The ".sql" extension can be omitted iff
#'   the actual extension is lower case.
#'   When used in a package, the path will be taken to be relative to the \code{inst} folder.
#'
#' @return A \code{sql} object.
#'
#' @export
sq_file <- function(path)
{
  if (!is_scalar_character(path))
    stop("Argument 'path' should be a scalar character value")

  path. <- `if`(grepl(".*\\.sql$", path, ignore.case = TRUE), path, paste0(path, ".sql"))

  pkg <- exists(".packageName", parent.frame(), mode = "character", inherits = TRUE)

  if (isTRUE(pkg)) {

    pkg_name <- get(".packageName", envir    = calling_env(sys.frames()),
                                    mode     = "character",
                                    inherits = TRUE)

    use_path <- system.file(path., package = pkg_name)

    if (use_path == "")
      stop(sprintf("The SQL file '%s' cannot be found in package '%s'", path., pkg_name))

  } else {

    use_path <- path.

  }

  normalized <- normalizePath(use_path, mustWork = FALSE)

  if (!file.exists(normalized))
    stop(sprintf("The SQL file '%s' cannot be found.", normalized))

  sql_ <- paste(readLines(normalized, warn = FALSE), collapse = "\n")

  # Remove --rignore blocks and multiple blank lines.
  sql <- gsub("^(?:[\t ]*(?:\r?\n|\r))+", "", gsub("--rignore.*?--end", "", sql_), perl = TRUE)

  sq_text(sql)
}
