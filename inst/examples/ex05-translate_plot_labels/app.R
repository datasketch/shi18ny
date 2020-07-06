library(shiny)
library(ggplot2)
library(shi18ny)

ui <- fluidPage(

  useShi18ny(),
  langSelectorInput("lang", position = "fixed"),
  fluidRow(

    column(8,
           plotOutput(outputId = "bar_chart")
    )),
  hr(),
  h6(ui_("annotate"))
)

server <- function(input, output) {

  # create example data
  example_data <- data.frame(dose=c("D0.5", "D1", "D2"),
                             len=c(4.2, 10, 29.5))

  output$bar_chart <- renderPlot({
    ggplot(data=example_data, aes(x=dose, y=len)) +
      geom_bar(stat="identity", fill="steelblue")+
      theme_minimal()+
      ggtitle(i_("title", lang())) +
      xlab(i_("dose", lang())) +
      ylab(i_("len", lang()))
  })

  i18n <- list(
    defaultLang = "en",
    availableLangs = c("de","en")
  )

  lang <- callModule(langSelector,"lang", i18n = i18n, showSelector = TRUE)

  observeEvent(lang(),{
    uiLangUpdate(input$shi18ny_ui_classes, lang())
  })

}

shinyApp(ui, server)
