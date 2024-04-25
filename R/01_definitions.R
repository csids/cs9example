# ******************************************************************************
# ******************************************************************************
#
# 01_definitions.R
#
# PURPOSE 1:
#   Set global definitions that are used throughout the package, and further
#   (e.g. in shiny/plumber creations).
#
#   Examples of global definitions are:
#     - Border years
#     - Age definitions
#     - Diagnosis mappings (e.g. "R80" = "Influenza")
#
# ******************************************************************************
# ******************************************************************************

#' Set global definitions
set_definitions <- function() {

  # Norway's last redistricting occurred 2024-01-01
  global$border <- 2024

  csdata::set_config(
    border_nor = global$border
  )
}
