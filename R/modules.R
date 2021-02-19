#' Language selector input
#'
#' This function needs to be included in the UI to create the
#' language switcher in the Shiny app.
#'
#' @param id The id that will be used to access the value.
#' @param position String indicating position of language switcher; options
#'   are "right" and "fixed"; default = "right".
#' @param width Width of language switcher container; default = 80.


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
    shinyjs::hidden(
      tags$div(id=ns("langContainer"), class = cls,
               style= style,
               selectLangInput(ns("langInner"), label="",
                               langs = NULL,
                               flags = NULL,
                               placeholder = NULL,
                               selected = NULL, width = width)
      )
    )
  )
}

#' Language selector
#'
#' This Shiny module gets language that's currently selected in the language
#' selector. It needs to be used in the Server to save the currently active
#' (selected) language in a reactive. This reactive can then be passed to the
#' \code{\link{i_}} function to translate the text.
#'
#' @param i18n List of language configurations; can only be set for `i_`.
#'   Options that can be set are:
#'
#'   `defaultLang` Default language used in Shiny app; default = "en"
#'
#'   `availableLangs` Language that can be chosen for translation in Shiny app;
#'   there are currently 15 **Available languages** (see below);
#'   defaults to all.
#'
#'   `localeDir` Directory to `yaml` files which contain custom keyword
#'   translations; default = "locale"
#'
#'   `fallbacks` List of fallback languages if translation for a word is not
#'   found in desired language; defaults to **Default fallbacks** (see below)
#'
#'   `queryParameter` String to define query parameter if language to be set
#'   through URL; default = "lang"
#'
#' @param showSelector Boolean to specify if language selector should be
#'   displayed or not. Even if selector is not displayed, language can always
#'   be set by query parameter; default = "lang"
#'
#' @return String of language code of currently selected languages.
#'
#' @section Available languages: There are currently 15 languages available for
#'   translation:
#'
#'  | code  | language            |
#'  | ----- | ------------------- |
#'  | ar    | Arabic              |
#'  | ca    | Catalan             |
#'  | da    | Danish              |
#'  | de    | German              |
#'  | en    | English             |
#'  | es    | Spanish             |
#'  | fr    | French              |
#'  | he    | Hebrew              |
#'  | hi    | Hindi               |
#'  | it    | Italian             |
#'  | pt    | Portuguese          |
#'  | pt_BR | Portuguese (Brazil) |
#'  | ru    | Russian             |
#'  | sv    | Swedish             |
#'  | zh_CN | Chinese             |
#'
#' @section Default fallbacks: If no fallback languages are specified,
#'   translations automatically fall back onto the following languages.
#'
#'  | original language  | fallback language |
#'  | ------------------ | ----------------- |
#'  | es                 | pt                |
#'  | pt                 | es                |
#'  | fr                 | pt                |
#'  | de                 | nl                |
#'  | nl                 | de                |
#'
#' @examples
#' \dontrun{
#' i18n <- list(
#'   defaultLang = "en",
#'   availableLangs = c("en", "de")
#' )
#' lang <- callModule(langSelector,"lang", i18n = i18n, showSelector = TRUE)
#' }

#' @export
langSelector <- function(input, output, session,
                         i18n = NULL, showSelector = TRUE){
  i18n <- i18nLoad(i18n)
  config <- i18n$.config

  queryLang <- reactive({
    query <- parseQueryString(session$clientData$url_search)
    query[[config$queryParameter]]
  })

  initLocale <- reactive({
    selected <- queryLang() %||% config$defaultLang

    message("selected2 ", selected," config ", config$defaultLang)
    message(showSelector)

    if(showSelector){
      shinyjs::show("langContainer")
    }
    message("config_av_langs",config$availableLangs)

    # updateSelectLangInput(session, 'langInner',
    #                       langs = config$availableLangs,
    #                       selected = selected)

    message("selected3", selected, " config ", config$defaultLang)
    selected
  })

  currentLocale <- reactive({
    initLocale()
    message("initLocale: ", initLocale())
    message("input3 ", queryLang(), " is null ",is.null(queryLang()))

    queryLang() %||% config$defaultLang
  })
  currentLocale
}


