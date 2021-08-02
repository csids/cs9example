
# **** action **** ----
#' household_incomes_and_house_prices_import_data (action)
#' @param data Data
#' @param argset Argset
#' @param schema DB Schema
#' @export
household_incomes_and_house_prices_import_data_action <- function(data, argset, schema) {
  # tm_run_task("household_incomes_and_house_prices_import_data")

  if(plnr::is_run_directly()){
    # sc::tm_get_plans_argsets_as_dt("household_incomes_and_house_prices_import_data")

    index_plan <- 1
    index_analysis <- 1

    data <- sc::tm_get_data("household_incomes_and_house_prices_import_data", index_plan = index_plan)
    argset <- sc::tm_get_argset("household_incomes_and_house_prices_import_data", index_plan = index_plan, index_analysis = index_analysis)
    schema <- sc::tm_get_schema("household_incomes_and_house_prices_import_data")
  }

  # code goes here
  # special case that runs before everything
  if(argset$first_analysis == TRUE){

  }

  # skeleton for income ----
  # 1. Create a variable (possibly a list) to hold the data
  d_agg <- list()
  d_agg$calyear_municip <- copy(data$income)

  # redistricting
  for(i in seq_along(d_agg)){
    d_agg[[i]] <- merge(
      d_agg[[i]],
      fhidata::norway_locations_redistricting()[,-"granularity_geo"],
      by.x = c("location_code", "calyear"),
      by.y = c("location_code_original", "calyear"),
      all.x = TRUE
    )
  }

  # 5. Re-aggregate your data to different geographical levels to ensure that duplicates have now been removed
  # this will also fix the redistricting/kommunesammenslaaing issues
  for(i in seq_along(d_agg)){
    d_agg[[i]] <- d_agg[[i]][,.(
      household_income_median_all_households_nok = mean(household_income_median_all_households_nok * weighting, na.rm=T),
      household_income_median_singles_nok = mean(household_income_median_singles_nok * weighting, na.rm=T),
      household_income_median_couples_without_children_nok = mean(household_income_median_couples_without_children_nok * weighting, na.rm=T),
      household_income_median_couples_with_children_nok = mean(household_income_median_couples_with_children_nok  * weighting, na.rm=T),
      household_income_median_single_with_children_nok = mean(household_income_median_single_with_children_nok * weighting, na.rm=T)
    ), keyby=.(
      location_code = location_code_current,
      calyear
    )]
  }

  d_agg[]

  # 6. Pull out important dates
  calyear_min <- min(d_agg$calyear_municip$calyear)
  calyear_max <- max(d_agg$calyear_municip$calyear)

  # 7. Create `multiskeleton`
  # granularity_geo should have the following groups:
  # - nodata (when no data is available, and there is no "finer" data available to aggregate up)
  # - all levels of granularity_geo where you have data available
  # If you do not have data for a specific granularity_geo, but there is "finer" data available
  # then you should not include this granularity_geo in the multiskeleton, because you will create
  # it later when you aggregate up your data (baregion)
  multiskeleton_calyear <- fhidata::make_skeleton(
    calyear_min = calyear_min,
    calyear_max = calyear_max,
    granularity_geo = list(
      "nodata" = c(
        "wardoslo",
        "extrawardoslo",
        "missingwardoslo",
        "wardbergen",
        "missingwardbergen",
        "wardstavanger",
        "missingwardstavanger",
        "baregion",
        "notmainlandmunicip",
        "missingmunicip"
      ),

      "municip" = c(
        "municip"
      )
    )
  )

  # 8. Merge in the information you have at different geographical granularities
  # one level at a time
  # municip
  multiskeleton_calyear$municip[
    d_agg$calyear_municip,
    on = c("location_code", "calyear"),
    c(
      "household_income_median_all_households_nok",
      "household_income_median_singles_nok",
      "household_income_median_couples_without_children_nok",
      "household_income_median_couples_with_children_nok",
      "household_income_median_single_with_children_nok"
    ) := .(
      household_income_median_all_households_nok,
      household_income_median_singles_nok,
      household_income_median_couples_without_children_nok,
      household_income_median_couples_with_children_nok,
      household_income_median_single_with_children_nok
    )
  ]

  multiskeleton_calyear$municip[]

  # 9. Aggregate up to higher geographical granularities
  multiskeleton_calyear$county <- multiskeleton_calyear$municip[
    fhidata::norway_locations_hierarchy(
      from = "municip",
      to = "county"
    ),
    on = c(
      "location_code==from_code"
    )
  ][,
    .(
      household_income_median_all_households_nok = mean(household_income_median_all_households_nok, na.rm=T),
      household_income_median_singles_nok = mean(household_income_median_singles_nok, na.rm=T),
      household_income_median_couples_without_children_nok = mean(household_income_median_couples_without_children_nok, na.rm=T),
      household_income_median_couples_with_children_nok = mean(household_income_median_couples_with_children_nok, na.rm=T),
      household_income_median_single_with_children_nok = mean(household_income_median_single_with_children_nok, na.rm=T),
      granularity_geo = "county"
    ),
    by=.(
      granularity_time,
      calyear,
      location_code = to_code
    )
  ]

  multiskeleton_calyear$county[]

  #nation
  multiskeleton_calyear$nation <- multiskeleton_calyear$municip[
    ,
    .(
      household_income_median_all_households_nok = mean(household_income_median_all_households_nok, na.rm=T),
      household_income_median_singles_nok = mean(household_income_median_singles_nok, na.rm=T),
      household_income_median_couples_without_children_nok = mean(household_income_median_couples_without_children_nok, na.rm=T),
      household_income_median_couples_with_children_nok = mean(household_income_median_couples_with_children_nok, na.rm=T),
      household_income_median_single_with_children_nok = mean(household_income_median_single_with_children_nok, na.rm=T),
      granularity_geo = "nation",
      location_code = "norge"
    ),
    by=.(
      granularity_time,
      calyear
    )
  ]

  multiskeleton_calyear$nation[]

  # combine all the different granularity_geos
  skeleton_calyear <- rbindlist(multiskeleton_calyear, fill = TRUE, use.names = TRUE)

  skeleton_calyear[]

  # fix up missing structural data
  skeleton_calyear[, age := "total"]
  skeleton_calyear[, sex := "total"]
  sc::fill_in_missing_v8(skeleton_calyear, border = config$border)

  # put data in db table
  schema$anon_example_income$drop_all_rows_and_then_insert_data(skeleton_calyear)

  # check that it uploaded
  nrow(skeleton_calyear)
  schema$anon_example_income$tbl() |> dplyr::summarize(n()) |> dplyr::collect()

  # skeleton for prices ----
  # 1. Create a variable (possibly a list) to hold the data
  d_agg <- list()
  d_agg$calyear_county <- copy(data$price)

  # redistricting
  for(i in seq_along(d_agg)){
    d_agg[[i]] <- merge(
      d_agg[[i]],
      fhidata::norway_locations_redistricting()[,-"granularity_geo"],
      by.x = c("location_code", "calyear"),
      by.y = c("location_code_original", "calyear"),
      all.x = TRUE
    )
  }

  # 5. Re-aggregate your data to different geographical levels to ensure that duplicates have now been removed
  # this will also fix the redistricting/kommunesammenslaaing issues
  for(i in seq_along(d_agg)){
    d_agg[[i]] <- d_agg[[i]][,.(
      new_house_price_per_m2_nok = mean(new_house_price_per_m2_nok * weighting, na.rm=T),
      used_house_price_per_m2_nok = mean(used_house_price_per_m2_nok * weighting, na.rm=T)
    ), keyby=.(
      location_code = location_code_current,
      calyear
    )]
  }

  d_agg[]

  # 6. Pull out important dates
  calyear_min <- min(d_agg$calyear_county$calyear)
  calyear_max <- max(d_agg$calyear_county$calyear)

  # 7. Create `multiskeleton`
  # granularity_geo should have the following groups:
  # - nodata (when no data is available, and there is no "finer" data available to aggregate up)
  # - all levels of granularity_geo where you have data available
  # If you do not have data for a specific granularity_geo, but there is "finer" data available
  # then you should not include this granularity_geo in the multiskeleton, because you will create
  # it later when you aggregate up your data (baregion)
  multiskeleton_calyear <- fhidata::make_skeleton(
    calyear_min = calyear_min,
    calyear_max = calyear_max,
    granularity_geo = list(
      "nodata" = c(
        "wardoslo",
        "extrawardoslo",
        "missingwardoslo",
        "wardbergen",
        "missingwardbergen",
        "wardstavanger",
        "missingwardstavanger",
        "baregion",
        "notmainlandmunicip",
        "missingmunicip",
        "municip"
      ),

      "county" = c(
        "county"
      )
    )
  )

  # 8. Merge in the information you have at different geographical granularities
  # one level at a time
  # municip
  multiskeleton_calyear$county[
    d_agg$calyear_county,
    on = c("location_code", "calyear"),
    c(
      "new_house_price_per_m2_nok",
      "used_house_price_per_m2_nok"
    ) := .(
      new_house_price_per_m2_nok,
      used_house_price_per_m2_nok
    )
  ]

  multiskeleton_calyear$county[]

  # 9. Aggregate up to higher geographical granularities
  #nation
  multiskeleton_calyear$nation <- multiskeleton_calyear$county[
    ,
    .(
      new_house_price_per_m2_nok = mean(new_house_price_per_m2_nok, na.rm=T),
      used_house_price_per_m2_nok = mean(used_house_price_per_m2_nok, na.rm=T),
      granularity_geo = "nation",
      location_code = "norge"
    ),
    by=.(
      granularity_time,
      calyear
    )
  ]

  multiskeleton_calyear$nation[]

  # combine all the different granularity_geos
  skeleton_calyear <- rbindlist(multiskeleton_calyear, fill = TRUE, use.names = TRUE)

  skeleton_calyear[]

  # fix up missing structural data
  skeleton_calyear[, age := "total"]
  skeleton_calyear[, sex := "total"]
  sc::fill_in_missing_v8(skeleton_calyear, border = config$border)

  # put data in db table
  schema$anon_example_house_prices$drop_all_rows_and_then_insert_data(skeleton_calyear)

  # check that it uploaded
  nrow(skeleton_calyear)
  schema$anon_example_house_prices$tbl() |> dplyr::summarize(n()) |> dplyr::collect()

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
#' household_incomes_and_house_prices_import_data (data selector)
#' @param argset Argset
#' @param schema DB Schema
#' @export
household_incomes_and_house_prices_import_data_data_selector = function(argset, schema){
  if(plnr::is_run_directly()){
    # sc::tm_get_plans_argsets_as_dt("household_incomes_and_house_prices_import_data")

    index_plan <- 1

    argset <- sc::tm_get_argset("household_incomes_and_house_prices_import_data", index_plan = index_plan)
    schema <- sc::tm_get_schema("household_incomes_and_house_prices_import_data")
  }

  # household incomes
  # https://data.ssb.no/api/v0/dataset/49678.csv?lang=en
  d_income <- fread("https://data.ssb.no/api/v0/dataset/49678.csv?lang=en") |>
    dplyr::filter(contents=="Income after taxes, median (NOK)") |>
    tidyr::pivot_wider(
      id_cols = c(region, year),
      names_from = c(`type of household`),
      values_from = c(`06944: Households' income, by region, type of household, year and contents`)
    ) |>
    janitor::clean_names() |>
    dplyr::mutate(
      location_code = paste0("municip",stringr::str_extract(region, "^[0-9][0-9][0-9][0-9]")),
      household_income_median_all_households_nok = as.numeric(x0000_all_households),
      household_income_median_singles_nok = as.numeric(x0001_living_alone),
      household_income_median_couples_without_children_nok = as.numeric(x0002_couple_without_resident_children),
      household_income_median_couples_with_children_nok = as.numeric(x0003_couple_with_resident_children_0_17_year),
      household_income_median_single_with_children_nok = as.numeric(x0004_single_mother_father_with_children_0_17_year)
    ) |>
    dplyr::select(
      location_code,
      calyear = year,
      household_income_median_all_households_nok,
      household_income_median_singles_nok,
      household_income_median_couples_without_children_nok,
      household_income_median_couples_with_children_nok,
      household_income_median_single_with_children_nok
    ) |>
    data.table()

  # house prices
  # https://data.ssb.no/api/v0/dataset/25138.csv?lang=en
  d_price <- fread("https://data.ssb.no/api/v0/dataset/25138.csv?lang=en") |>
    dplyr::filter(contents=="Price per square meter (NOK)") |>
    tidyr::pivot_wider(
      id_cols = c(region, year),
      names_from = c(`type of detached houses`),
      values_from = c(`03364: Prices per square meter, by region, type of detached houses, year and contents`)
    ) |>
    janitor::clean_names() |>
    dplyr::mutate(
      location_code = paste0("county",stringr::str_extract(region, "^[0-9][0-9]")),
      new_house_price_per_m2_nok =as.numeric(x01_new_detached_houses),
      used_house_price_per_m2_nok = as.numeric(x02_used_detached_houses)
    ) |>
    dplyr::select(
      location_code,
      calyear = year,
      new_house_price_per_m2_nok,
      used_house_price_per_m2_nok
    ) |>
    data.table()

  # The variable returned must be a named list
  retval <- list(
    "income" = d_income,
    "price" = d_price
  )
  retval
}

# **** functions **** ----




