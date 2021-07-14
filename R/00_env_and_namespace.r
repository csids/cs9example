#' @import ggplot2
#' @import data.table
#' @importFrom magrittr %>% %<>%
1

# https://github.com/rstudio/rmarkdown/issues/1632
clean_tmpfiles_mod <- function() {
  # message("Calling clean_tmpfiles_mod()")
}

#' Shortcut to run task
#'
#' This task is needed to ensure that all the definitions/db schemas/tasks/etc
#' are loaded from the package scexample.
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
