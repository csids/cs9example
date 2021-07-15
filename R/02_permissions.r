# ******************************************************************************
# ******************************************************************************
#
# 02_permissions.r
#
# PURPOSE 1:
#   Set permissions that can be used in this package.
#
# PURPOSE 2:
#   Permissions are a way of ensuring that a task only runs once per hour/day/week.
#   This can be useful when you want to be 100% sure that you don't want to spam
#   emails to your recipients.
#
# PURPOSE 3:
#   Permissions can also be used to differentiate between "production days" and
#   "preliminary days". This can be useful when you have different email lists
#   for production days (everyone) and preliminary days (a smaller group).
#
# ******************************************************************************
# ******************************************************************************

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
