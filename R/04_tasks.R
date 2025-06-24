# ******************************************************************************
# ******************************************************************************
#
# 04_tasks.R
#
# PURPOSE 1:
#   Set all the tasks that are run by the package.
#
#   These are basically all of the "things" that you want to do.
#   E.g. Downloading data, cleaning data, importing data, analyzing data,
#   making Excel files, making docx/pdf reports, sending emails, etc.
#
# ******************************************************************************
# ******************************************************************************

set_tasks <- function() {
  # __________ ----
  # Weather  ----
  ## > weather_download_and_import_rawdata ----
  # cs9::run_task_sequentially_as_rstudio_job_using_load_all("weather_download_and_import_rawdata")
  global$ss$add_task(
    name_grouping = "weather",
    name_action = "download_and_import_rawdata",
    name_variant = NULL,
    cores = 1,
    plan_analysis_fn_name = NULL,
    for_each_plan = plnr::expand_list(
      location_code = unique(csmaps::nor_municip_map_b2024_default_dt$location_code)
    ),
    for_each_analysis = NULL,
    universal_argset = NULL,
    upsert_at_end_of_each_plan = FALSE,
    insert_at_end_of_each_plan = FALSE,
    action_fn_name = "cs9example::weather_download_and_import_rawdata_action",
    data_selector_fn_name = "cs9example::weather_download_and_import_rawdata_data_selector",
    tables = list(
      # input

      # output
      "anon_example_weather_rawdata" = global$ss$tables$anon_example_weather_rawdata
    )
  )

  ## > weather_clean_data ----
  # cs9::run_task_sequentially_as_rstudio_job_using_load_all("weather_clean_data")
  global$ss$add_task(
    name_grouping = "weather",
    name_action = "clean_data",
    name_variant = NULL,
    cores = 1,
    plan_analysis_fn_name = NULL,
    for_each_plan = plnr::expand_list(
      x = 1
    ),
    for_each_analysis = NULL,
    universal_argset = NULL,
    upsert_at_end_of_each_plan = FALSE,
    insert_at_end_of_each_plan = FALSE,
    action_fn_name = "cs9example::weather_clean_data_action",
    data_selector_fn_name = "cs9example::weather_clean_data_data_selector",
    tables = list(
      # input
      "anon_example_weather_rawdata" = global$ss$tables$anon_example_weather_rawdata,

      # output
      "anon_example_weather_data" = global$ss$tables$anon_example_weather_data
    )
  )

  ## > weather_export_plots ----
  # cs9::run_task_sequentially_as_rstudio_job_using_load_all("weather_export_plots")
  global$ss$add_task(
    name_grouping = "weather",
    name_action = "export_plots",
    name_variant = NULL,
    cores = 1,
    plan_analysis_fn_name = NULL,
    for_each_plan = plnr::expand_list(
      location_code = csdata::nor_locations_names()[granularity_geo %in% c("county")]$location_code
    ),
    for_each_analysis = NULL,
    universal_argset = list(
      output_dir = tempdir(),
      output_filename = "weather_{argset$location_code}.png",
      output_absolute_path = fs::path("{argset$output_dir}", "{argset$output_filename}")
    ),
    upsert_at_end_of_each_plan = FALSE,
    insert_at_end_of_each_plan = FALSE,
    action_fn_name = "cs9example::weather_export_plots_action",
    data_selector_fn_name = "cs9example::weather_export_plots_data_selector",
    tables = list(
      # input
      "anon_example_weather_data" = global$ss$tables$anon_example_weather_data

      # output
    )
  )
}
