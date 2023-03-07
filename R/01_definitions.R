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

  # Norway's last redistricting occurred 2020-01-01
  global$border <- 2020

  # fhidata needs to know which border is in use
  # fhidata should also replace the population of 1900 with the current year,
  # because year = 1900 is shorthand for granularity_geo = "total".
  # This means that it is more appropriate to use the current year's population
  # for year = 1900.
  fhidata::set_config(
    border = global$border,
    use_current_year_as_1900_pop = TRUE
  )
}
