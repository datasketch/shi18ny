library(shiny)
library(shi18ny)
library(parmesan)
library(shinypanels)

ui <- panelsPage(
  useShi18ny(),
  shinypanels::modal(id = 'test', title = 'Test modal title', p('Modal ipsum')),
  langSelectorInput("lang", position = "fixed"),
  panel(title = "Example07 with parmesan",
        width = 350,
        body = list(uiOutput("all_controls_here"),
                    verbatimTextOutput("debug"))
  ),
  panel(title = "panel 2",
        body = plotOutput("distPlot")
  )
)

server <-  function(input, output, session) {

  i18n <- list(
    defaultLang = "en",
    availableLangs = c("es","en")
  )

  lang <- callModule(langSelector,"lang", i18n = i18n, showSelector=TRUE)

  path <- system.file("examples", "ex07-translate_with_parmesan", "parmesan",
                      package = "shi18ny")
  parmesan <- parmesan_load(path)

  # Put all parmesan inputs in reactive values
  parmesan_input <- parmesan_watch(input, parmesan)

  parmesan_lang <- reactive({
    i_(parmesan, lang(), keys = c("label", "choices"))
    # parmesan
  })

  output_parmesan("all_controls_here", parmesan = parmesan_lang,
                  input = input, output = output, session = session,
                  env = environment())

  observe({
    shinypanels::showModalMultipleId(modal_id = "test", list_id = c(c("output_plot_type")))
  })

  output$debug <- renderPrint({
    paste0(
      "Parmesan updated: ", input$parmesan_updated
      # str(parmesan_input())
    )
  })

  datasetInput <- reactive({
    req(input$dataset)
    get(input$dataset)
  })

  datasetNCols <- reactive({
    req(datasetInput())
    ncol(datasetInput())
  })

  datasetNColsLabel <- reactive({
    paste0("Colums (max = ", datasetNCols(),")")
  })


  output$distPlot <- renderPlot({
    req(input$dataset, input$column, datasetInput())
    dataset  <- input$dataset
    column <- input$column
    x <- datasetInput()[, column]
    column_name <- names(datasetInput())[column]

    if(input$plot_type %in% c("Plot", "Gráfico")){
      plot <- plot(x)
    }
    if(input$plot_type %in% c("Histogram", "Histograma")){
      req(input$bins)
      bins <- seq(min(x), max(x), length.out = input$bins + 1)
      plot <- hist(x, breaks = bins, col = "#75AADB", border = "white",
                   xlab = paste0("Values of ", column_name),
                   main =  paste0("This is ", dataset, ", column ", column))
    }
    plot
  })

  parmesan_alert(parmesan, env = environment())

}


shinyApp(ui, server)
