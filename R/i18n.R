#' Translate text
#'
#' Translate strings, vectors or lists in the Server of a Shiny app.
#'
#' There are currently 15 languages available for translation:
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
#'
#' @param str A string, vector or list to be translated.
#' @param lang Code for the language that the original language should be
#'   translated into.
#' @param i18n List of language configurations. Options that can be set
#'   are:
#'
#'   `defaultLang` Default language used in Shiny app
#'
#'   `availableLangs` Language that can be chosen for translation in Shiny app;
#'   there are currently 15 available languages
#'
#'   `localeDir` Directory to `yaml` files which contain custom keyword
#'   translations
#'
#'   `fallbacks` List of fallback languages if translation for a word is not
#'   found in desired language
#'
#'   `queryParameter` String to define query parameter if language to be set
#'   through URL
#'
#' @param markdown TODO
#'
#' @param keys If `str` is a list this is a string (or a vector of strings)
#'   specifying which key(s) of the list to translate.
#'
#'
#'
#' @return Translation of input text in the same format as the input.
#'
#' @examples
#' i_("hello", lang = "de")
#'
#' i_(c("hello", "world"), lang = "de")
#'
#' i_(list(id = "hello", translate = "world"), lang = "es", keys = "translate")


#' @export
i_ <- function(str, lang = NULL, i18n = NULL, markdown = FALSE,
               keys = c("name","label")){
  if(is.null(i18n)) i18n <- i18nLoad()
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




#' @export
ui_ <- function(string, lang = NULL){
  tags$span(class=paste("i18n", gsub("\\.","-",string)), i_(string, lang))
}

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

#' @export
uiLangUpdate <- function(classes, lang){
  if(is.null(classes)) return()
  classes <- gsub("i18n ", "", classes)
  lapply(classes, function(cls){
    str(cls)
    shinyjs::html(html = i_(gsub("-",".",cls), lang), selector = paste0(".", cls))
  })
}


#' @export
availableLangs <- function(localeDir = NULL){
  sort(shi18ny:::available_langs$lang)
}






