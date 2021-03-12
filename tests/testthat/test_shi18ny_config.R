context("config")

test_that("i18n Config",{

  # Default options
  opts <- NULL
  config <- i18nConfig()

  i18n <- i18nLoad()

  expect_equal(names(i18n), c(shi18ny::available_langs$lang, ".config"))
  # expect_true("shi18ny" %in% names(i18n$en))

  str <- "language"
  expect_equal(i_(str,lang = "en"), "language")
  expect_equal(i_(str,lang = "es"), "idioma")
  expect_equal(i_(str,lang = "pt"), "língua")
  expect_equal(i_(str,lang = "de"), "Sprache")
  expect_equal(i_(str,lang = "fr"), "la langue")
  expect_equal(i_(str,lang = "ru"), "язык")


  l <- i18nLoad()$en
  localeString <- "common.language"
  strs <- strsplit(localeString,".",fixed = TRUE)[[1]]


  localeDir <- system.file("tests", "testthat", "locale_test", package = "shi18ny")
  opts <- list(
    localeDir = localeDir,
    availableLangs = c("en","es")
  )
  config <- i18nConfig(opts)
  i18n <- i18nLoad(opts)
  expect_true(all(opts$availableLans %in% names(i18n)))

  opts <- list(
    localeDir = localeDir,
    availableLangs = c("pt","es")
  )
  config <- i18nConfig(opts)
  expect_error(i18nLoad(opts),"Requested languages not in locale folder")

  # test config works for csv translations
  opts <- list(
    localeDir = localeDir,
    availableLangs = c("en","es"),
    customTranslationSource = "csv"
  )
  config <- i18nConfig(opts)
  i18n <- i18nLoad(opts)
  expect_true(all(opts$availableLans %in% names(i18n)))

  # test error when languages unavailable in "translations.csv"
  opts <- list(
    localeDir = localeDir,
    availableLangs = c("en","pt"),
    customTranslationSource = "csv"
  )
  config <- i18nConfig(opts)
  expect_error(i18nLoad(opts), "Requested languages not in translations.csv file.")

  # test error when customTranslationSource = "csv" but no file "translations.csv" in locale folder
  localeDir <- system.file("tests", "testthat", "locale", package = "shi18ny")
  opts <- list(
    localeDir = localeDir,
    availableLangs = c("en","es"),
    customTranslationSource = "csv"
  )
  config <- i18nConfig(opts)
  expect_error(i18nLoad(opts), "Need translations.csv file in locale folder.")

  # test error when "translations.csv" has no id column
  localeDir <- system.file("tests", "testthat", "locale_csv", package = "shi18ny")
  opts <- list(
    localeDir = localeDir,
    availableLangs = c("en","es"),
    customTranslationSource = "csv"
  )
  config <- i18nConfig(opts)
  expect_error(i18nLoad(opts), "Need id column for translations.")



})



