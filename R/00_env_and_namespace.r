# ******************************************************************************
# ******************************************************************************
#
# 00_env_and_namespace.r
#
# PURPOSE 1:
#   Use roxygen2 to import ggplot2, data.table, %>%, and %<>% into the namespace,
#   because these are the most commonly used packages/functions.
#
# PURPOSE 2:
#   Declaring our own "tm_run_task" inside this package, as a wrapper around
#   sc::tm_run_task.
#
#   We cannot run sc::tm_run_task directly, because we need to load all of the
#   database connections, db schemas, tasks, etc. *before* we run the task.
#   Hence, this wrapper ensures that all of this package's configs files are
#   loaded via OURPACKAGE::.onLoad() first, and then sc::tm_run_task can run.
#
# PURPOSE 3:
#   Declaration of environments that can be used globally.
#
# PURPOSE 4:
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

#' Shortcut to run task
#'
#' This task is needed to ensure that all the definitions/db schemas/tasks/etc
#' are loaded from the package scexample. We cannot run sc::tm_run_task directly,
#' because we need to load all of the database connections, db schemas, tasks,
#' etc. *before* we run the task. Hence, this wrapper ensures that all of this
#' package's configs files are loaded via OURPACKAGE::.onLoad() first, and then
#' sc::tm_run_task can run.
#'
#' @param task_name Name of the task
#' @param index_plan Not used
#' @param index_analysis Not used
#' @export
tm_run_task <- function(task_name, index_plan = NULL, index_analysis = NULL) {
  sc::tm_run_task(
    task_name = task_name,
    index_plan = index_plan,
    index_analysis = index_analysis
  )
}

#' Declaration of environments that can be used globally
#' @export config
config <- new.env()

# https://github.com/rstudio/rmarkdown/issues/1632
# An error is thrown when rendering multiple rmarkdown documents in parallel.
clean_tmpfiles_mod <- function() {
  # message("Calling clean_tmpfiles_mod()")
}
