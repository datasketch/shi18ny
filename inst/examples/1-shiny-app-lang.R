library(shiny)
library(shi18ny)
library(shinyjs)

ui <- fluidPage(
  useShi18ny(),
  column(3,
         langSelectorInput("lang", position = "fixed"),
         verbatimTextOutput("debug")
  ),
  column(9,
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
  lang <- callModule(langSelector,"lang", i18n = i18n, showSelector=TRUE)
  output$debug <- renderPrint({
    cat(c("Selected Lang: ",lang(),"\nReactive info: \n",
      i_("shi18ny.language",lang()),
      i_("shi18ny.download",lang()),
      i_("myslang.hi"))
    )
  })

  output$results <- renderUI({
    list(
      br(),
      hr(),
      h2(i_("this_is_reactive",lang())),
      h1(i_("myslang.hi",lang())),
      h2(i_("shi18ny.language",lang()),":",
         span(lang()))
    )
  })

}

shinyApp(ui, server)

