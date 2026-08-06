# Create ISO Year-Week Data Skeleton

Creates a data skeleton with complete ISO year-week sequences and
location codes for the geographic granularities you specify.

## Usage

``` r
make_skeleton_isoyearweek(
  isoyearweek_min,
  isoyearweek_max,
  granularity_geo,
  location_reference = csdata::nor_locations_names()
)
```

## Arguments

- isoyearweek_min:

  Start ISO year-week (character in YYYY-WW format)

- isoyearweek_max:

  End ISO year-week (character in YYYY-WW format)

- granularity_geo:

  Vector of granularity_geo values to include

- location_reference:

  Location reference data, defaults to csdata::nor_locations_names()

## Value

data.table with complete skeleton

## See also

[`make_skeleton_date()`](https://niphr.github.io/cs9example/reference/make_skeleton_date.md)
for the daily equivalent, and
[`csdata::nor_locations_names()`](https://niphr.github.io/csdata/reference/nor_locations_names.html)
for the default location reference. cs9example has no vignettes of its
own; the framework is documented in the cs9 package.

Other skeleton builders:
[`make_skeleton_date()`](https://niphr.github.io/cs9example/reference/make_skeleton_date.md)

## Examples

``` r
# Every county, the first three ISO weeks of 2024: 15 counties x 3 weeks.
skeleton <- make_skeleton_isoyearweek(
  isoyearweek_min = "2024-01",
  isoyearweek_max = "2024-03",
  granularity_geo = "county"
)
nrow(skeleton)
#> [1] 45
head(skeleton)
#> Key: <location_code, isoyearweek>
#>    granularity_time location_code isoyearweek granularity_geo
#>              <char>        <char>      <char>          <char>
#> 1:      isoyearweek  county_nor03     2024-01          county
#> 2:      isoyearweek  county_nor03     2024-02          county
#> 3:      isoyearweek  county_nor03     2024-03          county
#> 4:      isoyearweek  county_nor11     2024-01          county
#> 5:      isoyearweek  county_nor11     2024-02          county
#> 6:      isoyearweek  county_nor11     2024-03          county
```
