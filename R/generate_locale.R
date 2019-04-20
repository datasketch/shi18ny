
#' @export
generate_locale <- function(src_path = ".", files = NULL, i18n = NULL, langs = NULL){
  if(is.null(langs))
   stop("Need to provide at least two languages")
  if(length(langs) < 2)
   stop("Need to provide at least two languages")
  if(is.null(i18n)) i18n <- i18nLoad()
  dir <- i18n$.config$localeDir
  if(!dir.exists(dir))
    dir.create(dir)

  all_files <- list.files(path = src_path, pattern = "\\.R$", recursive = TRUE, full.names = TRUE)
  if(!is.null(files)){
    all_files <- c(all_files, files)
  }
  keywords <- i18nGetKeywords(all_files)
  lapply(langs, function(lang){
    keys <- undotList(keywords)
    locale_file <- file.path(dir, paste0(lang,".yaml"))
    if(file.exists(locale_file)){
      currentLocale <- yaml.load_file(locale_file)
      keys <- modifyList(keys, currentLocale)
    }
    yaml::write_yaml(keys, locale_file)
  })
  message("Created locale files in ", dir)
}

i18nGetKeywords <- function(files){
  unique(unlist(lapply(files, function(file){
    exp <- getParseData(parse(file))
    idx <- which(exp$text %in% c("i_","ui_"))
    keys <- gsub('"','', exp$text[idx + 3])
    unique(keys[!grepl("shi18ny\\.", keys) & nchar(keys) >0])
  })))
}


