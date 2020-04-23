library(shiny)
library(shi18ny)
library(shinyjs)

ui <- fluidPage(
  useShinyjs(),
  sidebarLayout(
    sidebarPanel(
      langSelectorInput("lang", position = "fixed")
    ),
    mainPanel(
      verbatimTextOutput("debug"),
      uiOutput("options"),
      uiOutput("results")
    )
  )
)

server <- function(input, output, session) {
  i18n <- list(
    defaultLang = "en",
    availableLangs = c("es","de","en")
  )
  lang <- callModule(langSelector,"lang", i18n = i18n, showSelector=TRUE)
  output$debug <- renderPrint({
    c("Selected Lang",lang())
  })

  output$options <- renderUI({
    choices <- c("first", "second")
    names(choices) <- toupper(c(i_("shi18ny.share", lang()), i_("shi18ny.shape",lang())))
    selectizeInput("sel_options", i_("select", lang()), choices)
  })

  output$results <- renderUI({
    list(
      h1(i_("myslang.hi",lang())),
      h1(i_("shi18ny.language",lang()))
    )
  })

}

shinyApp(ui, server)

