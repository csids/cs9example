# **** action **** ----
#' weather_download_and_import_rawdata (action)
#'
#' Keeps the 00, 06, 12 and 18 o'clock timepoints of the forecast that
#' [weather_download_and_import_rawdata_data_selector()] returned, reduces them
#' to one row per date (maximum and minimum air temperature, total
#' precipitation) and upserts those rows into `anon_example_weather_rawdata`.
#'
#' @param data Data
#' @param argset Argset
#' @param tables DB tables
#' @family cs9 task actions
#' @seealso [weather_download_and_import_rawdata_data_selector()], which
#'   produces this action's `data` argument. cs9example has no vignettes of its
#'   own; how cs9 pairs an action with a data selector is documented in
#'   [cs9::SurveillanceSystem_v9].
#' @examples
#' \dontrun{
#' # Needs a live cs9 PostgreSQL database: the last thing the action does is
#' # upsert into the anon_example_weather_rawdata table.
#' global$ss$run_task("weather_download_and_import_rawdata")
#' }
#' @export
weather_download_and_import_rawdata_action <- function(data, argset, tables) {
  # cs9::run_task_sequentially_as_rstudio_job_using_load_all("weather_download_and_import_rawdata")
  # To be run outside of rstudio: cs9example::global$ss$run_task("weather_download_and_import_rawdata")

  if (plnr::is_run_directly()) {
    # global$ss$shortcut_get_plans_argsets_as_dt("weather_download_and_import_rawdata")

    index_plan <- 1
    index_analysis <- 1

    data <- global$ss$shortcut_get_data(
      "weather_download_and_import_rawdata",
      index_plan = index_plan
    )
    argset <- global$ss$shortcut_get_argset(
      "weather_download_and_import_rawdata",
      index_plan = index_plan,
      index_analysis = index_analysis
    )
    tables <- global$ss$shortcut_get_tables(
      "weather_download_and_import_rawdata"
    )
  }

  # special case that runs before everything
  if (argset$first_analysis == TRUE) {}

  a <- data$data$properties$timeseries
  res <- vector("list", length = length(a) - 1)
  for (i in seq_along(res)) {
    # i = 1
    time_from <- a[[i]]$time
    if ("next_1_hours" %in% names(a[[i]]$data)) {
      time_var <- "next_1_hours"
    } else {
      time_var <- "next_6_hours"
    }
    temp <- a[[i]]$data[["instant"]]$details$air_temperature
    precip <- a[[i]]$data[[time_var]]$details$precipitation_amount

    res[[i]] <- data.frame(
      time_from = as.character(time_from),
      temp = as.numeric(temp),
      precip = as.numeric(precip)
    )
  }

  res <- rbindlist(res)
  res <- res[stringr::str_sub(time_from, 12, 13) %in% c("00", "06", "12", "18")]
  res[, date := as.Date(stringr::str_sub(time_from, 1, 10))]
  res <- res[,
    .(
      temp_max = max(temp),
      temp_min = min(temp),
      precip = sum(precip)
    ),
    keyby = .(date)
  ]

  # we look at the downloaded data
  # res

  # we now need to format it
  res[, granularity_time := "date"]
  res[, sex := "total"]
  res[, age := "total"]
  res[, location_code := argset$location_code]
  res[, border := global$border]

  # fill in missing structural variables
  cstidy::set_csfmt_rts_data_v2(res)

  # we look at the downloaded data
  # res

  # put data in db table
  tables$anon_example_weather_rawdata$upsert_data(res)

  # special case that runs after everything
  if (argset$last_analysis == TRUE) {}
}

# **** data_selector **** ----
#' weather_download_and_import_rawdata (data selector)
#'
#' Takes the mean latitude and longitude of the municipality named in
#' `argset$location_code`, then downloads the MET Norway location forecast for
#' that point. Returns it under the name `data`.
#'
#' @param argset Argset
#' @param tables DB tables
#' @return A named list with one element, `data`: the parsed forecast.
#' @family cs9 task data selectors
#' @seealso [weather_download_and_import_rawdata_action()], which consumes this
#'   list. cs9example has no vignettes of its own; how cs9 pairs a data selector
#'   with an action is documented in [cs9::SurveillanceSystem_v9].
#' @examples
#' \dontrun{
#' # Needs internet access to api.met.no, and the csmaps package for the
#' # municipality's coordinates.
#' weather_download_and_import_rawdata_data_selector(
#'   argset = list(location_code = "municip_nor0301"),
#'   tables = NULL
#' )
#' }
#' @export
weather_download_and_import_rawdata_data_selector <- function(argset, tables) {
  if (plnr::is_run_directly()) {
    # sc::tm_get_plans_argsets_as_dt("weather_download_and_import_rawdata")

    index_plan <- 1

    argset <- global$ss$shortcut_get_argset(
      "weather_download_and_import_rawdata",
      index_plan = index_plan
    )
    tables <- global$ss$shortcut_get_tables(
      "weather_download_and_import_rawdata"
    )
  }

  # find the mid lat/long for the specified location_code
  gps <- csmaps::nor_municip_map_b2024_default_dt[
    location_code == argset$location_code,
    .(
      lat = mean(lat),
      long = mean(long)
    )
  ]

  # download the forecast for the specified location_code
  d <- httr::GET(glue::glue(
    "https://api.met.no/weatherapi/locationforecast/2.0/complete?lat={gps$lat}&lon={gps$long}"
  ))
  d <- httr::content(d)

  # The variable returned must be a named list
  retval <- list(
    "data" = d
  )

  retval
}

# **** functions **** ----
