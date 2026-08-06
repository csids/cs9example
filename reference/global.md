# Declaration of environments that can be used globally

cs9example creates `global` empty, and fills it when the package loads.
It holds two things every task needs. `global$border` is the Norwegian
border year the package is configured for. `global$ss` is a
[cs9::SurveillanceSystem_v9](https://niphr.github.io/cs9/reference/SurveillanceSystem_v9.html)
object with every database table and every task already registered.

## Usage

``` r
global
```

## See also

[cs9::SurveillanceSystem_v9](https://niphr.github.io/cs9/reference/SurveillanceSystem_v9.html)
for the class `global$ss` is an instance of, and
[`make_skeleton_date()`](https://niphr.github.io/cs9example/reference/make_skeleton_date.md)
for the skeleton builder the tasks use. cs9example has no vignettes of
its own; the framework is documented in the cs9 package.

## Examples

``` r
# The border year, set when the package loads.
global$border
#> [1] 2024

# The two tables and the three tasks the package registers.
names(global$ss$tables)
#> [1] "anon_example_weather_rawdata" "anon_example_weather_data"   
names(global$ss$tasks)
#> [1] "weather_download_and_import_rawdata" "weather_clean_data"                 
#> [3] "weather_export_plots"               
```
