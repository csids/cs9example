# **** action **** ----
#' covid19_import_data (action)
#' @param data Data
#' @param argset Argset
#' @param tables DB tables
#' @export
covid19_import_data_action <- function(data, argset, tables) {
  # sc9::run_task_sequentially_as_rstudio_job_using_load_all("covid19_import_data")
  # To be run outside of rstudio: sc9example::global$ss$run_task("covid19_import_data")

  if (plnr::is_run_directly()) {
    # global$ss$shortcut_get_plans_argsets_as_dt("covid19_import_data")

    index_plan <- 1
    index_analysis <- 1

    data <- global$ss$shortcut_get_data("covid19_import_data", index_plan = index_plan)
    argset <- global$ss$shortcut_get_argset("covid19_import_data", index_plan = index_plan, index_analysis = index_analysis)
    tables <- global$ss$shortcut_get_tables("covid19_import_data")
  }

  # special case that runs before everything
  if (argset$first_analysis == TRUE) {

  }

  # put data in db table
  tables$anon_covid19_data$drop_all_rows_and_then_insert_data(data$data)

  # special case that runs after everything
  if (argset$last_analysis == TRUE) {

  }
}

# **** data_selector **** ----
#' covid19_import_data (data selector)
#' @param argset Argset
#' @param tables DB tables
#' @export
covid19_import_data_data_selector <- function(argset, tables) {
  if (plnr::is_run_directly()) {
    # sc::tm_get_plans_argsets_as_dt("covid19_import_data")

    index_plan <- 1

    argset <- global$ss$shortcut_get_argset("covid19_import_data", index_plan = index_plan)
    tables <- global$ss$shortcut_get_tables("covid19_import_data")
  }

  # The variable returned must be a named list
  retval <- list(
    "data" = csdb::nor_covid19_cases_by_time_location
  )

  retval
}

# **** functions **** ----
