# ******************************************************************************
# ******************************************************************************
#
# 04_tasks.r
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
  # tm_run_task("weather_download_and_import_rawdata")
  sc::add_task_from_config_v8(
    name_grouping = "weather",
    name_action = "download_and_import_rawdata",
    name_variant = NULL,
    cores = 1,
    plan_analysis_fn_name = NULL,
    for_each_plan = plnr::expand_list(
      location_code = fhidata::norway_locations_names()[granularity_geo %in% c("municip")]$location_code
    ),
    for_each_analysis = NULL,
    universal_argset = NULL,
    upsert_at_end_of_each_plan = FALSE,
    insert_at_end_of_each_plan = FALSE,
    action_fn_name = "scexample::weather_download_and_import_rawdata_action",
    data_selector_fn_name = "scexample::weather_download_and_import_rawdata_data_selector",
    schema = list(
      # input

      # output
      "anon_example_weather_rawdata" = sc::config$schemas$anon_example_weather_rawdata
    ),
    info = "This task downloads and imports the raw weather data from MET's API at the municipal level"
  )

  ## > weather_clean_data ----
  # tm_run_task("weather_clean_data")
  sc::add_task_from_config_v8(
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
    action_fn_name = "scexample::weather_clean_data_action",
    data_selector_fn_name = "scexample::weather_clean_data_data_selector",
    schema = list(
      # input
      "anon_example_weather_rawdata" = sc::config$schemas$anon_example_weather_rawdata,

      # output
      "anon_example_weather_data" = sc::config$schemas$anon_example_weather_data
    ),
    info = "This task cleans the raw data and aggregates it to county and national level"
  )

  ## > weather_clean_data ----
  # tm_run_task("weather_export_plots")
  sc::add_task_from_config_v8(
    name_grouping = "weather",
    name_action = "export_plots",
    name_variant = NULL,
    cores = 1,
    plan_analysis_fn_name = NULL,
    for_each_plan = plnr::expand_list(
      location_code = fhidata::norway_locations_names()[granularity_geo %in% c("county")]$location_code
    ),
    for_each_analysis = NULL,
    universal_argset = list(
      output_dir = tempdir(),
      output_filename = "weather_{argset$location_code}.png",
      output_absolute_path = fs::path("{argset$output_dir}", "{argset$output_filename}")
    ),
    upsert_at_end_of_each_plan = FALSE,
    insert_at_end_of_each_plan = FALSE,
    action_fn_name = "scexample::weather_export_plots_action",
    data_selector_fn_name = "scexample::weather_export_plots_data_selector",
    schema = list(
      # input
      "anon_example_weather_data" = sc::config$schemas$anon_example_weather_data

      # output
    ),
    info = "This task ploduces plots"
  )
}
