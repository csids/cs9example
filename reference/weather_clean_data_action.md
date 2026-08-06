# weather_clean_data (action)

Lays out a complete municipality-by-date skeleton with
[`make_skeleton_date()`](https://niphr.github.io/cs9example/reference/make_skeleton_date.md).
Merges the raw weather onto that skeleton. Aggregates it up to county
and to nation. Aggregates the whole lot up again to ISO year-week. The
action formats both granularities as csfmt_rts_data_v2, stacks them, and
writes them to `anon_example_weather_data`. The write replaces whatever
was there.

## Usage

``` r
weather_clean_data_action(data, argset, tables)
```

## Arguments

- data:

  Data

- argset:

  Argset

- tables:

  DB tables

## See also

[`weather_clean_data_data_selector()`](https://niphr.github.io/cs9example/reference/weather_clean_data_data_selector.md),
which produces this action's `data` argument, and
[`make_skeleton_date()`](https://niphr.github.io/cs9example/reference/make_skeleton_date.md)
for the skeleton it starts from. cs9example has no vignettes of its own;
how cs9 pairs an action with a data selector is documented in
[cs9::SurveillanceSystem_v9](https://niphr.github.io/cs9/reference/SurveillanceSystem_v9.html).

Other cs9 task actions:
[`weather_download_and_import_rawdata_action()`](https://niphr.github.io/cs9example/reference/weather_download_and_import_rawdata_action.md),
[`weather_export_plots_action()`](https://niphr.github.io/cs9example/reference/weather_export_plots_action.md)

## Examples

``` r
if (FALSE) { # \dontrun{
# Needs a live cs9 PostgreSQL database: the action ends by dropping every row
# of anon_example_weather_data and inserting the cleaned data in its place.
global$ss$run_task("weather_clean_data")
} # }
```
