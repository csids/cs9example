# **** action **** ----
#' weather_clean_data (action)
#'
#' Lays out a complete municipality-by-date skeleton with
#' [make_skeleton_date()]. Merges the raw weather onto that skeleton.
#' Aggregates it up to county and to nation. Aggregates the whole lot up again
#' to ISO year-week. The action formats both granularities as
#' csfmt_rts_data_v2, stacks them, and writes them to
#' `anon_example_weather_data`. The write replaces whatever was there.
#'
#' @param data Data
#' @param argset Argset
#' @param tables DB tables
#' @family cs9 task actions
#' @seealso [weather_clean_data_data_selector()], which produces this action's
#'   `data` argument, and [make_skeleton_date()] for the skeleton it starts
#'   from. cs9example has no vignettes of its own; how cs9 pairs an action with
#'   a data selector is documented in [cs9::SurveillanceSystem_v9].
#' @examples
#' \dontrun{
#' # Needs a live cs9 PostgreSQL database: the action ends by dropping every row
#' # of anon_example_weather_data and inserting the cleaned data in its place.
#' global$ss$run_task("weather_clean_data")
#' }
#' @export
weather_clean_data_action <- function(data, argset, tables) {
  # NSE column names, declared so R CMD check does not read them as undefined globals
  age <- border <- granularity_geo <- granularity_time <- isoyearweek <- location_code <- precip <- sex <- temp_max <- temp_min <- to_code <- NULL
  # cs9::run_task_sequentially_as_rstudio_job_using_load_all("weather_clean_data")
  # To be run outside of rstudio: cs9example::global$ss$run_task("weather_clean_data")

  if (plnr::is_run_directly()) {
    # global$ss$shortcut_get_plans_argsets_as_dt("weather_clean_data")

    index_plan <- 1
    index_analysis <- 1

    data <- global$ss$shortcut_get_data(
      "weather_clean_data",
      index_plan = index_plan
    )
    argset <- global$ss$shortcut_get_argset(
      "weather_clean_data",
      index_plan = index_plan,
      index_analysis = index_analysis
    )
    tables <- global$ss$shortcut_get_tables("weather_clean_data")
  }

  # special case that runs before everything
  if (argset$first_analysis == TRUE) {}

  # Pull out important dates
  date_min <- min(data$date_municip$date, na.rm = T)
  date_max <- max(data$date_municip$date, na.rm = T)

  multiskeleton_date <- list()
  # Create skeleton for municip granularity
  multiskeleton_date$municip <- make_skeleton_date(
    date_min = date_min,
    date_max = date_max,
    granularity_geo = "municip"
  )

  # Merge in the information you have at different geographical granularities
  # one level at a time
  # municip
  multiskeleton_date$municip[
    data$date_municip,
    on = c("location_code", "date"),
    c(
      "temp_max",
      "temp_min",
      "precip"
    ) := .(
      temp_max,
      temp_min,
      precip
    )
  ]

  # Aggregate up to higher geographical granularities (county)
  multiskeleton_date$county <- multiskeleton_date$municip[
    csdata::nor_locations_hierarchy_from_to(
      from = "municip",
      to = "county"
    ),
    on = c(
      "location_code==from_code"
    )
  ][,
    .(
      temp_max = mean(temp_max, na.rm = T),
      temp_min = mean(temp_min, na.rm = T),
      precip = mean(precip, na.rm = T),
      granularity_geo = "county"
    ),
    by = .(
      granularity_time,
      date,
      location_code = to_code
    )
  ]

  multiskeleton_date$county[]

  # Aggregate up to higher geographical granularities (nation)
  multiskeleton_date$nation <- multiskeleton_date$municip[,
    .(
      temp_max = mean(temp_max, na.rm = T),
      temp_min = mean(temp_min, na.rm = T),
      precip = mean(precip, na.rm = T),
      granularity_geo = "nation",
      location_code = "nation_nor"
    ),
    by = .(
      granularity_time,
      date
    )
  ]

  multiskeleton_date$nation[]

  # combine all the different granularity_geos
  skeleton_date <- rbindlist(multiskeleton_date, fill = TRUE, use.names = TRUE)

  skeleton_date[]

  # 10. (If desirable) aggregate up to higher time granularities
  # if necessary, it is now easy to aggregate up to weekly data from here
  skeleton_isoyearweek <- copy(skeleton_date)
  skeleton_isoyearweek[, isoyearweek := cstime::date_to_isoyearweek_c(date)]
  skeleton_isoyearweek <- skeleton_isoyearweek[,
    .(
      temp_max = mean(temp_max, na.rm = T),
      temp_min = mean(temp_min, na.rm = T),
      precip = mean(precip, na.rm = T),
      granularity_time = "isoyearweek"
    ),
    keyby = .(
      isoyearweek,
      granularity_geo,
      location_code
    )
  ]

  skeleton_isoyearweek[]

  # we now need to format it and fill in missing structural variables
  # day
  skeleton_date[, sex := "total"]
  skeleton_date[, age := "total"]
  skeleton_date[, border := global$border]
  cstidy::set_csfmt_rts_data_v2(skeleton_date)

  # isoweek
  skeleton_isoyearweek[, sex := "total"]
  skeleton_isoyearweek[, age := "total"]
  skeleton_isoyearweek[, border := global$border]
  cstidy::set_csfmt_rts_data_v2(skeleton_isoyearweek)

  skeleton <- rbindlist(
    list(
      skeleton_date,
      skeleton_isoyearweek
    ),
    use.names = T
  )

  # put data in db table
  tables$anon_example_weather_data$drop_all_rows_and_then_insert_data(skeleton)

  # special case that runs after everything
  if (argset$last_analysis == TRUE) {}
}

