context("Translations")

test_that("i18n Config",{

  # Custom translations

  localeDir <- system.file("examples/locale",package = "shi18ny")
  opts <- list(
    localeDir = localeDir,
    defaultLang = "es",
    fallbacks = list("es" = "en")
  )
  config <- i18nConfig(opts)
  i18n <- i18nLoad(opts)

  expect_equal(i_("myslang.hi","es",i18n), "Quiubo")
  expect_equal(i_("myslang.hi","en",i18n), "Zup")

  expect_equal(i_("myslang.surprise","es",i18n), "¡Mierda!")
  expect_equal(i_("myslang.surprise","en",i18n), "WTF!")

  str <- c("shi18ny.download", "shi18ny.upload")
  lang <- "es"
  expect_equal(i_(str, lang), c("descargar", "subir"))
})



