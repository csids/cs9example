library(sc9example)
library(magrittr)
library(data.table)

d <- sc::tbl("anon_example_weather_data") |>
  sc::mandatory_db_filter(
    granularity_time = NULL,
    granularity_time_not = NULL,
    granularity_geo = NULL,
    granularity_geo_not = NULL,
    country_iso3 = NULL,
    location_code = "norge",
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

d[, .(
  temp_max = max(temp_max),
  temp_min = min(temp_min)
)]
