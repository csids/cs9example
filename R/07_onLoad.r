# ******************************************************************************
# ******************************************************************************
#
# 07_onLoad.r
#
# PURPOSE 1:
#   Initializing everything that happens when the package is loaded.
#
#   E.g. Calling bash scripts that authenticate against Kerebros, setting the
#   configs as defined in 06_config.r.
#
# ******************************************************************************
# ******************************************************************************

.onLoad <- function(libname, pkgname) {
  # Mechanism to authenticate as necessary (e.g. Kerebros)
  if (file.exists("/bin/authenticate.sh")) {
    try(system2("/bin/authenticate.sh", stdout = NULL), TRUE)
  }

  # 5_config.r
  set_config()

  # https://github.com/rstudio/rmarkdown/issues/1632
  assignInNamespace("clean_tmpfiles", clean_tmpfiles_mod, ns = "rmarkdown")

  invisible()
}
