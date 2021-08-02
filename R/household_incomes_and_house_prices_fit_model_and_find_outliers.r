# **** action **** ----
#' household_incomes_and_house_prices_fit_model_and_find_outliers (action)
#' @param data Data
#' @param argset Argset
#' @param schema DB Schema
#' @export
household_incomes_and_house_prices_fit_model_and_find_outliers_action <- function(data, argset, schema) {
  # tm_run_task("household_incomes_and_house_prices_fit_model_and_find_outliers")

  if(plnr::is_run_directly()){
    # sc::tm_get_plans_argsets_as_dt("household_incomes_and_house_prices_fit_model_and_find_outliers")

    index_plan <- 1
    index_analysis <- 1

    data <- sc::tm_get_data("household_incomes_and_house_prices_fit_model_and_find_outliers", index_plan = index_plan)
    argset <- sc::tm_get_argset("household_incomes_and_house_prices_fit_model_and_find_outliers", index_plan = index_plan, index_analysis = index_analysis)
    schema <- sc::tm_get_schema("household_incomes_and_house_prices_fit_model_and_find_outliers")
  }

  # code goes here
  # special case that runs before everything
  if(argset$first_analysis == TRUE){

  }

  d <- merge(
    data$income,
    data$price,
    by = c("location_code", "calyear")
  )

  d_pred <- d |> {\(x)
    lme4::lmer(
      new_house_price_per_m2_nok ~
        household_income_median_all_households_nok +
        (1|location_code),
      data = x
    )}() |>
    merTools::predictInterval(d, level = 0.95) |>
    {\(x) cbind(d, x)}() |>
    data.table()

  setnames(
    d_pred,
    c(
      "fit",
      "upr",
      "lwr"
    ),
    c(
      "new_house_price_per_m2_baseline_nok",
      "new_house_price_per_m2_nok_predinterval_q97x5",
      "new_house_price_per_m2_nok_predinterval_q02x5"
    )
  )

  d_pred[, new_house_price_per_m2_nok_status := "normal"]
  d_pred[new_house_price_per_m2_baseline_nok > new_house_price_per_m2_nok_predinterval_q97x5, new_house_price_per_m2_nok_status := "high"]

  xtabs(~d_pred$new_house_price_per_m2_nok_status)

  # put data in db table
  sc::fill_in_missing_v8(d_pred, border = config$border)
  schema$anon_example_house_prices_outliers_after_adjusting_for_income$drop_all_rows_and_then_insert_data(d_pred)

  # check that it uploaded
  nrow(d_pred)
  schema$anon_example_house_prices_outliers_after_adjusting_for_income$tbl() |> dplyr::summarize(n()) |> dplyr::collect()

  # special case that runs after everything
  # copy to anon_web?
  if(argset$last_analysis == TRUE){
    # sc::copy_into_new_table_where(
    #   table_from = "anon_X",
    #   table_to = "anon_webkht"
    # )
  }
}

# **** data_selector **** ----
#' household_incomes_and_house_prices_fit_model_and_find_outliers (data selector)
#' @param argset Argset
#' @param schema DB Schema
#' @export
household_incomes_and_house_prices_fit_model_and_find_outliers_data_selector = function(argset, schema){
  if(plnr::is_run_directly()){
    # sc::tm_get_plans_argsets_as_dt("household_incomes_and_house_prices_fit_model_and_find_outliers")

    index_plan <- 1

    argset <- sc::tm_get_argset("household_incomes_and_house_prices_fit_model_and_find_outliers", index_plan = index_plan)
    schema <- sc::tm_get_schema("household_incomes_and_house_prices_fit_model_and_find_outliers")
  }

  # The database schemas can be accessed here
  # schema$anon_example_income$print_dplyr_select()
  d_income <- schema$anon_example_income$tbl() %>%
    sc::mandatory_db_filter(
      granularity_time = "calyear",
      granularity_time_not = NULL,
      granularity_geo = "county",
      granularity_geo_not = NULL,
      country_iso3 = NULL,
      location_code = NULL,
      age = "total",
      age_not = NULL,
      sex = "total",
      sex_not = NULL
    ) %>%
    dplyr::filter(calyear %in% 2000:2019) %>%
    dplyr::select(
      granularity_time,
      granularity_geo,
      # country_iso3,
      location_code,
      # border,
      age,
      sex,
      #
      # date,
      #
      # isoyear,
      # isoweek,
      # isoyearweek,
      # season,
      # seasonweek,

      calyear,
      # calmonth,
      # calyearmonth,

      household_income_median_all_households_nok
      # household_income_median_singles_nok,
      # household_income_median_couples_without_children_nok,
      # household_income_median_couples_with_children_nok,
      # household_income_median_single_with_children_nok
    ) %>%
    dplyr::collect() %>%
    as.data.table() %>%
    setorder(
      location_code,
      calyear
    )

  # schema$anon_example_house_prices$print_dplyr_select()
  d_price <- schema$anon_example_house_prices$tbl() %>%
    sc::mandatory_db_filter(
      granularity_time = "calyear",
      granularity_time_not = NULL,
      granularity_geo = "county",
      granularity_geo_not = NULL,
      country_iso3 = NULL,
      location_code = NULL,
      age = "total",
      age_not = NULL,
      sex = "total",
      sex_not = NULL
    ) %>%
    dplyr::filter(calyear %in% 2000:2019) %>%
    dplyr::select(
      # granularity_time,
      # granularity_geo,
      # country_iso3,
      location_code,
      # border,
      # age,
      # sex,
      #
      # date,
      #
      # isoyear,
      # isoweek,
      # isoyearweek,
      # season,
      # seasonweek,

      calyear,
      # calmonth,
      # calyearmonth,

      new_house_price_per_m2_nok,
      used_house_price_per_m2_nok
    ) %>%
    dplyr::collect() %>%
    as.data.table() %>%
    setorder(
      location_code,
      calyear
    )

  # The variable returned must be a named list
  retval <- list(
    "income" = d_income,
    "price" = d_price
  )
  retval
}

# **** functions **** ----




