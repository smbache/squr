#' Extract List Leaf Nodes
#'
#' This flattens a list by returning a list of leaf nodes, including their original
#' name. Names of intermediate steps are not kept, which makes this different
#' than \code{unlist(list., recursive = FALSE)}.
#'
#' @param list. A list
#' @return A flattened list of leaf nodes.
#' @noRd
leaf_nodes <- function(list.)
{
  if (length(list.) == 0)
    return(NULL)

  l <- list.[1]
  if (length(l[[1]]) > 1)
    c(leaf_nodes(as.list(l[[1]])), leaf_nodes(list.[-1]))
  else
    c(as.list(l[1]), leaf_nodes(list.[-1]))
}
