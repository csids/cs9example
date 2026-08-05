# weather_clean_data (data selector)

Pulls the daily, municipality-level, total-age, total-sex rows out of
`anon_example_weather_rawdata` and returns them under the name
`date_municip`, ordered by location and date.

## Usage

``` r
weather_clean_data_data_selector(argset, tables)
```

## Arguments

- argset:

  Argset

- tables:

  DB tables

## Value

A named list with one element, `date_municip`: a `data.table` of
`granularity_time`, `location_code`, `date`, `temp_max`, `temp_min` and
`precip`.

## See also

[`weather_clean_data_action()`](https://niphr.github.io/cs9example/reference/weather_clean_data_action.md),
which consumes this list, and
[`cs9::mandatory_db_filter()`](https://niphr.github.io/cs9/reference/mandatory_db_filter.html)
for the filter it applies. cs9example has no vignettes of its own; how
cs9 pairs a data selector with an action is documented in
[cs9::SurveillanceSystem_v9](https://niphr.github.io/cs9/reference/SurveillanceSystem_v9.html).

Other cs9 task data selectors:
[`weather_download_and_import_rawdata_data_selector()`](https://niphr.github.io/cs9example/reference/weather_download_and_import_rawdata_data_selector.md),
[`weather_export_plots_data_selector()`](https://niphr.github.io/cs9example/reference/weather_export_plots_data_selector.md)

## Examples

``` r
if (FALSE) { # \dontrun{
# Needs a live cs9 PostgreSQL database: it reads the
# anon_example_weather_rawdata table.
weather_clean_data_data_selector(
  argset = global$ss$shortcut_get_argset("weather_clean_data"),
  tables = global$ss$shortcut_get_tables("weather_clean_data")
)
} # }
```
