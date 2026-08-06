# weather_download_and_import_rawdata (data selector)

Takes the mean latitude and longitude of the municipality named in
`argset$location_code`. Downloads the MET Norway location forecast for
that point. Returns it under the name `data`.

## Usage

``` r
weather_download_and_import_rawdata_data_selector(argset, tables)
```

## Arguments

- argset:

  Argset

- tables:

  DB tables

## Value

A named list with one element, `data`: the parsed forecast.

## See also

[`weather_download_and_import_rawdata_action()`](https://niphr.github.io/cs9example/reference/weather_download_and_import_rawdata_action.md),
which consumes this list. cs9example has no vignettes of its own; how
cs9 pairs a data selector with an action is documented in
[cs9::SurveillanceSystem_v9](https://niphr.github.io/cs9/reference/SurveillanceSystem_v9.html).

Other cs9 task data selectors:
[`weather_clean_data_data_selector()`](https://niphr.github.io/cs9example/reference/weather_clean_data_data_selector.md),
[`weather_export_plots_data_selector()`](https://niphr.github.io/cs9example/reference/weather_export_plots_data_selector.md)

## Examples

``` r
if (FALSE) { # \dontrun{
# Needs internet access to api.met.no, and the csmaps package for the
# municipality's coordinates.
weather_download_and_import_rawdata_data_selector(
  argset = list(location_code = "municip_nor0301"),
  tables = NULL
)
} # }
```
