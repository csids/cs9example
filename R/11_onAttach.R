# ******************************************************************************
# ******************************************************************************
#
# 11_onAttach.R
#
# PURPOSE 1:
#   What you want to happen when someone types library(yourpackage)
#
# ******************************************************************************
# ******************************************************************************

.onAttach <- function(libname, pkgname) {
  version <- tryCatch(
    utils::packageDescription("cs9example", fields = "Version"),
    warning = function(w){
      1
    }
  )

  packageStartupMessage(paste0("cs9example ",version))
  packageStartupMessage(paste0("cs9 ",utils::packageDescription("cs9", fields = "Version")))
}
