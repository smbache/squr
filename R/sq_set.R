#' Parameterize an SQL Query
#'
#' @param .query An \code{sq} object or a character string.
#' @param ... name-value pairs of named parameters.
#'
#' @details The values will be prepared with \code{sq_value}
#'
#' @export
sq_set <- function(.query, ...)
{
  params <- lapply(list(...), sq_value)
  names <- names(params)

  if (is.null(names) || any(names == ""))
    stop("Parameters must be named.")

  sort_index <- order(nchar(names))

  sq_set_(.query, params[sort_index])
}

#' Internal Recursive Parameterization Function
#'
#' @param query The query text to be parameterized.
#' @param params A list of parameters.
#'
#' @details The parameters should be sorted to have longer names first
#'   to avoid errors when some names are subsets of others.
#'
#' @noRd
sq_set_ <- function(query, params)
{
  param <- names(params)[[1L]]
  value <- params[[1L]]

  pattern <- paste0(param, "(?![[:alnum:]_#\\$\\@:])")

  prefix  <- `if`(any(grepl(paste0("@_", pattern), query, perl = TRUE)), "@_", "@")

  result <- gsub(paste0(prefix, pattern), value, query, perl = TRUE)

  if (length(params) > 1)
    sq_set_(result, params[-1])
  else
    sq_text(result)
}
