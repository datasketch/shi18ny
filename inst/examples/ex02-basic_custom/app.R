library(shiny)
library(shi18ny)

ui <- fluidPage(
  useShi18ny(),
  langSelectorInput("lang", position = "fixed"),
  h1(ui_("hello")),
  uiOutput("results")
)

server <- function(input, output, session) {
  i18n <- list(
    defaultLang = "en",
    availableLangs = c("es","en", "de")
  )
  lang <- callModule(langSelector,"lang", i18n = i18n, showSelector = TRUE)
  observeEvent(lang(),{
    uiLangUpdate(input$shi18ny_ui_classes, lang())
  })

  output$results <- renderUI({
    list(
      h1(i_("world",lang())),
      br(),
      h4(i_("language",lang()), lang()),
      br(),
      h4(i_("choose_file"), lang())
    )
  })

}

shinyApp(ui, server)

