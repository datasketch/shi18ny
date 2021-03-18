

#' @export
i18nLoad <- function(opts = NULL){
  config <- i18nConfig(opts)
  availableSystemLangs <- shi18ny:::available_langs
  available_lang_codes <- availableSystemLangs[[1]]
  localeDir <- config$localeDir
  customTranslationSource <- config$customTranslationSource

  if(!dir.exists(localeDir)){

    # message("No custom translations defined")
    customAvailableLangs <- NULL
    customLocale <- NULL

  } else {

    files <- list.files(localeDir)
    fileExtensions <- unique(sub('.*\\.', '', files))

    if(customTranslationSource == "yaml"){

      customAvailableLangs <- gsub(".yaml","",list.files(localeDir,pattern = ".yaml"))

      if(length(customAvailableLangs) == 0)
        message("No yaml files in locale folder.")

      if(!is.null(config$availableLangs)){
        if(!all(customAvailableLangs %in% config$availableLangs))
          stop("Requested languages not in locale folder")
      }
      customLocale <- lapply(customAvailableLangs,function(lang){
        dir <- file.path(localeDir,paste0(lang,".yaml"))
        l <- yaml::yaml.load_file(dir)
      })
      names(customLocale) <- customAvailableLangs

    } else if (customTranslationSource == "csv"){

      if(!"translations.csv" %in% files)
        stop("Need translations.csv file in locale folder.")

      # message("Using translations from csv.")
      dir <- file.path(localeDir,"translations.csv")
      all_translations <- readr::read_csv(dir, col_types = readr::cols())

      data_columns <- names(all_translations)

      if(!"id" %in% data_columns)
        stop("Need id column for translations.")

      customAvailableLangs <- data_columns[!data_columns == "id"]

      if(!is.null(config$availableLangs)){
        if(!all(customAvailableLangs %in% config$availableLangs))
          stop("Requested languages not in translations.csv file.")
      }

      language_columns <- all_translations %>%
        dplyr::select(dplyr::all_of(customAvailableLangs))

      translation_ids <- all_translations$id

      customLocale <- language_columns %>%
        purrr::map(~as.list(.x) %>%
                     stats::setNames(translation_ids))

    } else {
      stop("CustomTranslationSource needs to be one of 'yaml' or 'csv'.")
    }

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
        l <- c(customLocale[["en"]], l)
      }else
        l <- c(customLocale[[lang]], l)
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
    queryParameter = "lang",
    customTranslationSource = "yaml"
  )
  config <- defaultOpts
  if(!is.null(opts))
    config <- modifyList(defaultOpts, opts, keep.null = TRUE)
  if(!dir.exists(config$localeDir))
    message("locale directory does not exists, using default translations")
  config
}

