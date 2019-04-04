

#' @export
i18nConfig <- function(opts = NULL){
  defaultOpts <- list(
    defaultLang = "en",
    availableLangs = availableLangs(),
    localeDir = "locale",
    fallbacks = list(
      "es" = "pt",
      "pt" = "es",
      "fr" = "pt",
      "de" = "nl",
      "nl" = "de"),
    queryParameter = "lang"
  )
  config <- defaultOpts
  if(!is.null(opts))
    config <- modifyList(defaultOpts, opts, keep.null = TRUE)
  config
}


#' @export
i18nLoad <- function(opts = NULL){
  config <- i18nConfig(opts)
  systemLocaleDir <- system.file("config/locale",package="shi18ny")
  availableSystemLangs <- availableLangs()
  localeDir <- config$localeDir
  if(!dir.exists(localeDir)){
    message("Using system locale only")
    customAvailableLangs <- NULL
    customLocale <- NULL
  }else{
    customAvailableLangs <- gsub(".yaml","",list.files(localeDir,pattern = ".yaml"))
    if(!is.null(config$availableLangs)){
      if(!all(customAvailableLangs %in% config$availableLangs))
        stop("Requesting languages not in locale folder")
    }
    customLocale <- lapply(customAvailableLangs,function(lang){
      dir <- file.path(localeDir,paste0(lang,".yaml"))
      l <- yaml.load_file(dir)
    })
    names(customLocale) <- customAvailableLangs
  }
  locales <- lapply(availableSystemLangs,function(lang){
    if(!all(customAvailableLangs %in% config$availableLangs))
      warning("Requesting languages not in system locale folder")
    #gsub(".yaml", "",list.files(localeDir))
    #message(lang)
    dir <- file.path(systemLocaleDir,paste0(lang,".yaml"))
    l <- yaml.load_file(dir)
    if(!is.null(customLocale)){
      if(is.null(customLocale[[lang]])){
        l <- c(l, customLocale[["en"]])
      }else
        l <- c(l, customLocale[[lang]])
    }
    l
  })
  names(locales) <- availableSystemLangs
  i18n <- locales[config$availableLangs]
  i18n$.config <- config
  i18n
}

#' @export
i_ <- function(localeString, lang = NULL, i18n = NULL, markdown = FALSE){
  if(is.null(i18n)) i18n <- i18nLoad()
  lang <- lang %||% "en"
  strs <- strsplit(localeString,".",fixed = TRUE)[[1]]
  i18nLang <- i18n[[lang]]
  s <- selectInList(i18nLang,strs) %||% paste0(localeString,collapse = ".")
  if(markdown)
    s <- markdownToHTML(text=s,fragment.only = TRUE)
  s
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
    useShinyjs(),
    extendShinyjs(text = jscode)
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
  localeDir <- localeDir %||% system.file("config/locale",package="shi18ny")
  gsub(".yaml", "",list.files(localeDir))
}



selectInList <- function(l,strs){
  str <- strs[1]
  ll <- NULL
  try({ll <- l[[str]]},silent=TRUE)
  #message(str(ll))
  if(is.null(ll)) return(strs)
  if(is.list(ll)){
    strs <- strs[-1]
    return(selectInList(ll,strs))
  }else{
    return(ll)
  }
}


