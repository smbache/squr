#' Create an Insert Statment
#'
#' Insert blocks are special parameters in \code{squr} and provide an easy way
#' of constructing \code{INSERT INTO ... Values (...)} type constructs. They are
#' marked in the SQL source with \code{@@label:insert}.
#'
#' @param .into The name of the table to insert into.
#' @param ... Names of the values to insert, either as character or one-sided
#'   formulas. It is also possible to specify \code{AsIs} variables by wrapping
#'   the value in \code{I(.)}.
#' @param .data Data or environment to lookup the names.
#' @param .split integer specifying the maximum number of value-pairs in each
#'   \code{INSERT} block.
#' @param .quote The quote to use for table and column names.
#'
#' @export
sq_insert <- function(.into, ..., .data = parent.frame(), .split = 75, .quote = "[")
{
  dots <- leaf_nodes(list(...))

  if (length(dots) == 0 && is.list(.data)) {
    dots <- names(.data)
  }

  symbols <- lapply(dots, as_symbol)

  names <-
    `if`(is.null(names(dots)), map_character(symbols), names(dots))

  names[names == ""] <- lapply(symbols[names == ""], as.character)

  INTO <- sq_set(sq_text("INSERT INTO @Into @Columns"),
                         Into    = sq_value(.into, .quote),
                         Columns = sq_value(as.list(names), .quote))

  enclos <- calling_env()

  values <- lapply(symbols, eval_sq, envir = .data, enclos = enclos)

  lengths <- map_integer(values, length)
  if (!all(lengths) %in% c(1, max(lengths)))
    stop("Value lengths do not match.")

  inserts <-
    paste0("(", Reduce(function(l, r) paste(l, r, sep = ","), values), ")")

  chunks <- (1:length(values[[1]]) - 1) %/% .split + 1

  value_strings <-
    tapply(inserts, chunks, FUN = function(i) paste(i, collapse = ","),
           simplify = FALSE)

  statements <-
    lapply(value_strings, function(vs) sq_text(INTO + paste("VALUES", vs)))

  sq_text(paste(statements, collapse = "\n"))
}

