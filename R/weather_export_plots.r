# **** action **** ----
#' weather_export_plots (action)
#' @param data Data
#' @param argset Argset
#' @param schema DB Schema
#' @export
weather_export_plots_action <- function(data, argset, schema) {
  # tm_run_task("weather_export_plots")

  if(plnr::is_run_directly()){
    # sc::tm_get_plans_argsets_as_dt("weather_export_plots")

    index_plan <- 1
    index_analysis <- 1

    data <- sc::tm_get_data("weather_export_plots", index_plan = index_plan)
    argset <- sc::tm_get_argset("weather_export_plots", index_plan = index_plan, index_analysis = index_analysis)
    schema <- sc::tm_get_schema("weather_export_plots")
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
#' @param schema DB Schema
#' @export
weather_export_plots_data_selector = function(argset, schema){
  if(plnr::is_run_directly()){
    # sc::tm_get_plans_argsets_as_dt("weather_export_plots")

    index_plan <- 1

    argset <- sc::tm_get_argset("weather_export_plots", index_plan = index_plan)
    schema <- sc::tm_get_schema("weather_export_plots")
  }

  # The database schemas can be accessed here
  d <- schema$anon_example_weather_data$tbl() %>%
    sc::mandatory_db_filter(
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




