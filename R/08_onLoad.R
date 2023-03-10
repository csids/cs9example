# ******************************************************************************
# ******************************************************************************
#
# 08_onLoad.R
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
  assignInNamespace("clean_tmpfiles", clean_tmpfiles_mod, ns = "rmarkdown")

  invisible()
}
