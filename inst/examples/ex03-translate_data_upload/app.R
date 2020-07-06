library(shiny)
library(shi18ny)

ui <- fluidPage(

  useShi18ny(),
  langSelectorInput("lang", position = "fixed"),

  sidebarLayout(
    sidebarPanel(

      # Wrap text to be translated in UI in ui_ function
      fileInput("file1",
                ui_("choose"),
                buttonLabel = ui_("browse"),
                placeholder = "",
                accept = c(
                  "text/csv",
                  "text/comma-separated-values,text/plain",
                  ".csv")
      ),
      tags$hr(),
      checkboxInput("header", ui_("header"), TRUE)
    ),
    mainPanel(
      tableOutput("contents")
    )
  )
)

server <- function(input, output) {

  i18n <- list(
    defaultLang = "en",
    availableLangs = c("de","en", "es")
  )

  lang <- callModule(langSelector,"lang", i18n = i18n, showSelector = TRUE)

  observeEvent(lang(),{
    uiLangUpdate(input$shi18ny_ui_classes, lang())
  })

  output$contents <- renderTable({
    inFile <- input$file1

    if (is.null(inFile))
      return(NULL)

    read.csv(inFile$datapath, header = input$header)
  })
}

shinyApp(ui, server)
