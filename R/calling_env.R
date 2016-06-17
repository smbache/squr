#' Get the First (Non squr) Calling Environment
#'
#' @param frames A list of frames to search through, e.g. \code{sys.frames()}.
#' @return Environment
#' @noRd
calling_env <- function(frames)
{
  rev(Filter(function(e) !identical(e, topenv()), lapply(c(.GlobalEnv, frames), topenv)))[[1]]
}
