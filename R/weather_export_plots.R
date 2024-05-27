# **** action **** ----
#' weather_export_plots (action)
#' @param data Data
#' @param argset Argset
#' @param tables DB tables
#' @export
weather_export_plots_action <- function(data, argset, tables) {
  # cs9::run_task_sequentially_as_rstudio_job_using_load_all("weather_export_plots")
  # To be run outside of rstudio: cs9example::global$ss$run_task("weather_export_plots")

  if(plnr::is_run_directly()){
    # global$ss$shortcut_get_plans_argsets_as_dt("weather_export_plots")

    index_plan <- 1
    index_analysis <- 1

    data <- global$ss$shortcut_get_data("weather_export_plots", index_plan = index_plan)
    argset <- global$ss$shortcut_get_argset("weather_export_plots", index_plan = index_plan, index_analysis = index_analysis)
    tables <- global$ss$shortcut_get_tables("weather_export_plots")
  }

  # code goes here
  # special case that runs before everything
  if(argset$first_analysis == TRUE){

  }

  # create the output_dir (if it doesn't exist)
  fs::dir_create(glue::glue(argset$output_dir))

  q <- ggplot(data$data, aes(x = date, ymin = temp_min, ymax = temp_max))
  q <- q + geom_ribbon(alpha = 0.5)

  ggsave(
    filename = glue::glue(argset$output_absolute_path),
    plot = q
  )

  # special case that runs after everything
  # copy to anon_web?
  if(argset$last_analysis == TRUE){

  }
}

# **** data_selector **** ----
#' weather_export_plots (data selector)
#' @param argset Argset
#' @param tables DB tables
#' @export
weather_export_plots_data_selector = function(argset, tables){
  if(plnr::is_run_directly()){
    # global$ss$shortcut_get_plans_argsets_as_dt("weather_export_plots")

    index_plan <- 1

    argset <- global$ss$shortcut_get_argset("weather_export_plots", index_plan = index_plan, index_analysis = index_analysis)
    tables <- global$ss$shortcut_get_tables("weather_export_plots")
  }

  # The database tables can be accessed here
  d <- tables$anon_example_weather_data$tbl() %>%
    cs9::mandatory_db_filter(
      granularity_time = NULL,
      granularity_time_not = NULL,
      granularity_geo = NULL,
      granularity_geo_not = NULL,
      country_iso3 = NULL,
      location_code = argset$location_code,
      age = NULL,
      age_not = NULL,
      sex = NULL,
      sex_not = NULL
    ) %>%
    dplyr::select(
      # granularity_time,
      # granularity_geo,
      # country_iso3,
      # location_code,
      # border,
      # age,
      # sex,

      date,

      # isoyear,
      # isoweek,
      # isoyearweek,
      # season,
      # seasonweek,
      #
      # calyear,
      # calmonth,
      # calyearmonth,

      temp_max,
      temp_min
    ) %>%
    dplyr::collect() %>%
    as.data.table() %>%
    setorder(
      # location_code,
      date
    )

  # The variable returned must be a named list
  retval <- list(
    "data" = d
  )
  retval
}

# **** functions **** ----




