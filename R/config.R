

#' @export
i18nLoad <- function(opts = NULL){
  config <- i18nConfig(opts)
  availableSystemLangs <- availableLangs()
  localeDir <- config$localeDir
  if(!dir.exists(localeDir)){
    message("No custom translations defined")
    customAvailableLangs <- NULL
    customLocale <- NULL
  }else{
    customAvailableLangs <- gsub(".yaml","",list.files(localeDir,pattern = ".yaml"))
    if(!is.null(config$availableLangs)){
      if(!all(customAvailableLangs %in% config$availableLangs))
        stop("Requested languages not in locale folder")
    }
    customLocale <- lapply(customAvailableLangs,function(lang){
      dir <- file.path(localeDir,paste0(lang,".yaml"))
      l <- yaml.load_file(dir)
    })
    names(customLocale) <- customAvailableLangs
  }

  shi18ny <- read.csv(system.file("ui-translations.csv", package = "shi18ny"),
                      stringsAsFactors = FALSE)
  shi18ny_ids <- shi18ny$id
  shi18ny <- shi18ny[availableSystemLangs]
  shin18ny <- lapply(shi18ny, function(x){
    names(x) <- shi18ny_ids
    list(shi18ny = as.list(x))
  })

  locales <- lapply(availableSystemLangs,function(lang){
    if(!all(customAvailableLangs %in% config$availableLangs))
      warning("Requesting languages not in system locale folder")
    l <- shin18ny[[lang]]
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

