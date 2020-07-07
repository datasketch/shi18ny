#' Translate text
#'
#' Translate strings, vectors or lists in the Server of a Shiny app. There are
#' currently 15 languages available for translation (see **Available languages**
#' below). Note that the `i_` function should be used within the Server of the
#' app and the `ui_` function should be used in the UI.
#'
#' @name i18n
#'
#' @param str A string, vector or list to be translated.
#' @param lang Code for the language that the original language should be
#'   translated into.
#' @param i18n List of language configurations, can only be set for `i_`.
#'   Options that can be set are:
#'
#'   `defaultLang` Default language used in Shiny app; default = "en"
#'
#'   `availableLangs` Language that can be chosen for translation in Shiny app;
#'   there are currently 15 **Available languages** (see below); defaults to
#'   all.
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
#' @param markdown Transform markdown text to HTML, can only be set for `i_`;
#'   default = FALSE
#'
#' @param keys If `str` is a list this is a string (or a vector of strings)
#'   specifying which key(s) of the list to translate; can only be set for `i_`.
#'
#'
#' @return Translation of input text in the same format as the input.
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
#' i_("hello", lang = "de")
#'
#' i_(c("hello", "world"), lang = "es")
#'
#' i_(list(id = "hello", translate = "world"), lang = "pt", keys = "translate")
#'
#' \dontrun{
#' ui <- fluidPage(
#' useShi18ny(),
#' langSelectorInput("lang", position = "fixed"),
#' h1(ui_("hello")),
#' )
#' }

#' @rdname i18n
#' @export
i_ <- function(str, lang = NULL, i18n = NULL, markdown = FALSE,
               keys = c("name","label")){

  i18n_is_null <- is.null(i18n)
  i18n_not_yet_processed <- !(is.null(i18n) | (".config" %in% names(i18n)))

  if(i18n_is_null | i18n_not_yet_processed) i18n <- i18nLoad(i18n)

  lang <- lang %||% "en"
  if(is.null(str)) return()

  if(is.list(str)){
    return(i_list(str, lang, i18n = i18n, keys = keys))
  }
  if(!is.character(str)) return(str)
  strs <- strsplit(str,".",fixed = TRUE)
  i18nLang <- i18n[[lang]]
  ss <- lapply(strs, function(s){
    t <- selectInList(i18nLang, s)
    if(length(t) > 1) t <- paste0(t,collapse = ".")
    if(markdown){
      t <- markdownToHTML(text=t,fragment.only = TRUE)
    }
    t
  })
  #if(length(ss) == 1) ss <- unlist(ss)
  unlist(ss)
}


i_list <- function(l, lang, i18n = NULL, keys = NULL){
  if(length(l) == 0) return(list())
  if(length(class(l)) > 1) return(l) # return things that are not only lists
  idx_subs <- unlist(lapply(l, is.list))
  l_no_subs <- l[!idx_subs]
  l_no_subs_i <- modifyList(l_no_subs,
                            lapply(removeNulls(l_no_subs[keys]), i_, lang = lang,
                                   i18n = i18n), keep.null = TRUE)
  l_subs <- l[idx_subs]
  l_subs_i <- lapply(l_subs, function(ll){
    if(length(ll) == 0) return(ll)
    # message("i: ", i)
    # i <<- i + 1
    # str(ll)
    if(!is.list(ll)){
      return(i_(ll, lang = lang, i18n = i18n))
    }else{
      i_list(ll, lang, i18n = i18n, keys = keys)
    }
  })
  l0 <- c(l_no_subs_i, l_subs_i)
  if(!is.null(names(l))) l0 <- l0[names(l)]
  l0
}


#' @rdname i18n
#' @export
ui_ <- function(string, lang = NULL){
  tags$span(class=paste("i18n", gsub("\\.","-",string)), i_(string, lang))
}

#' Initialize shi18ny
#'
#' This function needs to be included in the UI of the Shiny app. It runs the
#' required client side javascript code to update strings when the currently
#' active (selected) language changes.

#' @export
useShi18ny <- function(){
  jscode <- '
  shinyjs.init = function() {
    $(document).on("shiny:sessioninitialized" , function(event) {
      var i18ns = [];
      $(".i18n").each(function(){
        i18ns.push( $(this).attr("class"))
      });
      //i18ns = i18ns.each(function(){
      //  return x.replace(/-/g, ".").replace("i18n ","")
      //})
      console.log(i18ns)
      Shiny.setInputValue("shi18ny_ui_classes", i18ns, {priority: "event"});
    });
  }'
  list(
    shinyjs::useShinyjs(),
    shinyjs::extendShinyjs(text = jscode)
  )
}

#' Update language in UI translations
#'
#' This function needs to be included in the Server of the Shiny app if if text
#' is translated in the UI of the app using the \code{\link{ui_}} function. It
#' makes sure the language used by \code{\link{ui_}} to do the translation is
#' updated when the active (selected) language changes.
#'
#' @param classes UI classes; pass `input$shi18ny_ui_classes` to refer to all
#'   instances of \code{\link{ui_}}.
#' @param lang Code for the language that the original language should be
#'   translated into.
#'
#'   In the following example, `lang()` is the reactive value created by the
#'   \code{\link{langSelector}} function.
#'
#' @examples
#' \dontrun{
#' observeEvent(lang(),{
#'   uiLangUpdate(classes = input$shi18ny_ui_classes,
#'                lang = lang())
#'   })
#' }

#' @export
uiLangUpdate <- function(classes, lang){
  if(is.null(classes)) return()
  classes <- gsub("i18n ", "", classes)
  lapply(classes, function(cls){
    str(cls)
    shinyjs::html(html = i_(gsub("-",".",cls), lang), selector = paste0(".", cls))
  })
}


#' Display available languages
#'
#' Call this function to display the language code for languages currently
#' supported by `shi18ny`.

#' @export
availableLangs <- function(localeDir = NULL){
  sort(shi18ny:::available_langs$lang)
}






