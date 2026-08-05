# CS9 Example

[Core Surveillance 9](https://www.csids.no/cs9/) ("cs9") is a free and open-source framework for real-time analysis and disease surveillance.

Read the introduction vignette [here](https://www.csids.no/cs9/articles/cs9.html) or run `help(package="cs9")`.

## No `.Renviron` is needed

`library(cs9example)` runs on a bare machine. When `CS9_DBCONFIG_ACCESS` is empty, the package configures itself against SQLite files under `file.path(tempdir(), "cs9example")` and needs no database server and no `.Renviron`.

## Pointing it at your own database

A `.Renviron` always wins, because the defaults are only applied when `CS9_DBCONFIG_ACCESS` is empty. The override is all or nothing: set `CS9_DBCONFIG_ACCESS` and you own the whole configuration, because none of the other defaults are supplied and a partial one fails to load. Open the file with:

```r
usethis::edit_r_environ("project")
```

Then add these environment variables to keep SQLite but choose the two file paths yourself:

```
CS9_AUTO=0
CS9_PATH='/cs9path'

CS9_DBCONFIG_ACCESS='config/anon'
CS9_DBCONFIG_DRIVER='SQLite'

CS9_DBCONFIG_DB_CONFIG='/cs9path/config.sqlite'
CS9_DBCONFIG_DB_ANON='/cs9path/anon.sqlite'
```

SQLite reads none of `CS9_DBCONFIG_SERVER`, `CS9_DBCONFIG_PORT`, `CS9_DBCONFIG_USER`, `CS9_DBCONFIG_PASSWORD` or any `CS9_DBCONFIG_SCHEMA_*`. For a PostgreSQL configuration instead, see `vignette("installation", package = "cs9")`.

After adding these variables, restart your R session for the changes to take effect.
