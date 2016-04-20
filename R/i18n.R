

#' @export
i18nInit <- function(currentLang = NULL,
                     defaultLang = "en",
                     localeDir = NULL){
  currentLang <- currentLang %||% defaultLang
  localeDir <- localeDir %||% "locale"
  list(currentLang = currentLang,
       defaultLang = defaultLang,
       localeDir = localeDir)
}


#' @export
i_ <- function(localeString, currentLang = NULL, markdown = FALSE){
  currentLang <- currentLang %||% "en"
  #localeString <- "common.download"
  i18n <- i18nLoad(currentLang)
  strs <- strsplit(localeString,".",fixed = TRUE)[[1]]
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
  s <- selectInList(i18n,strs) %||% ""
  if(markdown)
    s <- markdownToHTML(text=s,fragment.only = TRUE)
  s
}


#' @export
availableLangs <- function(localeDir = NULL){
  localeDir <- localeDir %||% system.file("config/locale",package="shi18ny")
  gsub(".yaml", "",list.files(localeDir))
}

#' @export
i18nLoad <- function(currentLang = NULL, customLocaleDir = ""){
  currentLang <- currentLang %||% "en"
  localeDir <- system.file("config/locale",package="shi18ny")
  availableLangs <- availableLangs()

  if(!currentLang %in% availableLangs)
    currentLang <- "en"

  customLangs <- NULL
  if(dir.exists(customLocaleDir)){
    customAvailableLangs <- gsub(".yaml", "",list.files(customLocaleDir))
    customLangs <- lapply(customAvailableLangs,function(lang){
      #gsub(".yaml", "",list.files(localeDir))
      dir <- file.path(customLocaleDir,paste0(lang,".yaml"))
      l <- yaml.load_file(dir)
    })
    names(customLangs) <- customAvailableLangs
  }
  langs <- lapply(availableLangs,function(lang){
    #gsub(".yaml", "",list.files(localeDir))
    #message(lang)
    dir <- file.path(localeDir,paste0(lang,".yaml"))
    l <- yaml.load_file(dir)
    if(!is.null(customLangs)){
      if(is.null(customLangs[[lang]])){
        l$custom <- customLangs[["en"]]
      }else
        l$custom <- customLangs[[lang]]
    }
    l
  })
  names(langs) <- availableLangs
  langs
  i18n <- langs[[currentLang]]
  i18n
}




