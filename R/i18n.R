


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
  if(length(class(l)) > 1) return(l)
  if(!has_sublist(l)){
    l_keys <- removeNulls(l[keys])
    return(modifyList(l, lapply(l_keys, i_, lang = lang, i18n = i18n), keep.null = TRUE))
  }else{
    l2 <- lapply(l, function(ll){
      if(!is.list(ll)){
        return(i_(ll, lang = lang, i18n = i18n))
      }else{
        i_list(ll, lang, i18n = i18n, keys = keys)
      }
    })
  }
  l2
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






