# Package index

## The surveillance system

The package-wide environment that cs9example fills when it loads. It
holds the border year the package is configured for and the
`SurveillanceSystem_v9` object, with every table and task already
registered.

- [`global`](https://niphr.github.io/cs9example/reference/global.md) :
  Declaration of environments that can be used globally

## Task actions

One action per task, listed in pipeline order. Each takes the data its
selector returned, the argset for the current analysis, and the task’s
database tables, then does the work: two write into a table, one writes
a PNG.

- [`weather_download_and_import_rawdata_action()`](https://niphr.github.io/cs9example/reference/weather_download_and_import_rawdata_action.md)
  : weather_download_and_import_rawdata (action)
- [`weather_clean_data_action()`](https://niphr.github.io/cs9example/reference/weather_clean_data_action.md)
  : weather_clean_data (action)
- [`weather_export_plots_action()`](https://niphr.github.io/cs9example/reference/weather_export_plots_action.md)
  : weather_export_plots (action)

## Task data selectors

One data selector per task, in the same order. Each runs once per plan,
before the action, and returns a named list that cs9 hands to the action
as its `data` argument.

- [`weather_download_and_import_rawdata_data_selector()`](https://niphr.github.io/cs9example/reference/weather_download_and_import_rawdata_data_selector.md)
  : weather_download_and_import_rawdata (data selector)
- [`weather_clean_data_data_selector()`](https://niphr.github.io/cs9example/reference/weather_clean_data_data_selector.md)
  : weather_clean_data (data selector)
- [`weather_export_plots_data_selector()`](https://niphr.github.io/cs9example/reference/weather_export_plots_data_selector.md)
  : weather_export_plots (data selector)

## Skeleton builders

Build the complete location-by-time grid before any observation is
merged in, so a location or period with no data stays a visible row
rather than disappearing.

- [`make_skeleton_date()`](https://niphr.github.io/cs9example/reference/make_skeleton_date.md)
  : Create Date-Based Data Skeleton
- [`make_skeleton_isoyearweek()`](https://niphr.github.io/cs9example/reference/make_skeleton_isoyearweek.md)
  : Create ISO Year-Week Data Skeleton
