library(shiny)
library(shi18ny)
library(shinyjs)

ui <- fluidPage(
  useShinyjs(),
  sidebarLayout(
    sidebarPanel(
      langSelectorInput("lang")
    ),
    mainPanel(
      verbatimTextOutput("debug"),
      uiOutput("results")
    )
  )
)

server <- function(input, output, session) {
  i18n <- list(
    defaultLang = "en",
    availableLangs = c("es","en")
  )

  currentLocale <- callModule(langSelector,"lang", i18n = i18n, showSelector=TRUE)

  output$debug <- renderPrint({
    c("Selected Lang",currentLocale(),
      i_("sys.language",currentLocale()),
      i_("sys.download",currentLocale()),
      i_("myslang.hi"),currentLocale())
  })

  output$results <- renderUI({
    list(
    h1(i_("myslang.hi",currentLocale())),
    h1(i_("sys.language",currentLocale()))
    )
  })

}

shinyApp(ui, server)

