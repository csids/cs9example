# ******************************************************************************
# ******************************************************************************
#
# 09_onAttach.R
#
# PURPOSE 1:
#   What you want to happen when someone types library(yourpackage)
#
# ******************************************************************************
# ******************************************************************************

.onAttach <- function(libname, pkgname) {
  version <- tryCatch(
    utils::packageDescription("sc9example", fields = "Version"),
    warning = function(w){
      1
    }
  )

  packageStartupMessage(paste0("sc9example ",version))
  packageStartupMessage(paste0("sc9 ",utils::packageDescription("sc9", fields = "Version")))
}
