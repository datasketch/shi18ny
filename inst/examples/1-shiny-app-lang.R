library(shi18ny)


locales


ui <- fluidPage(
  useShinyjs(),
  sidebarLayout(
    sidebarPanel(
      langSelectorInput("lang")
    ),
    mainPanel(
      verbatimTextOutput("debug")
    )
  )
)

server <- function(input, output, session) {
  i18n <- list(
    defaultLang = "en",
    availableLangs = c("es","en")
  )

  currentLocale <- callModule(langSelector, "lang", showSelector=TRUE)

  output$debug <- renderPrint({
    c(i_("common.language",currentLocale()),currentLocale())
  })
}
shinyApp(ui, server)

