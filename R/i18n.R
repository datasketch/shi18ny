

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
  message(availableSystemLangs)
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
  s <- selectInList(i18nLang,strs) %||% ""
  if(markdown)
    s <- markdownToHTML(text=s,fragment.only = TRUE)
  s
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
  if(is.null(ll)) return()
  if(is.list(ll)){
    strs <- strs[-1]
    return(selectInList(ll,strs))
  }else{
    return(ll)
  }
}


