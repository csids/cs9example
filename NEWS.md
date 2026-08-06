# cs9example 26.8.6

## Licensing

- The copyright holder is now **Folkehelseinstituttet**. It read "cs9example authors", which
  was a template placeholder.
- `DESCRIPTION` `Authors@R` now declares that holder with `role = "cph"`.
  It declared no copyright holder at all, and neither did any other package
  in the fleet. Nothing in `R CMD check` reports that.
- The copyright year is now 2026. It read 2021.
- `CLAUDE.md` now carries a Licensing section, so the year gets checked
  rather than silently ageing.

- Fixed two `README.md` links that pointed at `www.csids.no`. The introduction
  vignette link returned 404 there. Both now point at `niphr.github.io`, which
  is the URL cs9's own `DESCRIPTION` and `_pkgdown.yml` declare, and which
  returns 200.

- Brought the prose in `R/`, `README.md`, `index.md` and `NEWS.md` to the house
  standard: ASD-STE100 (Simplified Technical English), adapted. Split the long
  sentences, and turned the buried lists into real lists.
  - Sentences over 25 words, measured per authored unit, before and after:
    `R/` 4 to 0, `README.md` 1 to 0, `NEWS.md` 12 to 0. `index.md` was already
    at 0.
  - Regenerated `man/` from the edited roxygen. `NAMESPACE` is unchanged, and
    all 10 help pages remain.
  - `index.md` keeps the `cs-*` class names, which are the ones `cstemplate`
    defines. An `rw-*` prefix would silently drop the card styling.
- No code, documented function behaviour or documented number changed in this
  version.

# cs9example 26.8.5

- Removed `no_data_plot()`, and with it `R/99_util_no_data_plot.R`. It was never
  exported and never called. That is why a stale `fhi::` reference survived
  inside it undetected for so long. The name sat in a `glue()` string, where
  static analysis cannot see it. Deleting it removes the whole class of problem
  rather than the one instance.
- Removed `knitr` from `Suggests` and dropped the `VignetteBuilder` field. The
  package ships no vignettes, so both were vestigial and `R CMD check` reported
  the mismatch. `rmarkdown` stays in `Imports`: it is a genuine load-time
  dependency, named by a string in `assignInNamespace(ns = "rmarkdown")`.
- `library(cs9example)` now runs with no database server and no `.Renviron`. When `CS9_DBCONFIG_ACCESS` is empty, `.onLoad()` configures a SQLite backend under `file.path(tempdir(), "cs9example")` and calls `cs9::reload_db_config()`, so both tables register against SQLite files. A `.Renviron` still wins: the defaults are only applied when the variable is empty.
- Added a test suite that needs no database server and no network. `tests/testthat/test-sqlite-roundtrip.R` asserts four things:
  - both tables register;
  - SQLite backs both of them;
  - the `config` and `anon` accesses use different SQLite files;
  - a synthetic row round-trips through `insert_data()` and `tbl()`.
- `README.md` no longer tells the reader to hand-write a PostgreSQL `.Renviron` before anything works.
- `.onLoad()` now calls `utils::assignInNamespace()` rather than bare
  `assignInNamespace()`. `utils` is not attached during the minimal-namespace
  load that `R CMD check` performs. The bare call therefore raised `could not
  find function "assignInNamespace"`, and failed `.onLoad()` outright. That
  produced three WARNINGs:
  - `checking whether the package can be loaded with stated dependencies`;
  - `checking whether the package can be unloaded cleanly`;
  - `checking whether the namespace can be loaded with stated dependencies`.

  All three are gone. `utils` is a base-priority package, so the check does not
  ask for it in `Imports`. It was not added there. `R/11_onAttach.R` already
  called `utils::packageDescription()` on the same terms.
- The package became loadable at all once `plnr` was fixed. `.onLoad()` calls
  `set_tasks()`, which reaches `plnr::Plan$add_analysis_from_list()`, and that
  method read an undefined `df` that only resolved because `stats::df` happened
  to be on the search path. Loading died there first, which is why the
  `assignInNamespace()` defect behind it had never been seen. Fixed in plnr
  2026.8.3.
