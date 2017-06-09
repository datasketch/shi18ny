context("config")

test_that("i18n Config",{

  opts <- NULL
  config <- i18nConfig()
  i18n <- i18nLoad()

  localeDir <- system.file("examples/locale",package = "shi18ny")
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
  expect_error(i18nLoad(opts),"Requesting languages not in locale folder")

  opts <- list(
    localeDir = localeDir,
    defaultLang = "es",
    fallbacks = list("es" = "en")
  )
  config <- i18nConfig(opts)

  i18n <- i18nLoad(opts)
  i18n <- i18nLoad()



  ###

  l <- i18nLoad()$en
  localeString <- "common.language"
  strs <- strsplit(localeString,".",fixed = TRUE)[[1]]
  selectInList(l,strs)



  i_("common.language", "en", i18n = NULL)



})
