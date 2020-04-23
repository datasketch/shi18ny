context("Translations")

test_that("there are flags for all languages",{



  images <- list.files(system.file("flags","gosquared", package = "shi18ny"), full.names = TRUE)
  imagesNames <- basename(file_path_sans_ext(images))
  availableLangs()[!availableLangs() %in% imagesNames]
  expect_true(all(availableLangs() %in% imagesNames))

  choice <- "es"
  images <- list.files(system.file("flags", package = "shi18ny"), full.names = TRUE)
  imagesNames <- basename(file_path_sans_ext(images))
  names(images) <- imagesNames

  # TEST SELECT LANG WIDGET

  selectLangInput("lang", "Language", langs = c("es","pt"), selected = 1)

  library(shiny)
  library(shi18ny)
  ui <- fluidPage(
    selectLangInput("lang", "Language", langs = c(Espanol="es", English="en"), selected = 2),
    verbatimTextOutput('test'),
    selectizeInput("which_langs", "Which langs", choices = availableLangs(), multiple = TRUE),
    selectLangInput("lang2", "Custom selected langs", langs = c("pt", "fr", "it")),
    verbatimTextOutput('test2')
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
                            label = "New Langs",
                            langs = whichLangs(),
                            selected = whichLangs()[1])
    })
  }
  shiny::shinyApp(ui = ui, server = server)

  ## TODO UPDATE DOESN'T SEEM TO WORK

})



