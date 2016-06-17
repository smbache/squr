#' Create an Insert Statment
#'
#' Insert blocks are special parameters in \code{squr} and provide
#' an easy way of constructing \code{INSERT INTO ... Values (...)} type constructs.
#' They are marked in the SQL source with \code{@@label:insert}.
#'
#' @param into The name of the table to insert into.
#' @param ... Names of the values to insert, either as character or one-sided formulas.
#' @param data Data or environment to lookup the names.
#' @param split integer specifying the maximum number of value-pairs in each \code{INSERT} block.
#'
#' @export
sq_insert <- function(into, ..., data = parent.frame(), split = 999)
{
  dots <- unlist(list(...))


  if (length(dots) == 0 && is.list(data)) {
    dots <- names(data)
  }

  symbols <- lapply(dots, as_symbol)
  names <- `if`(is.null(names(dots)), vapply(symbols, as.character, character(1)), names(dots))
  names[names == ""] <- lapply(symbols[names == ""], as.character)

  INTO <- sq_set(sq_text("INSERT INTO @Into @Columns"),
                         Into    = sq_value(into, ""),
                         Columns = sq_value(as.list(names), ""))

  enclos <- calling_env(sys.frames())

  values <-
    lapply(symbols, function(s) sq_value(eval(substitute(s, list(s = s)),
                                               envir = data, enclos = enclos)))

  lengths <- vapply(values, length, integer(1))
  if (!all(lengths) %in% c(1, max(lengths)))
    stop("Value lengths do not match.")

  inserts <- paste0("(", do.call(paste, c(values, sep = ",")), ")")

  chunks <- (1:length(values[[1]]) - 1) %/% split + 1

  value_strings <-
    tapply(inserts, chunks, FUN = function(i) paste(i, collapse = ","), simplify = FALSE)

  statements <- lapply(value_strings, function(vs) sq_text(INTO + paste("VALUES", vs)))

  Reduce(`+`, statements)
}

as_symbol <- function(value)
{
  if (inherits(value, "AsIs"))
    value
  else if (inherits(value, "formula") && length(value) == 2)
    value[[2L]]
  else if (is_scalar_character(value))
    as.symbol(value)
  else
    stop("Cannot coerce to a symbol.")
}
