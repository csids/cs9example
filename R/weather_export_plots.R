# **** action **** ----
#' weather_export_plots (action)
#'
#' Creates `argset$output_dir`, draws `data$data` as a ribbon between `temp_min`
#' and `temp_max` over `date`, and saves it with [ggplot2::ggsave()] to
#' `argset$output_absolute_path`. That path is a `glue::glue()` template
#' evaluated once against `argset`, so `"{argset$output_dir}"` resolves but a
#' brace left inside `argset$output_filename` does not.
#'
#' This is the one action that touches no database table, so `tables` is unused
#' and the example below passes `NULL` for it.
#'
#' @param data Data
#' @param argset Argset
#' @param tables DB tables
#' @family cs9 task actions
#' @seealso [weather_export_plots_data_selector()], which produces this action's
#'   `data` argument. cs9example has no vignettes of its own; how cs9 pairs an
#'   action with a data selector is documented in [cs9::SurveillanceSystem_v9].
#' @examples
#' # An argset shaped like the one cs9 builds for this task, and a stand-in for
#' # what the data selector would have returned.
#' d <- list(data = data.table::data.table(
#'   date = as.Date("2024-01-01") + 0:29,
#'   temp_min = seq(-8, 6, length.out = 30),
#'   temp_max = seq(-2, 12, length.out = 30)
#' ))
#' argset <- list(
#'   location_code = "county_nor03",
#'   output_dir = fs::path(tempdir(), "cs9example-plots"),
#'   output_filename = "weather_county_nor03.png",
#'   output_absolute_path = fs::path("{argset$output_dir}", "{argset$output_filename}"),
#'   first_analysis = TRUE,
#'   last_analysis = TRUE
#' )
#'
#' weather_export_plots_action(data = d, argset = argset, tables = NULL)
#' fs::dir_ls(argset$output_dir)
#' @export
weather_export_plots_action <- function(data, argset, tables) {
  # NSE column names, declared so R CMD check does not read them as undefined globals
  temp_max <- temp_min <- NULL
  # cs9::run_task_sequentially_as_rstudio_job_using_load_all("weather_export_plots")
  # To be run outside of rstudio: cs9example::global$ss$run_task("weather_export_plots")

  if (plnr::is_run_directly()) {
    # global$ss$shortcut_get_plans_argsets_as_dt("weather_export_plots")

    index_plan <- 1
    index_analysis <- 1

    data <- global$ss$shortcut_get_data(
      "weather_export_plots",
      index_plan = index_plan
    )
    argset <- global$ss$shortcut_get_argset(
      "weather_export_plots",
      index_plan = index_plan,
      index_analysis = index_analysis
    )
    tables <- global$ss$shortcut_get_tables("weather_export_plots")
  }

  # code goes here
  # special case that runs before everything
  if (argset$first_analysis == TRUE) {}

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
  if (argset$last_analysis == TRUE) {}
}

# **** data_selector **** ----
#' weather_export_plots (data selector)
#'
#' Pulls every row of `anon_example_weather_data` for the location named in
#' `argset$location_code`. Returns the `date`, `temp_max` and `temp_min`
#' columns under the name `data`, ordered by date.
#'
#' @param argset Argset
#' @param tables DB tables
#' @return A named list with one element, `data`: a `data.table` of `date`,
#'   `temp_max` and `temp_min`.
#' @family cs9 task data selectors
#' @seealso [weather_export_plots_action()], which consumes this list, and
#'   [cs9::mandatory_db_filter()] for the filter it applies. cs9example has no
#'   vignettes of its own; how cs9 pairs a data selector with an action is
#'   documented in [cs9::SurveillanceSystem_v9].
#' @examples
#' \dontrun{
#' # Needs a live cs9 PostgreSQL database: it reads the
#' # anon_example_weather_data table.
#' weather_export_plots_data_selector(
#'   argset = global$ss$shortcut_get_argset("weather_export_plots"),
#'   tables = global$ss$shortcut_get_tables("weather_export_plots")
#' )
#' }
#' @export
weather_export_plots_data_selector <- function(argset, tables) {
  # NSE column names, declared so R CMD check does not read them as undefined globals
  temp_max <- temp_min <- NULL
  if (plnr::is_run_directly()) {
    # global$ss$shortcut_get_plans_argsets_as_dt("weather_export_plots")

    index_plan <- 1
    index_analysis <- 1

    argset <- global$ss$shortcut_get_argset(
      "weather_export_plots",
      index_plan = index_plan,
      index_analysis = index_analysis
    )
    tables <- global$ss$shortcut_get_tables("weather_export_plots")
  }

  # The database tables can be accessed here
  d <- tables$anon_example_weather_data$tbl() |>
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
    ) |>
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
    ) |>
    dplyr::collect() |>
    as.data.table() |>
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
