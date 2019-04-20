#' @export
langSelectorInput <- function(id,
                              position = "right",
                              width = 80) {
  ns <- NS(id)
  cls <- ""
  style <- ""
  if(position == "right")
    cls <- "pull-right"
  if(position == "fixed"){
    cls <- "lang-fixed"
    style <- "position: fixed;top:0px;right: 10px;z-index: 1001;"
  }
  div(
    tags$style(src="https://cdnjs.cloudflare.com/ajax/libs/flag-icon-css/0.8.2/css/flag-icon.min.css"),
    hidden(
      tags$div(id=ns("langContainer"), class = cls,
               style= style,
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
  # observe({
  initLocale <- reactive({
    selected <- queryLang() %||% config$defaultLang
    #message("selected2 ", selected,"config", config$defaultLang)
    #message(showSelector)
    if(showSelector){
    #   message(showSelector)
    #   return(queryLang())
    # }else{
      shinyjs::show("langContainer")
    }
      updateSelectizeInput(session, 'langInner',
                           label = "",
                           choices = config$availableLangs, selected = selected,
                           server = TRUE)
    # return(reactive(selected))
    #selected <- queryLang()
    # if(is.null(selected)) return(config$defaultLang)
    # if(!showSelector) return(selected)
    #message("selected3", selected, " config ", config$defaultLang)
    selected
  })

  currentLocale <- reactive({
    #message("initLocale", initLocale())
    #message("input3", input$langInner, " is null ",is.null(input$langInner))
    # if(is.null(input$langInner))
    #   return(initLocale())
    input$langInner
  })
  currentLocale
}