- `DESCRIPTION` now carries `Remotes: niphr/cs9, raubreywhite/plnr`. Without it
  CI died before `R CMD check` ever started. pak reported `Can't find package
  called cs9`, because `cs9` is in `Imports:` and is not on CRAN. `plnr` is on
  CRAN, but only at 2025.11.22, which still reads the undefined `df` in
  `Plan$add_analysis_from_list()`. A CRAN resolution of `plnr` therefore
  installs a version that makes `.onLoad()` die with `object 'df' not found`
  whenever `stats` is not attached. That is exactly the condition `R CMD check`
  uses for `checking whether the package can be loaded with stated
  dependencies`. Note the two different owners: `cs9` is `niphr/cs9`, `plnr` is
  `raubreywhite/plnr`. `csdb` needs no entry of its own. cs9 declares
  `csdb (>= 2026.8.5)` together with `Remotes: niphr/csdb`, and pak follows that
  transitively. `csdb` therefore resolves from GitHub at 2026.8.5 rather than
  the CRAN 2026.5.13.
- `DESCRIPTION` now declares `Config/Needs/website: niphr/cstemplate`, which was
  missing. `_pkgdown.yml` sets `template: package: cstemplate`. cstemplate is
  not on CRAN, and nothing else in the package named it. The pkgdown build
  therefore had no template to load. The gap stayed invisible because the
  `pkgdown` job in
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
- The `DESCRIPTION` `Description:` field now ends in a full stop. That clears
  `R CMD check`'s `Malformed Description field: should contain one or more
  complete sentences.` The wording is unchanged.
- Fixed `weather_export_plots_data_selector()`, which read `index_analysis`
  without ever assigning it. The `if (plnr::is_run_directly())` block set only
  `index_plan <- 1`, then passed `index_analysis` to
  `global$ss$shortcut_get_argset()`. The three sibling blocks all assign it
  first. This was a copy from the action body with the `index_analysis <- 1`
  line dropped. The guard is FALSE under normal package use, so the defect never
  fired in production. It fired the moment a developer stepped through the data
  selector interactively. That is the only reason the block exists. R then
  either raised `object 'index_analysis' not found`, or silently used a stale
  value left in the global environment. Note that
  `weather_clean_data_data_selector()` is correct as written and is unchanged.
  It omits `index_analysis` from the call entirely, which is the other valid
  shape.
- `no_data_plot()` no longer calls `fhi::nb$aa`. `fhi` is not a declared
  dependency and is not installed, so the function raised
  `Failed to evaluate glue component {fhi::nb$aa}` on every call. No static
  analysis could see it, because the name sits inside a `glue::glue()` string.
  The value is the character `å`, confirmed against `csdata::nb$aa` and
  against the same function in norsyss.cs9, which had already made this exact
  substitution. The literal replaces the call, so the label reads
  `Ikke noe data å vise` as intended. `fhi` was not added to `Imports:`.
- `R/00_env_and_namespace.R` now declares the data.table and dplyr
  non-standard-evaluation column names in `utils::globalVariables()`. Fourteen
  names were reported by `checking R code for possible problems` and each was
  traced to a `[...]`, `:=` or `dplyr::select()` site before being declared.
  `index_analysis` was deliberately left out: it was a real bug, fixed above,
  not NSE. The check's `importFrom("datasets", "precip")` suggestion was not
  followed, because `precip` here is a weather column this package builds.
- `.Rbuildignore` now excludes `.github` and `LICENSE.md`, which cleared
  `checking for hidden files and directories` and `checking top-level files`.
  The `LICENSE` file named by `License: MIT + file LICENSE` still ships.

# cs9example 26.8.4

- Added a pkgdown site: `_pkgdown.yml` on the `cstemplate` house template, an `index.md` home page, and a generated hex logo (`dev/logo.R` -> `man/figures/logo.png`).
- Documented every exported function with a description, `@seealso` and `@family`, and added runnable examples where one can run without a database. `weather_export_plots_action()`, `make_skeleton_date()`, `make_skeleton_isoyearweek()` and `global` now have examples that execute. The five that need a live PostgreSQL database or internet access are marked `\dontrun{}` and say why.
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
