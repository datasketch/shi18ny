
library(shiny)
library(dsmodules)
library(readr)

ui <- fluidPage(
  useShi18ny(),
  langSelectorInput("lang", position = "fixed"),
  uiOutput("table_input"),
  verbatimTextOutput('test')
)

server <- function(input, output, session) {

  i18n <- list(
    defaultLang = "en",
    availableLangs = c("es","en")
  )
  lang <- callModule(langSelector,"lang", i18n = i18n, showSelector = TRUE)

  output$table_input <- renderUI({
    choices <- c("pasted", "fileUpload")
    names(choices) <- i_(c("pasted", "file_upload"), lang = lang())
    tableInputUI("table", choices = choices)
  })

  table <- callModule(tableInput, "table")

  output$test <- renderPrint({
    str(table())
  })

}

shinyApp(ui, server)
