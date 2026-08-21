# `R CMD check` walks top-level function definitions to decide which declared
# Imports are used. Two forms are invisible to it, and both appear in this
# package:
#
#   1. A `pkg::fn()` call inside the `public = list(...)` of an `R6Class`.
#   2. A package named as a STRING rather than by `::`, as in
#      `utils::assignInNamespace(..., ns = "rmarkdown")` in R/10_onLoad.R.
#
# Naming them once in a plain top-level function is enough for the scan to see
# them. It changes no behaviour: the function is never called, and evaluating a
# `pkg::fn` name has no effect.
#
# Do NOT add a package here to silence the note. A package that is genuinely
# unused should be removed from Imports instead.
ignore_unused_imports <- function() {
  rmarkdown::render # via ns = "rmarkdown" in R/10_onLoad.R
  progress::progress_bar # via progressr::handler_progress() in R/10_onLoad.R
}
