# **** action **** ----
#' weather_clean_data (action)
#' @param data Data
#' @param argset Argset
#' @param tables DB tables
#' @export
weather_clean_data_action <- function(data, argset, tables) {
  # cs9::run_task_sequentially_as_rstudio_job_using_load_all("weather_clean_data")
  # To be run outside of rstudio: cs9example::global$ss$run_task("weather_clean_data")


  if (plnr::is_run_directly()) {
    # global$ss$shortcut_get_plans_argsets_as_dt("weather_clean_data")

    index_plan <- 1
    index_analysis <- 1

    data <- global$ss$shortcut_get_data("weather_clean_data", index_plan = index_plan)
    argset <- global$ss$shortcut_get_argset("weather_clean_data", index_plan = index_plan, index_analysis = index_analysis)
    tables <- global$ss$shortcut_get_tables("weather_clean_data")
  }

  # special case that runs before everything
  if (argset$first_analysis == TRUE) {

  }

  # make sure there's no missing data via the creation of a skeleton
  # https://folkehelseinstituttet.github.io/fhidata/articles/Skeletons.html

  # Create a variable (possibly a list) to hold the data
  d_agg <- list()
  d_agg$day_municip <- copy(data$day_municip)

  # Pull out important dates
  date_min <- min(d_agg$day_municip$date, na.rm = T)
  date_max <- max(d_agg$day_municip$date, na.rm = T)

  # Create `multiskeleton`
  # granularity_geo should have the following groups:
  # - nodata (when no data is available, and there is no "finer" data available to aggregate up)
  # - all levels of granularity_geo where you have data available
  # If you do not have data for a specific granularity_geo, but there is "finer" data available
  # then you should not include this granularity_geo in the multiskeleton, because you will create
  # it later when you aggregate up your data (baregion)
  multiskeleton_day <- fhidata::make_skeleton(
    date_min = date_min,
    date_max = date_max,
    granularity_geo = list(
      "nodata" = c(
        "wardoslo",
        "extrawardoslo",
        "missingwardoslo",
        "wardbergen",
        "missingwardbergen",
        "wardstavanger",
        "missingwardstavanger",
        "notmainlandmunicip",
        "missingmunicip",
        "notmainlandcounty",
        "missingcounty"
      ),
      "municip" = c(
        "municip"
      )
    )
  )

  # Merge in the information you have at different geographical granularities
  # one level at a time
  # municip
  multiskeleton_day$municip[
    d_agg$day_municip,
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

  multiskeleton_day$municip[]

  # Aggregate up to higher geographical granularities (county)
  multiskeleton_day$county <- multiskeleton_day$municip[
    fhidata::norway_locations_hierarchy(
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

  multiskeleton_day$county[]

  # Aggregate up to higher geographical granularities (nation)
  multiskeleton_day$nation <- multiskeleton_day$municip[
    ,
    .(
      temp_max = mean(temp_max, na.rm = T),
      temp_min = mean(temp_min, na.rm = T),
      precip = mean(precip, na.rm = T),
      granularity_geo = "nation",
      location_code = "norge"
    ),
    by = .(
      granularity_time,
      date
    )
  ]

  multiskeleton_day$nation[]

  # combine all the different granularity_geos
  skeleton_day <- rbindlist(multiskeleton_day, fill = TRUE, use.names = TRUE)

  skeleton_day[]

  # 10. (If desirable) aggregate up to higher time granularities
  # if necessary, it is now easy to aggregate up to weekly data from here
  skeleton_isoweek <- copy(skeleton_day)
  skeleton_isoweek[, isoyearweek := fhiplot::isoyearweek_c(date)]
  skeleton_isoweek <- skeleton_isoweek[
    ,
    .(
      temp_max = mean(temp_max, na.rm = T),
      temp_min = mean(temp_min, na.rm = T),
      precip = mean(precip, na.rm = T),
      granularity_time = "isoweek"
    ),
    keyby = .(
      isoyearweek,
      granularity_geo,
      location_code
    )
  ]

  skeleton_isoweek[]

  # we now need to format it and fill in missing structural variables
  # day
  skeleton_day[, sex := "total"]
  skeleton_day[, age := "total"]
  skeleton_day[, border := global$border]
  cstidy::set_csfmt_rts_data_v1(skeleton_day)

  # isoweek
  skeleton_isoweek[, sex := "total"]
  skeleton_isoweek[, age := "total"]
  skeleton_isoweek[, border := global$border]
  cstidy::set_csfmt_rts_data_v1(skeleton_isoweek)

  skeleton <- rbindlist(
    list(
      skeleton_day,
      skeleton_isoweek
    ),
    use.names = T
  )

  # put data in db table
  tables$anon_example_weather_data$drop_all_rows_and_then_insert_data(skeleton)

  # special case that runs after everything
  if (argset$last_analysis == TRUE) {

  }
}

# **** data_selector **** ----
#' weather_clean_data (data selector)
#' @param argset Argset
#' @param tables DB tables
#' @export
weather_clean_data_data_selector <- function(argset, tables) {
  if (plnr::is_run_directly()) {
    # global$ss$shortcut_get_plans_argsets_as_dt("weather_clean_data")

    index_plan <- 1

    argset <- global$ss$shortcut_get_argset("weather_clean_data", index_plan = index_plan)
    tables <- global$ss$shortcut_get_tables("weather_clean_data")
  }

  # The database tabless can be accessed here
  d <- tables$anon_example_weather_rawdata$tbl() %>%
    cs9::mandatory_db_filter(
      granularity_time = "day",
      granularity_time_not = NULL,
      granularity_geo = "municip",
      granularity_geo_not = NULL,
      country_iso3 = NULL,
      location_code = NULL,
      age = "total",
      age_not = NULL,
      sex = "total",
      sex_not = NULL
    ) %>%
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
    ) %>%
    dplyr::collect() %>%
    as.data.table() %>%
    setorder(
      location_code,
      date
    )

  # The variable returned must be a named list
  retval <- list(
    "day_municip" = d
  )

  retval
}

# **** functions **** ----
