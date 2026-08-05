# weather_download_and_import_rawdata (action)

Keeps the 00, 06, 12 and 18 o'clock timepoints of the forecast that
[`weather_download_and_import_rawdata_data_selector()`](https://niphr.github.io/cs9example/reference/weather_download_and_import_rawdata_data_selector.md)
returned, reduces them to one row per date (maximum and minimum air
temperature, total precipitation) and upserts those rows into
`anon_example_weather_rawdata`.

## Usage

``` r
weather_download_and_import_rawdata_action(data, argset, tables)
```

## Arguments

- data:

  Data

- argset:

  Argset

- tables:

  DB tables

## See also

[`weather_download_and_import_rawdata_data_selector()`](https://niphr.github.io/cs9example/reference/weather_download_and_import_rawdata_data_selector.md),
which produces this action's `data` argument. cs9example has no
vignettes of its own; how cs9 pairs an action with a data selector is
documented in
[cs9::SurveillanceSystem_v9](https://niphr.github.io/cs9/reference/SurveillanceSystem_v9.html).

Other cs9 task actions:
[`weather_clean_data_action()`](https://niphr.github.io/cs9example/reference/weather_clean_data_action.md),
[`weather_export_plots_action()`](https://niphr.github.io/cs9example/reference/weather_export_plots_action.md)

## Examples

``` r
if (FALSE) { # \dontrun{
# Needs a live cs9 PostgreSQL database: the last thing the action does is
# upsert into the anon_example_weather_rawdata table.
global$ss$run_task("weather_download_and_import_rawdata")
} # }
```
