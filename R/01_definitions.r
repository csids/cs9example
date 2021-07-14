#' Set global definitions
set_definitions <- function() {

  # Norway's last redistricting occurred 020-01-01
  config$border <- 2020

  # fhidata needs to know which border is in use
  fhidata::set_config(
    border = config$border,
    use_current_year_as_1900_pop = TRUE
  )
}
