.onLoad <- function(libname, pkgname) {
  # Mechanism to authenticate as necessary (e.g. Kerebros)
  try(system2("/bin/authenticate.sh", stdout = NULL), TRUE)

  # 5_config.r
  set_config()

  # https://github.com/rstudio/rmarkdown/issues/1632
  assignInNamespace("clean_tmpfiles", clean_tmpfiles_mod, ns = "rmarkdown")

  invisible()
}
