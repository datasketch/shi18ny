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

  expect_equal(i_("undefined.surprise","es",i18n), "undefined.surprise")

  str <- c("download", "upload")
  lang <- "es"
  expect_equal(i_(str, lang), c("descargar", "subir"))
})


test_that("list translations work",{

  localeDir <- system.file("examples/locale",package = "shi18ny")
  opts <- list(
    localeDir = localeDir,
    defaultLang = "es",
    fallbacks = list("es" = "en")
  )
  config <- i18nConfig(opts)
  i18n <- i18nLoad(opts)

  l <- list(label = "hello", numbers = "abort",
            custom_text = "myslang.hi",
            undefined = "undefined.hi",
            x = "abort")
  l_es <- i_list(l, lang = "es", i18n = i18n,
                 keys = c("label","numbers", "custom_text", "undefined"))
  expect_equal(names(l), names(l_es))
  expect_equal(l_es$label, "hola")
  expect_equal(l_es$numbers, "Cancelar")
  expect_equal(l_es$custom_text, "Quiubo")
  expect_equal(l_es$undefined, "undefined.hi")

  # Check it works with nested lists
  l <- list(
    label = "hello",
    numbers = "myslang.hi",
    info = list(title = "hello world", information = "information",
         more = list(
           label = "abort",
           more2 = "more2"
         ))
  )

  xl <- i_list(l, lang = "es", i18n = i18n, keys = c("label","numbers","title"))
  expect_equal(xl$label, "hola")
  expect_equal(xl$numbers, "Quiubo")
  expect_equal(xl$info$more$label, "Cancelar")
  expect_equal(xl$info$more$more2, l$info$more$more2)

  xl2 <- i_(l, lang = "es", i18n = i18n, keys = c("label","numbers","title"))
  expect_equal(xl2$label, "hola")
  expect_equal(xl2$numbers, "Quiubo")
  expect_equal(xl2$info$more$label, "Cancelar")
  expect_equal(xl2$info$more$more2, l$info$more$more2)

  expect_equal(xl, xl2)



})


