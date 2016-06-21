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

  path.sql <- append_sql_extension(path)


  if (is_packaged()) {

    pkg_name <- package_name()
    use_path <- system.file(path.sql, package = pkg_name)
    if (use_path == "")
      stop(sprintf("The SQL file '%s' cannot be found in package '%s'", path.sql, pkg_name))

  } else {

    use_path <- path.sql

  }

  normalized <- normalizePath(use_path, mustWork = FALSE)

  if (!file.exists(normalized))
    stop(sprintf("The SQL file '%s' cannot be found.", normalized))

  sql <- read_sql_file(normalized)

  sq_text(sql)
}

