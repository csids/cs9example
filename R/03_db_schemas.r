# ******************************************************************************
# ******************************************************************************
#
# 03_db_schemas.r
#
# PURPOSE 1:
#   Set db schemas that are used throughout the package.
#
#   These are basically all of the database tables that you will be writing to,
#   and reading from.
#
# ******************************************************************************
# ******************************************************************************

set_db_schemas <- function() {
  # __________ ----
  # Weather  ----
  ## > anon_example_weather_rawdata ----
  sc::add_schema_v8(
    name_access = c("anon"),
    name_grouping = "example_weather",
    name_variant = "rawdata",
    db_configs = sc::config$db_configs,
    field_types =  c(
      "granularity_time" = "TEXT",
      "granularity_geo" = "TEXT",
      "country_iso3" = "TEXT",
      "location_code" = "TEXT",
      "border" = "INTEGER",
      "age" = "TEXT",
      "sex" = "TEXT",

      "date" = "DATE",

      "isoyear" = "INTEGER",
      "isoweek" = "INTEGER",
      "isoyearweek" = "TEXT",
      "season" = "TEXT",
      "seasonweek" = "DOUBLE",

      "calyear" = "INTEGER",
      "calmonth" = "INTEGER",
      "calyearmonth" = "TEXT",

      "temp_max" = "DOUBLE",
      "temp_min" = "DOUBLE",
      "precip" = "DOUBLE"
    ),
    keys = c(
      "granularity_time",
      "location_code",
      "date",
      "age",
      "sex"
    ),
    censors = list(
      anon = list(

      )
    ),
    validator_field_types = sc::validator_field_types_sykdomspulsen,
    validator_field_contents = sc::validator_field_contents_sykdomspulsen,
    info = "This db table is used for..."
  )

  ## > anon_example_weather_data ----
  sc::add_schema_v8(
    name_access = c("anon"),
    name_grouping = "example_weather",
    name_variant = "data",
    db_configs = sc::config$db_configs,
    field_types =  c(
      "granularity_time" = "TEXT",
      "granularity_geo" = "TEXT",
      "country_iso3" = "TEXT",
      "location_code" = "TEXT",
      "border" = "INTEGER",
      "age" = "TEXT",
      "sex" = "TEXT",

      "date" = "DATE",

      "isoyear" = "INTEGER",
      "isoweek" = "INTEGER",
      "isoyearweek" = "TEXT",
      "season" = "TEXT",
      "seasonweek" = "DOUBLE",

      "calyear" = "INTEGER",
      "calmonth" = "INTEGER",
      "calyearmonth" = "TEXT",

      "temp_max" = "DOUBLE",
      "temp_min" = "DOUBLE",
      "precip" = "DOUBLE"
    ),
    keys = c(
      "granularity_time",
      "location_code",
      "date",
      "age",
      "sex"
    ),
    censors = list(
      anon = list(

      )
    ),
    validator_field_types = sc::validator_field_types_sykdomspulsen,
    validator_field_contents = sc::validator_field_contents_sykdomspulsen,
    info = "This db table is used for..."
  )
}
