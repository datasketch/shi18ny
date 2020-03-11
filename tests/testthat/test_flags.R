context("Translations")

test_that("i18n Config",{

  images <- list.files(system.file("flags", package = "shi18ny"), full.names = TRUE)
  imagesNames <- basename(file_path_sans_ext(images))
  availableLangs()[!availableLangs() %in% imagesNames]
  expect_true(all(availableLangs() %in% imagesNames))

  choice <- "es"
  images <- list.files(system.file("flags", package = "shi18ny"), full.names = TRUE)
  imagesNames <- basename(file_path_sans_ext(images))
  names(images) <- imagesNames

  # TEST SELECT LANG WIDGET

  selectLangInput("lang", "Language", choices = NULL, selected = 2)

  ui <- fluidPage(
    selectLangInput("lang", "Language", choices = c(Espanol="es", English="en"), selected = 2),
    verbatimTextOutput('test'),
    selectizeInput("which_langs", "Which langs", choices = availableLangs(), multiple = TRUE),
    selectLangInput("lang2", "Custom selected langs", choices = c("pt", "fr", "it")),
    verbatimTextOutput('test2'),
  )
  server <- function(input, output, session){


    output$test <- renderPrint({
      input$lang
    })
    output$test2 <- renderPrint({
      input$lang2
    })

    whichLangs <- reactive(input$which_langs)
    observe({
      updateSelectLangInput(session, 'lang2',
                            label = "",
                            choices = whichLangs(),
                            selected = whichLangs()[1])
    })
  }
  shiny::shinyApp(ui = ui, server = server)

})



