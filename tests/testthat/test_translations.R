context("Translations")

test_that("i18n Config",{

  # Custom translations

  localeDir <- system.file("tests", "testthat", "locale_test", package = "shi18ny")
  i18n <- list(
    localeDir = localeDir,
    defaultLang = "es",
    fallbacks = list("es" = "en")
  )
  config <- i18nConfig(i18n)

  expect_equal(i_("myslang.hi","es",i18n), "Quiubo")
  expect_equal(i_("myslang.hi","en",i18n), "Zup")

  expect_equal(i_("myslang.surprise","es",i18n), "¡Mierda!")
  expect_equal(i_("myslang.surprise","en",i18n), "WTF!")

  expect_equal(i_("undefined.surprise","es",i18n), "undefined.surprise")

  str <- c("download", "upload")
  lang <- "es"
  expect_equal(i_(str, lang), c("descargar", "subir"))

  # Override default with custom translations
  expect_equal(i_("hello", "es"), "hola")
  expect_equal(i_("hello", "es", i18n), "Hola!!!")


})





