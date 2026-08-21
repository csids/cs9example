# ******************************************************************************
# ******************************************************************************
#
# 00_env_and_namespace.R
#
# PURPOSE 1:
#   Use roxygen2 to import ggplot2 and data.table into the namespace,
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
1

# "." is data.table's alias for list(), as in d[, .(x = ...)]. R CMD check reads
# it as an undefined function, and no local binding fixes that, so it is declared
# here. Every other NSE name is declared as NULL at the top of the one function
# that uses it.
utils::globalVariables(".")

#' Declaration of environments that can be used globally
#'
#' cs9example creates `global` empty, and fills it when the package loads. It
#' holds two things every task needs. `global$border` is the Norwegian border
#' year the package is configured for. `global$ss` is a
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
