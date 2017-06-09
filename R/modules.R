#' @export
langSelectorInput <- function(id,
                              style = "basic",
                              width = 80) {
  ns <- NS(id)
  div(
    tags$style(src="https://cdnjs.cloudflare.com/ajax/libs/flag-icon-css/0.8.2/css/flag-icon.min.css"),
    hidden(
      div(id=ns("langContainer"),
        selectInput(ns("langInner"),label="",choices = NULL, selected = NULL,width = width)
      )
    )
  )
}

#' @export
langSelector <- function(input,output,session, i18n = NULL,showSelector = TRUE){
  i18n <- i18nLoad(i18n)
  config <- i18n$.config
  queryLang <- reactive({
    query <- parseQueryString(session$clientData$url_search)
    query[[config$queryParameter]]
  })
  observe({
    selected <- queryLang()
    message(showSelector)
    if(!showSelector){
      message(showSelector)
      return(queryLang())
    }else{
      shinyjs::show("langContainer")
      updateSelectizeInput(session, 'langInner',
                           label = "",
                           choices = c("en","es"), selected = selected,
                           server = TRUE)
    }
  })
  currentLocale <- reactive({
    selected <- queryLang()
    if(!showSelector) return(selected)
    input$langInner
  })
  currentLocale
}




