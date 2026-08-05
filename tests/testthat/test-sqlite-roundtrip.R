# These tests exercise the SQLite defaults that .onLoad() sets when
# CS9_DBCONFIG_ACCESS is empty. Nothing here needs a database server, a
# .Renviron or the network.
#
# weather_download_and_import_rawdata() is deliberately never called: it hits
# the yr.no API once per plan across the 356 unique location codes in
# csmaps::nor_municip_map_b2024_default_dt.

test_that("both tables are registered with no .Renviron", {
  expect_equal(length(global$ss$tables), 2)
  expect_equal(
    names(global$ss$tables),
    c("anon_example_weather_rawdata", "anon_example_weather_data")
  )
})

test_that("the tables are backed by SQLite", {
  # The two names are spelled out rather than read from names(global$ss$tables),
  # so an empty table list fails this block instead of skipping it as an empty
  # test.
  for (table_name in c(
    "anon_example_weather_rawdata",
    "anon_example_weather_data"
  )) {
    config <- global$ss$tables[[table_name]]$dbconnection$config
    expect_identical(config$driver, "SQLite")
    expect_identical(
      config$db,
      as.character(fs::path(tempdir(), "cs9example", "anon.sqlite"))
    )
  }
})

test_that("the config and anon accesses use different SQLite files", {
  # cs9's four configuration tables are built from the `config` access, this
  # package's two tables from the `anon` access. The defaults must give the two
  # accesses separate files, and this is the one property of them that a wrong
  # value can break without also stopping .onLoad() from completing.
  db_config <- cs9::config$tables$config_log$dbconnection$config$db
  db_anon <- global$ss$tables$anon_example_weather_rawdata$dbconnection$config$db

  expect_false(db_config == db_anon)
  expect_identical(
    db_config,
    as.character(fs::path(tempdir(), "cs9example", "config.sqlite"))
  )
  expect_identical(
    db_anon,
    as.character(fs::path(tempdir(), "cs9example", "anon.sqlite"))
  )
})

test_that("a synthetic row round-trips through insert_data and tbl", {
  tab <- global$ss$tables$anon_example_weather_rawdata

  # Satisfies csdb::validator_field_contents_csfmt_rts_data_v2, which
  # anon_example_weather_rawdata declares.
  d <- data.table::data.table(
    granularity_time = "date",
    granularity_geo = "nation",
    country_iso3 = "nor",
    location_code = "nation_nor",
    border = 2024L,
    age = "total",
    sex = "total",
    isoyear = 2024L,
    isoweek = 1L,
    isoyearweek = "2024-01",
    isoquarter = 1L,
    isoyearquarter = "2024-Q1",
    season = "2023/2024",
    seasonweek = 27,
    calyear = 2024L,
    calmonth = 1L,
    calyearmonth = "2024-01",
    date = as.Date("2024-01-01"),
    temp_max = 1.5,
    temp_min = -3.5,
    precip = 0.2
  )

  # The table is created lazily, on first use, so this is also what creates it.
  tab$drop_all_rows()
  tab$insert_data(d)

  out <- dplyr::collect(tab$tbl())

  # No ncol() assertion on d: cs9's DBTableExtended_v9 adds
  # auto_last_updated_datetime to the caller's data.table by reference.
  expect_equal(nrow(out), 1)
  expect_s3_class(out$date, "Date")
  expect_identical(out$date, as.Date("2024-01-01"))
  expect_identical(out$location_code, "nation_nor")
  expect_identical(out$border, 2024L)
  expect_identical(out$temp_max, 1.5)
  expect_identical(out$precip, 0.2)

  # dplyr::n() comes back an integer on SQLite where the other backends give a
  # numeric, so this compares with == rather than identical().
  n <- dplyr::collect(dplyr::summarize(tab$tbl(), n = dplyr::n()))$n
  expect_true(n == 1)
})
