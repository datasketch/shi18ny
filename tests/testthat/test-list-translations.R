
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
  expect_equal(l_es$label, "Hola!!!")
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
  expect_equal(xl$label, "Hola!!!")
  expect_equal(xl$numbers, "Quiubo")
  expect_equal(xl$info$more$label, "Cancelar")
  expect_equal(xl$info$more$more2, l$info$more$more2)

  xl2 <- i_(l, lang = "es", i18n = i18n, keys = c("label","numbers","title"))
  expect_equal(xl2$label, "Hola!!!")
  expect_equal(xl2$numbers, "Quiubo")
  expect_equal(xl2$info$more$label, "Cancelar")
  expect_equal(xl2$info$more$more2, l$info$more$more2)

  expect_equal(xl, xl2)

  # Check it works with chr and non-chr lists

  l <- list(
    label = "hello",
    numbers = 1:3,
    info = list(title = "hello world", information = TRUE,
                more = list(
                  label2 = "abort",
                  more2 = ggplot2::qplot()
                ))
  )
  xl <- i_list(l, "es", keys = c("label","label2"))
  expect_equal(xl$label, "hola")
  expect_equal(xl$numbers, 1:3)
  expect_equal(xl$info$more$label2, "Cancelar")
  expect_equal(xl$info$more$more2, l$info$more$more2)

  # Check keys work

  # First level
  l <- list(label = "hello", information = "information")
  xl <- i_list(l, "es", keys = c("information"))
  expect_equal(xl$label, "hello")
  expect_equal(xl$information, "información")
  xl <- i_list(l, "es", keys = c("label"))
  expect_equal(xl$label, "hola")
  expect_equal(xl$information, "information")

  # Unnamed lists
  l <- list(list(label = "hello", information = "information"),
            list(label = "hello", information = "information"))
  xl <- i_list(l, "es", keys = c("label"))
  expect_equal(unique(xl[[1]]$label), "hola")
  expect_equal(unique(xl[[1]]$information), "information")

  # More levels
  l <- list(label = "hello", information = "information",
            more = list(label = "hello", information = "information"))
  xl <- i_list(l, "es", keys = c("information"))
  expect_equal(xl$label, "hello")
  expect_equal(xl$information, "información")
  expect_equal(xl$more$label, "hello")
  expect_equal(xl$more$information, "información")
  xl <- i_list(l, "es", keys = c("label"))
  expect_equal(xl$label, "hola")
  expect_equal(xl$information, "information")
  expect_equal(xl$more$label, "hola")
  expect_equal(xl$more$information, "information")

  # More levels with unnamed lists
  l <- list(label = "hello",
            inputs = list(
              list(id = "hello", label = "hello"),
              list(id = "hello", label = "hello")
            ),
            information = "information" )
  xl <- i_list(l, "es", keys = c("label"))
  expect_equal(xl$label, "hola")
  expect_equal(xl$inputs[[2]]$label, "hola")

  l <- list(label = "hello", information = "information",
            more = list(label = "hello", information = "information",
                        inputs = list(
                          list(id = "hello", label = "hello"),
                          list(id = "hello", label = "hello")
                        )))
  xl <- i_list(l, "es", keys = c("label"))
  expect_equal(xl$label, "hola")
  expect_equal(xl$information, "information")
  expect_equal(xl$more$label, "hola")
  expect_equal(xl$more$information, "information")
  expect_equal(xl$more$inputs[[1]]$id, "hello")
  expect_equal(xl$more$inputs[[1]]$label, "hola")


})

test_that("named lists works",{

  path <- system.file("examples", "ex03-shi18ny", "parmesan", package = "parmesan")
  parmesan <- parmesan::parmesan_load(path)
  i_(parmesan, "es")

})


