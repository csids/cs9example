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

  ## > anon_example_income ----
  sc::add_schema_v8(
    name_access = c("anon"),
    name_grouping = "example_income",
    name_variant = NULL,
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

      "household_income_median_all_households_nok" = "DOUBLE",
      "household_income_median_singles_nok" = "DOUBLE",
      "household_income_median_couples_without_children_nok" = "DOUBLE",
      "household_income_median_couples_with_children_nok" = "DOUBLE",
      "household_income_median_single_with_children_nok" = "DOUBLE"
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

  ## > anon_example_house_prices ----
  sc::add_schema_v8(
    name_access = c("anon"),
    name_grouping = "example_house_prices",
    name_variant = NULL,
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

      "new_house_price_per_m2_nok" = "DOUBLE",
      "used_house_price_per_m2_nok" = "DOUBLE"
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

  ## > anon_example_house_prices_outliers_after_adjusting_for_income ----
  sc::add_schema_v8(
    name_access = c("anon"),
    name_grouping = "example_house_prices",
    name_variant = "outliers_after_adjusting_for_income",
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

      "household_income_median_all_households_nok" = "DOUBLE",

      "new_house_price_per_m2_nok" = "DOUBLE",
      "new_house_price_per_m2_baseline_nok" = "DOUBLE",
      "new_house_price_per_m2_nok_predinterval_q02x5" = "DOUBLE",
      "new_house_price_per_m2_nok_predinterval_q97x5" = "DOUBLE",
      "new_house_price_per_m2_nok_status" = "TEXT"
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
