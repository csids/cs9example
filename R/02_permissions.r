set_permissions <- function() {
  # sc::add_permission(
  #   name = "khtemails_send_emails",
  #   permission = sc::Permission$new(
  #     key = "khtemails_send_emails",
  #     value = as.character(lubridate::today()),  # one time per day
  #     production_days = c(3) # wed, send to everyone, otherwise prelim
  #   )
  # )
}
