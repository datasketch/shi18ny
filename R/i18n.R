


#' @export
i_ <- function(str, lang = NULL, i18n = NULL, markdown = FALSE){
  if(is.null(i18n)) i18n <- i18nLoad()
  lang <- lang %||% "en"
  strs <- strsplit(str,".",fixed = TRUE)
  i18nLang <- i18n[[lang]]
  ss <- lapply(strs, function(s){
    t <- selectInList(i18nLang, s) %||% paste0(s,collapse = ".")
    if(markdown){
      t <- markdownToHTML(text=t,fragment.only = TRUE)
    }
    t
  })
  #if(length(ss) == 1) ss <- unlist(ss)
  unlist(ss)
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
  x <- read.csv(system.file("ui-translations.csv", package = "shi18ny"), stringsAsFactors = FALSE)
  names(x)[-1]
}






