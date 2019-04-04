library(shiny)
library(shi18ny)
library(shinyjs)


ui <- navbarPage("Navbar!",
                 tabPanel(ui_("myslang.plot"),
                          sidebarLayout(
                            sidebarPanel(
                              useShi18ny(),
                              langSelectorInput("lang", position = "right"),
                              radioButtons("plotType", ui_("myslang.hi"),
                                           c("Scatter"="p", "Line"="l")
                              ),
                              verbatimTextOutput("debug")
                            ),
                            mainPanel(
                              plotOutput("plot")
                            )
                          )
                 ),
                 tabPanel("Summary",
                          verbatimTextOutput("summary")
                 ),
                 navbarMenu("More",
                            tabPanel("Table",
                                     DT::dataTableOutput("table")
                            ),
                            tabPanel("About",
                                     p("Hello, this is it")
                            )
                 )
)




server <- function(input, output, session) {
  i18n <- list(
    defaultLang = "en",
    availableLangs = c("es","en")
  )
  lang <- callModule(langSelector,"lang", i18n = i18n, showSelector=TRUE)

  observeEvent(lang(),{
    uiLangUpdate(input$shi18ny_ui_classes, lang())
  })

  output$debug <- renderPrint({
    i18nClasses <- input$shi18ny_ui_classes

     c("Selected Lang",lang(),
       i_("sys.language",lang()),
       i_("sys.download",lang()),
       i_("myslang.hi"))
       i_(gsub("i18n ","",i18nClasses))
  })

  output$results <- renderUI({
    list(
      h1(i_("myslang.hi",lang())),
      h1(i_("sys.language",lang()))
    )
  })

  output$plot <- renderPlot({
    plot(cars, type=input$plotType)
  })

  output$summary <- renderPrint({
    summary(cars)
  })

  output$table <- DT::renderDataTable({
    DT::datatable(cars)
  })

}

shinyApp(ui, server)

