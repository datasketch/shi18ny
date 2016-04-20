
library(devtools)
load_all()
document()
#install()


library(shiny)
library(shinyjs)


library(shi18ny)
####
#i18nLoad("en")
i_("common.language",currentLang = "en")
i_("common.language",currentLang = "es")

######
# source("R/modules.R")
# source("R/utils.R")

library(shi18ny)

ui <- fluidPage(
  useShinyjs(),
  sidebarLayout(
    sidebarPanel(
      setLangInput("lang")
    ),
    mainPanel(
      verbatimTextOutput("debug")
    )
  )
)

server <- function(input, output, session) {
  currentLocale <- callModule(setLang, "lang", label = "", userSelect=TRUE)
  output$debug <- renderPrint({
    c(i_("common.language",currentLocale()),currentLocale())
  })
}
shinyApp(ui, server)


