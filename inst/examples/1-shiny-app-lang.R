library(shiny)
library(shi18ny)

ui <- fluidPage(
  useShi18ny(),
  column(4,
         langSelectorInput("lang", position = "fixed"),
         br(),
         verbatimTextOutput("debug")
  ),
  column(8,
         h2("Hello, this is always in english"),
         h3("Try reloading the app with the url parameter ?lang=es"),
         h3(ui_("this_is_current_lang")),
         h4("Check update UI examples to change this text from the UI"),
         uiOutput("results")
  )
)

server <- function(input, output, session) {
  i18n <- list(
    defaultLang = "en",
    availableLangs = c("es","en")
  )
  lang <- callModule(langSelector,"lang", i18n = i18n, showSelector = TRUE)
  output$debug <- renderPrint({
    cat(c("Selected Lang: ",lang(),"\nReactive translations: \n",
      i_("language",lang()),
      i_("download",lang()),
      i_("myslang.hi"), lang())
    )
  })

  output$results <- renderUI({
    list(
      h2(i_("this_is_reactive",lang())),
      h1(i_("myslang.hi",lang())),
      h2(i_("language",lang()),":",
         span(lang()))
    )
  })

}

shinyApp(ui, server)

