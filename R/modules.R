#' @export
setLangInput <- function(id) {
  ns <- NS(id)
  div(
    hidden(
      div(id=ns("langContainer"),
        selectizeInput(ns("langInner"),label="",choices = NULL, selected = NULL)
      )
    )
  )
}

#' @export
setLang <- function(input,output,session, label = "label", userSelect = TRUE){
  queryLang <- reactive({
    query <- parseQueryString(session$clientData$url_search)
    query$lang
  })
  observe({
    selected <- queryLang()
    message(userSelect)
    if(!userSelect){
      message(userSelect)
      return(queryLang())
    }else{
      shinyjs::show("langContainer")
      updateSelectizeInput(session, 'langInner',
                           label = label,
                           choices = c("en","es"), selected = selected,
                           server = TRUE)
    }
  })
  currentLocale <- reactive({
    selected <- queryLang()
    if(!userSelect) return(selected)
    input$langInner
  })
  currentLocale
}




