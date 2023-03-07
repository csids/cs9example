# ******************************************************************************
# ******************************************************************************
#
# 00_env_and_namespace.R
#
# PURPOSE 1:
#   Use roxygen2 to import ggplot2, data.table, %>%, and %<>% into the namespace,
#   because these are the most commonly used packages/functions.
#
# PURPOSE 2:
#   Declaration of environments that can be used globally.
#
# PURPOSE 3:
#   Fix issues/integration with other packages.
#
#   Most notably is the issue with rmarkdown, where an error is thrown when
#   rendering multiple rmarkdown documents in parallel.
#
# ******************************************************************************
# ******************************************************************************

#' @import ggplot2
#' @import data.table
#' @importFrom magrittr %>% %<>%
1

#' Declaration of environments that can be used globally
#' @export global
global <- new.env()

# https://github.com/rstudio/rmarkdown/issues/1632
# An error is thrown when rendering multiple rmarkdown documents in parallel.
clean_tmpfiles_mod <- function() {
  # message("Calling clean_tmpfiles_mod()")
}
