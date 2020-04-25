

#' @export
i18nLoad <- function(opts = NULL){
  config <- i18nConfig(opts)
  availableSystemLangs <- shi18ny:::available_langs
  available_lang_codes <- availableSystemLangs[[1]]
  localeDir <- config$localeDir
  if(!dir.exists(localeDir)){
    # message("No custom translations defined")
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
      l <- yaml::yaml.load_file(dir)
    })
    names(customLocale) <- customAvailableLangs
  }

  # shi18ny <- read.csv(system.file("ui-translations.csv", package = "shi18ny"),
  #                     stringsAsFactors = FALSE)
  shi18ny <- shi18ny:::translations
  shi18ny_ids <- shi18ny$id
  shi18ny <- shi18ny[available_lang_codes]
  shin18ny <- lapply(shi18ny, function(x){
    names(x) <- shi18ny_ids
    list(shi18ny = as.list(x))
    as.list(x)
  })

  locales <- lapply(available_lang_codes, function(lang){
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
  names(locales) <- available_lang_codes
  i18n <- locales[config$availableLangs]
  i18n$.config <- config
  i18n
}


#' @export
i18nConfig <- function(opts = NULL){
  defaultOpts <- list(
    defaultLang = "en",
    availableLangs = shi18ny:::available_langs$lang,
    localeDir = "locale",
    fallbacks = shi18ny:::default_fallbacks,
    queryParameter = "lang"
  )
  config <- defaultOpts
  if(!is.null(opts))
    config <- modifyList(defaultOpts, opts, keep.null = TRUE)
  config
}

