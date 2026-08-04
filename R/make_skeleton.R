#' Create Date-Based Data Skeleton
#'
#' Creates a comprehensive data skeleton with complete date sequences and location codes
#' for specified geographic granularities.
#'
#' @param date_min Start date (Date or character in YYYY-MM-DD format)
#' @param date_max End date (Date or character in YYYY-MM-DD format)
#' @param granularity_geo Vector of granularity_geo values to include
#' @param location_reference Location reference data, defaults to csdata::nor_locations_names()
#'
#' @return data.table with complete skeleton
#'
#' @family skeleton builders
#' @seealso [weather_clean_data_action()], the task action that starts from this
#'   skeleton, and [csdata::nor_locations_names()] for the default location
#'   reference. cs9example has no vignettes of its own; the framework is
#'   documented in the cs9 package.
#' @examples
#' # Every county, every day of the first week of 2024, with no data merged in
#' # yet: 15 counties x 7 days.
#' skeleton <- make_skeleton_date(
#'   date_min = "2024-01-01",
#'   date_max = "2024-01-07",
#'   granularity_geo = "county"
#' )
#' nrow(skeleton)
#' head(skeleton)
#' @export
make_skeleton_date <- function(
  date_min,
  date_max,
  granularity_geo,
  location_reference = csdata::nor_locations_names()
) {
  # Input validation
  if (missing(date_min) || missing(date_max) || missing(granularity_geo)) {
    stop("date_min, date_max, and granularity_geo are required arguments")
  }

  # Convert dates if needed
  if (is.character(date_min)) {
    date_min <- as.Date(date_min)
  }
  if (is.character(date_max)) {
    date_max <- as.Date(date_max)
  }

  # Validate date order
  if (date_min > date_max) {
    stop("date_min must be <= date_max")
  }

  # Create date sequence
  dates <- seq.Date(from = date_min, to = date_max, by = "day")

  # Get valid location codes for this granularity type
  gran_geo_values <- granularity_geo
  valid_locations <- location_reference[granularity_geo %in% gran_geo_values]

  if (nrow(valid_locations) == 0) {
    warning(sprintf(
      "No valid locations found for granularity_geo values: %s",
      paste(granularity_geo, collapse = ", ")
    ))
    return(data.table::data.table())
  }

  # Create complete skeleton using CJ directly
  retval <- data.table::CJ(
    granularity_time = "date",
    location_code = valid_locations$location_code,
    date = dates,
    sorted = TRUE
  )

  # Add granularity_geo using csdata function
  csdata::add_granularity_geo_to_data_set(
    retval,
    location_reference = location_reference
  )

  # Set key for efficient operations
  data.table::setkeyv(retval, c("location_code", "date"))

  return(retval)
}


#' Create ISO Year-Week Data Skeleton
#'
#' Creates a comprehensive data skeleton with complete ISO year-week sequences and location codes
#' for specified geographic granularities.
#'
#' @param isoyearweek_min Start ISO year-week (character in YYYY-WW format)
#' @param isoyearweek_max End ISO year-week (character in YYYY-WW format)
#' @param granularity_geo Vector of granularity_geo values to include
#' @param location_reference Location reference data, defaults to csdata::nor_locations_names()
#'
#' @return data.table with complete skeleton
#'
#' @family skeleton builders
#' @seealso [make_skeleton_date()] for the daily equivalent, and
#'   [csdata::nor_locations_names()] for the default location reference.
#'   cs9example has no vignettes of its own; the framework is documented in the
#'   cs9 package.
#' @examples
#' # Every county, the first three ISO weeks of 2024: 15 counties x 3 weeks.
#' skeleton <- make_skeleton_isoyearweek(
#'   isoyearweek_min = "2024-01",
#'   isoyearweek_max = "2024-03",
#'   granularity_geo = "county"
#' )
#' nrow(skeleton)
#' head(skeleton)
#' @export
make_skeleton_isoyearweek <- function(
  isoyearweek_min,
  isoyearweek_max,
  granularity_geo,
  location_reference = csdata::nor_locations_names()
) {
  # Input validation
  if (
    missing(isoyearweek_min) ||
      missing(isoyearweek_max) ||
      missing(granularity_geo)
  ) {
    stop(
      "isoyearweek_min, isoyearweek_max, and granularity_geo are required arguments"
    )
  }

  # Get sequence of ISO year-weeks
  isoyearweeks <- cstime::dates_by_isoyearweek[
    isoyearweek >= isoyearweek_min & isoyearweek <= isoyearweek_max
  ]$isoyearweek

  # Get valid location codes for this granularity type
  gran_geo_values <- granularity_geo
  valid_locations <- location_reference[granularity_geo %in% gran_geo_values]

  if (nrow(valid_locations) == 0) {
    warning(sprintf(
      "No valid locations found for granularity_geo values: %s",
      paste(granularity_geo, collapse = ", ")
    ))
    return(data.table::data.table())
  }

  # Create complete skeleton using CJ directly
  retval <- data.table::CJ(
    granularity_time = "isoyearweek",
    location_code = valid_locations$location_code,
    isoyearweek = isoyearweeks,
    sorted = TRUE
  )

  # Add granularity_geo using csdata function
  csdata::add_granularity_geo_to_data_set(
    retval,
    location_reference = location_reference
  )

  # Set key for efficient operations
  data.table::setkeyv(retval, c("location_code", "isoyearweek"))

  return(retval)
}
