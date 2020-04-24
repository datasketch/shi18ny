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

  str <- c("download", "upload")
  lang <- "es"
  expect_equal(i_(str, lang), c("descargar", "subir"))
})


test_that("list translations work",{

  l <- list(label = "hello", numbers = "abort", x = "abort")
  l_es <- i_list(l, lang = "es", keys = c("label","numbers"))
  expect_equal(names(l), names(l_es))
  expect_equal(l_es$label, "hola")
  expect_equal(l_es$numbers, "Cancelar")

  # Check it works with nested lists
  l <- list(
    label = "hello",
    numbers = "insert",
    info = list(title = "hello world", information = "information",
         more = list(
           label = "abort",
           more2 = "more2"
         ))
  )

  xl <- i_list(l, lang = "es", keys = c("label","numbers","title"))
  expect_equal(xl$label, "hola")
  expect_equal(xl$numbers, "insertar")
  expect_equal(xl$info$more$label, "Cancelar")
  expect_equal(xl$info$more$more2, l$info$more$more2)

  xl2 <- i_(l, lang = "es", keys = c("label","numbers","title"))
  expect_equal(xl2$label, "hola")
  expect_equal(xl2$numbers, "insertar")
  expect_equal(xl2$info$more$label, "Cancelar")
  expect_equal(xl2$info$more$more2, l$info$more$more2)

  expect_equal(xl, xl2)

})


