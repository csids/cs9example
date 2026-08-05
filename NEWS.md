# cs9example 26.8.5

- `library(cs9example)` now runs with no database server and no `.Renviron`. When `CS9_DBCONFIG_ACCESS` is empty, `.onLoad()` configures a SQLite backend under `file.path(tempdir(), "cs9example")` and calls `cs9::reload_db_config()`, so both tables register against SQLite files. A `.Renviron` still wins: the defaults are only applied when the variable is empty.
- Added a test suite. `tests/testthat/test-sqlite-roundtrip.R` asserts that both tables register, that they are backed by SQLite, that the `config` and `anon` accesses use different SQLite files, and that a synthetic row round-trips through `insert_data()` and `tbl()`. It needs no database server and no network.
- `README.md` no longer tells the reader to hand-write a PostgreSQL `.Renviron` before anything works.
- `.onLoad()` now calls `utils::assignInNamespace()` rather than bare
  `assignInNamespace()`. `utils` is not attached during the minimal-namespace
  load that `R CMD check` performs, so the bare call raised `could not find
  function "assignInNamespace"` and failed `.onLoad()` outright. That produced
  three WARNINGs: `checking whether the package can be loaded with stated
  dependencies`, `checking whether the package can be unloaded cleanly` and
  `checking whether the namespace can be loaded with stated dependencies`. All
  three are gone. `utils` is a base-priority package, so the check does not ask
  for it in `Imports` and it was not added there; `R/11_onAttach.R` already
  called `utils::packageDescription()` on the same terms.
- The package became loadable at all once `plnr` was fixed. `.onLoad()` calls
  `set_tasks()`, which reaches `plnr::Plan$add_analysis_from_list()`, and that
  method read an undefined `df` that only resolved because `stats::df` happened
  to be on the search path. Loading died there first, which is why the
  `assignInNamespace()` defect behind it had never been seen. Fixed in plnr
  2026.8.3.
- `DESCRIPTION` now carries `Remotes: niphr/cs9, raubreywhite/plnr`. Without it
  CI died before `R CMD check` ever started: pak reported `Can't find package
  called cs9`, because `cs9` is in `Imports:` and is not on CRAN. `plnr` is on
  CRAN, but only at 2025.11.22, which still reads the undefined `df` in
  `Plan$add_analysis_from_list()`. Resolving `plnr` from CRAN therefore installs
  a version that makes `.onLoad()` die with `object 'df' not found` whenever
  `stats` is not attached, which is exactly the condition `R CMD check` uses for
  `checking whether the package can be loaded with stated dependencies`. Note the
  two different owners: `cs9` is `niphr/cs9`, `plnr` is `raubreywhite/plnr`.
  `csdb` needs no entry of its own. cs9 declares `csdb (>= 2026.8.5)` together
  with `Remotes: niphr/csdb`, and pak follows that transitively, so `csdb`
  resolves from GitHub at 2026.8.5 rather than the CRAN 2026.5.13.
- `DESCRIPTION` now declares `Config/Needs/website: niphr/cstemplate`, which was
  missing. `_pkgdown.yml` sets `template: package: cstemplate`, cstemplate is not
  on CRAN, and nothing else in the package named it, so the pkgdown build had no
  template to load. The gap stayed invisible because the `pkgdown` job in
  `.github/workflows/check-and-pkgdown.yml` has `needs: R-CMD-check` and so never
  ran while dependency resolution was failing. This is a third inline GitHub ref
  with a third owner: `r-lib/actions/setup-r-dependencies` reads this field for
  its `needs: website` step. Ordinary `Imports:` resolution does not read it, so
  it is not interchangeable with a `Remotes:` entry. cs9 and csdb declare the
  same value; plnr declares `raubreywhite/pkgdowntemplate`.
- `DESCRIPTION` `Imports:` now matches what the code actually uses. Nine
  namespaces were reached through `::` without being declared, and are now
  declared: `csdb`, `csmaps`, `cstidy`, `cstime`, `glue`, `httr`, `plnr`,
  `progressr` and `stringr`. Three were declared without being used anywhere in
  the package, and are removed: `janitor`, `merTools` and `tidyr`. None of the
  three appears in any file outside `DESCRIPTION` itself, including string
  literals; `tidyr` was superseded by `data.table::CJ()` in
  `make_skeleton_date()` and `make_skeleton_isoyearweek()`.
- `rmarkdown` stays in `Imports:` even though `R CMD check` reports it as
  unused. `.onLoad()` calls
  `utils::assignInNamespace("clean_tmpfiles", clean_tmpfiles_mod, ns = "rmarkdown")`,
  which names the package as a string, so no static analysis can see it. Loading
  cs9example does load the `rmarkdown` namespace, and `assignInNamespace()`
  raises `there is no package called` when the namespace is absent. The
  remaining `Namespace in Imports field not imported from: 'rmarkdown'` NOTE is
  the honest price of a real dependency that cannot be spelled with `::`.
- The `DESCRIPTION` `Description:` field now ends in a full stop, which clears
  `R CMD check`'s `Malformed Description field: should contain one or more
  complete sentences.` The wording is unchanged.

# cs9example 26.8.4

- Added a pkgdown site: `_pkgdown.yml` on the `cstemplate` house template, an `index.md` home page, and a generated hex logo (`dev/logo.R` -> `man/figures/logo.png`).
- Documented every exported function with a description, `@seealso` and `@family`, and added runnable examples where one can run without a database. `weather_export_plots_action()`, `make_skeleton_date()`, `make_skeleton_isoyearweek()` and `global` now have examples that execute; the five that need a live PostgreSQL database or internet access are marked `\dontrun{}` and say why.
- `make_skeleton_date()` and `make_skeleton_isoyearweek()` are now actually exported. Both carried `@export` since they were added, but `NAMESPACE` had not been regenerated, so neither was reachable as `cs9example::make_skeleton_date()`.

## Development

- Documentation is generated by roxygen2 8.0.0. `DESCRIPTION` now declares `Config/roxygen2/version` in place of `RoxygenNote`, and every `.Rd` file was regenerated by that version. `NAMESPACE` is unchanged.

# cs9example 25.6.24

- Updated database schema to include quarterly fields (isoquarter, isoyearquarter)
- Upgraded table validators from v1 to v2 format
- Updated weather data source to use municipality-level locations
- Enhanced README with Posit Studio/Workbench setup instructions
- Streamlined package structure by removing unused COVID-19 functionality

# cs9example 2021-07-13

- Package skeleton created
