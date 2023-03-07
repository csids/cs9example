# ******************************************************************************
# ******************************************************************************
#
# 03_db_tables.R
#
# PURPOSE 1:
#   Set db tables that are used throughout the package.
#
# ******************************************************************************
# ******************************************************************************

set_db_tables <- function() {
  # __________ ----
  # Weather  ----
  ## > anon_example_weather_rawdata ----
  global$ss$add_table(
    name_access = c("anon"),
    name_grouping = "example_weather",
    name_variant = "rawdata",
    field_types =  c(
      "granularity_time" = "TEXT",
      "granularity_geo" = "TEXT",
      "country_iso3" = "TEXT",
      "location_code" = "TEXT",
      "border" = "INTEGER",
      "age" = "TEXT",
      "sex" = "TEXT",

      "isoyear" = "INTEGER",
      "isoweek" = "INTEGER",
      "isoyearweek" = "TEXT",
      "season" = "TEXT",
      "seasonweek" = "DOUBLE",

      "calyear" = "INTEGER",
      "calmonth" = "INTEGER",
      "calyearmonth" = "TEXT",

      "date" = "DATE",

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
    validator_field_types = csdb::validator_field_types_csfmt_rts_data_v1,
    validator_field_contents = csdb::validator_field_contents_csfmt_rts_data_v1
  )

  ## > anon_example_weather_data ----
  global$ss$add_table(
    name_access = c("anon"),
    name_grouping = "example_weather",
    name_variant = "data",
    field_types =  c(
      "granularity_time" = "TEXT",
      "granularity_geo" = "TEXT",
      "country_iso3" = "TEXT",
      "location_code" = "TEXT",
      "border" = "INTEGER",
      "age" = "TEXT",
      "sex" = "TEXT",

      "isoyear" = "INTEGER",
      "isoweek" = "INTEGER",
      "isoyearweek" = "TEXT",
      "season" = "TEXT",
      "seasonweek" = "DOUBLE",

      "calyear" = "INTEGER",
      "calmonth" = "INTEGER",
      "calyearmonth" = "TEXT",

      "date" = "DATE",

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
    validator_field_types = csdb::validator_field_types_csfmt_rts_data_v1,
    validator_field_contents = csdb::validator_field_contents_csfmt_rts_data_v1
  )

  ## > anon_example_income ----
  global$ss$add_table(
    name_access = c("anon"),
    name_grouping = "example_income",
    name_variant = NULL,
    field_types =  c(
      "granularity_time" = "TEXT",
      "granularity_geo" = "TEXT",
      "country_iso3" = "TEXT",
      "location_code" = "TEXT",
      "border" = "INTEGER",
      "age" = "TEXT",
      "sex" = "TEXT",

      "isoyear" = "INTEGER",
      "isoweek" = "INTEGER",
      "isoyearweek" = "TEXT",
      "season" = "TEXT",
      "seasonweek" = "DOUBLE",

      "calyear" = "INTEGER",
      "calmonth" = "INTEGER",
      "calyearmonth" = "TEXT",

      "date" = "DATE",

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
    validator_field_types = csdb::validator_field_types_csfmt_rts_data_v1,
    validator_field_contents = csdb::validator_field_contents_csfmt_rts_data_v1
  )
}
