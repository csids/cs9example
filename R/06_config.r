set_config <- function() {
  # 01_definitions.r
  set_definitions()

  # 02_permissions.r
  set_permissions()

  # 03_db_schemas.r
  set_db_schemas()

  # 04_tasks.r
  set_tasks()

  # 05_deliverables.r
  set_deliverables()

  # 06_config.r
  set_progressr()
}

set_progressr <- function() {
  progressr::handlers(progressr::handler_progress(
    format = "[:bar] :current/:total (:percent) in :elapsedfull, eta: :eta",
    clear = FALSE
  ))
}
