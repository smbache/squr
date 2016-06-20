#' Get the First (Non squr) Calling Environment
#'
#' @return Environment
#' @noRd
calling_env <- function()
{
  top        <- topenv(environment(calling_env))
  frames     <- c(.GlobalEnv, sys.frames())
  topenvs    <- lapply(frames, topenv)
  is_squr    <- vapply(topenvs, function(e) identical(e, top), logical(1))
  first_squr <- min(which(is_squr))

  frames[[first_squr - 1]]
}
