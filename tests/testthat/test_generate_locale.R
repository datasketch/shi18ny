context("generate locale files")

test_that("i18n Config",{

  x <- "l0"
  expect_equal(undotList(x), list(l0 = "l0"))
  x <- c("l0", "l1.a", "l1.b", "l2.a")
  expect_equal(undotList(x), list(l0 = "l0", l1 = list(a = "a", b = "b"), l2 = list(a = "a")))

  ## TODO FIX RECURSIVE FUNCTIONS
  # x <- c("l0a", "l0b","l0c")
  # x <- "l1.l2.l3"
  # x <- c("l0", "l1.a", "l1.b", "l2.a")
  # x <- c("l0", "l1.a", "l1.b.x", "l1.b.y.foo", "l2.a")


  expect_error(generate_locale(), "Need to provide at least two languages")
  expect_error(generate_locale(langs = "en"), "Need to provide at least two languages")

  file <- system.file("examples/1-shiny-app-lang.R", package = "shi18ny")
  keywords <- i18nGetKeywords(files = file)
  #expect_true("myslang.hi" %in% keywords)
  #expect_true(all(c("this_is_current_lang","myslang.hi","this_is_reactive") %in% keywords))

  src_path <- system.file("examples", package = "shi18ny")
  generate_locale(src_path = src_path, langs = c("pt","it"))
  expect_equal(list.files("locale"), c("it.yaml", "pt.yaml"))
  yamlLocale <- yaml::yaml.load_file(file.path("locale","it.yaml"))
  level1_keywords <- keywords[!grepl("\\.", keywords)]
  expect_true(all(level1_keywords %in% names(yamlLocale)))

  newLocaleDir <- tempdir()
  i18n <- i18nLoad(opts = list(localeDir = newLocaleDir))
  langs <-  c("en", "es", "it")
  generate_locale(src_path = src_path, langs = langs, i18n = i18n)
  expect_equal(list.files(newLocaleDir, pattern = ".yaml"), paste0(langs, ".yaml"))

  yamlLocale2 <- yaml::yaml.load_file(file.path(newLocaleDir,"it.yaml"))
  expect_true(all(level1_keywords %in% names(yamlLocale2)))

  unlink(newLocaleDir, recursive = TRUE)
  unlink("../../locale", recursive = TRUE)

})
