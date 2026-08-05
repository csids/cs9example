# ******************************************************************************
# ******************************************************************************
#
# 10_onLoad.R
#
# PURPOSE 1:
#   Initializing everything that happens when the package is loaded.
#
#   E.g. Calling bash scripts that authenticate against Kerebros, setting the
#   configs.
#
# ******************************************************************************
# ******************************************************************************

.onLoad <- function(libname, pkgname) {
  # Mechanism to authenticate as necessary (e.g. Kerebros)
  if (file.exists("/bin/authenticate.sh")) {
    try(system2("/bin/authenticate.sh", stdout = NULL), TRUE)
  }

  # 01_definitions.R
  set_definitions()

  # A SQLite default, so the package runs with no database server and no
  # .Renviron. The block runs only when nothing is configured, so a real
  # .Renviron always wins.
  #
  # cs9 reads the CS9_DBCONFIG_* variables in its own .onLoad(). cs9 is a
  # dependency, so it loads first and has already read the environment by the
  # time this runs: cs9::reload_db_config() is what makes the values below
  # take effect. It must happen before set_db_tables(), which needs
  # config$dbconfigs populated.
  if (Sys.getenv("CS9_DBCONFIG_ACCESS") == "") {
    cs9_path <- fs::path(tempdir(), "cs9example")
    Sys.setenv(
      CS9_AUTO = "0",
      CS9_PATH = cs9_path,
      CS9_DBCONFIG_ACCESS = "config/anon",
      CS9_DBCONFIG_DRIVER = "SQLite",
      CS9_DBCONFIG_DB_CONFIG = fs::path(cs9_path, "config.sqlite"),
      CS9_DBCONFIG_DB_ANON = fs::path(cs9_path, "anon.sqlite")
    )
    cs9::reload_db_config()
  }

  # 02_surveillance_systems.R
  set_surveillance_systems()

  # 03_db_schemas.R
  set_db_tables()

  # 04_tasks.R
  set_tasks()

  # 05_deliverables.R
  # set_deliverables()

  # Formatting for progress bars.
  progressr::handlers(progressr::handler_progress(
    format = "[:bar] :current/:total (:percent) in :elapsedfull, eta: :eta",
    clear = FALSE
  ))

  # https://github.com/rstudio/rmarkdown/issues/1632
  utils::assignInNamespace(
    "clean_tmpfiles",
    clean_tmpfiles_mod,
    ns = "rmarkdown"
  )

  invisible()
}
