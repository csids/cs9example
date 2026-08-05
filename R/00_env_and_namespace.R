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

# data.table and dplyr use non-standard evaluation, so column names referenced
# inside `[...]` and inside dplyr::select() look like undefined globals to
# R CMD check. Declaring them here keeps "checking R code for possible
# problems" clean without touching the code.
utils::globalVariables(c(
  ".",
  "age",
  "border",
  "granularity_geo",
  "granularity_time",
  "isoyearweek",
  "lat",
  "location_code",
  "long",
  "precip",
  "sex",
  "temp_max",
  "temp_min",
  "to_code"
))

#' Declaration of environments that can be used globally
#'
#' `global` is created empty and filled when cs9example is loaded. It holds two
#' things every task needs: `global$border`, the Norwegian border year the
#' package is configured for, and `global$ss`, a
#' [cs9::SurveillanceSystem_v9] object with every database table and every task
#' already registered.
#'
#' @seealso [cs9::SurveillanceSystem_v9] for the class `global$ss` is an
#'   instance of, and [make_skeleton_date()] for the skeleton builder the tasks
#'   use. cs9example has no vignettes of its own; the framework is documented in
#'   the cs9 package.
#' @examples
#' # The border year, set when the package loads.
#' global$border
#'
#' # The two tables and the three tasks the package registers.
#' names(global$ss$tables)
#' names(global$ss$tasks)
#' @export global
global <- new.env()

# https://github.com/rstudio/rmarkdown/issues/1632
# An error is thrown when rendering multiple rmarkdown documents in parallel.
clean_tmpfiles_mod <- function() {
  # message("Calling clean_tmpfiles_mod()")
}