# **** data_selector **** ----
#' weather_clean_data (data selector)
#'
#' Pulls the daily, municipality-level, total-age, total-sex rows out of
#' `anon_example_weather_rawdata`. Returns them under the name `date_municip`,
#' ordered by location and date.
#'
#' @param argset Argset
#' @param tables DB tables
#' @return A named list with one element, `date_municip`: a `data.table` of
#'   `granularity_time`, `location_code`, `date`, `temp_max`, `temp_min` and
#'   `precip`.
#' @family cs9 task data selectors
#' @seealso [weather_clean_data_action()], which consumes this list, and
#'   [cs9::mandatory_db_filter()] for the filter it applies. cs9example has no
#'   vignettes of its own; how cs9 pairs a data selector with an action is
#'   documented in [cs9::SurveillanceSystem_v9].
#' @examples
#' \dontrun{
#' # Needs a live cs9 PostgreSQL database: it reads the
#' # anon_example_weather_rawdata table.
#' weather_clean_data_data_selector(
#'   argset = global$ss$shortcut_get_argset("weather_clean_data"),
#'   tables = global$ss$shortcut_get_tables("weather_clean_data")
#' )
#' }
#' @export
weather_clean_data_data_selector <- function(argset, tables) {
  # NSE column names, declared so R CMD check does not read them as undefined globals
  granularity_time <- location_code <- precip <- temp_max <- temp_min <- NULL
  if (plnr::is_run_directly()) {
    # global$ss$shortcut_get_plans_argsets_as_dt("weather_clean_data")

    index_plan <- 1

    argset <- global$ss$shortcut_get_argset(
      "weather_clean_data",
      index_plan = index_plan
    )
    tables <- global$ss$shortcut_get_tables("weather_clean_data")
  }

  # The database tabless can be accessed here
  d <- tables$anon_example_weather_rawdata$tbl() |>
    cs9::mandatory_db_filter(
      granularity_time = "date",
      granularity_time_not = NULL,
      granularity_geo = "municip",
      granularity_geo_not = NULL,
      country_iso3 = NULL,
      location_code = NULL,
      age = "total",
      age_not = NULL,
      sex = "total",
      sex_not = NULL
    ) |>
    dplyr::select(
      granularity_time,
      # granularity_geo,
      # country_iso3,
      location_code,
      # border,
      # age,
      # sex,

      date,

      # isoyear,
      # isoweek,
      # isoyearweek,
      # season,
      # seasonweek,

      # calyear,
      # calmonth,
      # calyearmonth,

      temp_max,
      temp_min,
      precip
    ) |>
    dplyr::collect() |>
    as.data.table() |>
    setorder(
      location_code,
      date
    )

  # The variable returned must be a named list
  retval <- list(
    "date_municip" = d
  )

  retval
}

# **** functions **** ----
