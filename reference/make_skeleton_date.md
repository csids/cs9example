# Create Date-Based Data Skeleton

Creates a data skeleton with complete date sequences and location codes
for the geographic granularities you specify.

## Usage

``` r
make_skeleton_date(
  date_min,
  date_max,
  granularity_geo,
  location_reference = csdata::nor_locations_names()
)
```

## Arguments

- date_min:

  Start date (Date or character in YYYY-MM-DD format)

- date_max:

  End date (Date or character in YYYY-MM-DD format)

- granularity_geo:

  Vector of granularity_geo values to include

- location_reference:

  Location reference data, defaults to csdata::nor_locations_names()

## Value

data.table with complete skeleton

## See also

[`weather_clean_data_action()`](https://niphr.github.io/cs9example/reference/weather_clean_data_action.md),
the task action that starts from this skeleton, and
[`csdata::nor_locations_names()`](https://niphr.github.io/csdata/reference/nor_locations_names.html)
for the default location reference. cs9example has no vignettes of its
own; the framework is documented in the cs9 package.

Other skeleton builders:
[`make_skeleton_isoyearweek()`](https://niphr.github.io/cs9example/reference/make_skeleton_isoyearweek.md)

## Examples

``` r
# Every county, every day of the first week of 2024, with no data merged in
# yet: 15 counties x 7 days.
skeleton <- make_skeleton_date(
  date_min = "2024-01-01",
  date_max = "2024-01-07",
  granularity_geo = "county"
)
nrow(skeleton)
#> [1] 105
head(skeleton)
#> Key: <location_code, date>
#>    granularity_time location_code       date granularity_geo
#>              <char>        <char>     <Date>          <char>
#> 1:             date  county_nor03 2024-01-01          county
#> 2:             date  county_nor03 2024-01-02          county
#> 3:             date  county_nor03 2024-01-03          county
#> 4:             date  county_nor03 2024-01-04          county
#> 5:             date  county_nor03 2024-01-05          county
#> 6:             date  county_nor03 2024-01-06          county
```
