library(tidyverse)


translations <- read_csv("data-raw/ui-translations.csv")
available_langs <- read_csv("data-raw/available-langs.csv")

default_fallbacks = list(
  "es" = "pt",
  "pt" = "es",
  "fr" = "pt",
  "de" = "nl",
  "nl" = "de"
)

usethis::use_data(available_langs, default_fallbacks, translations,
                  internal = TRUE)



# PNG flags from
# https://github.com/gosquared/flags

langs <- availableLangs()
images <- list.files("data-raw/32", full.names = TRUE)

langs_country <- tribble(
  ~lang, ~country,
  "ar","SA",
  "da","DK",
  "de","DE",
  "en","US",
  "es","ES",
  "fr","FR",
  "he","GR",
  "hi","IN",
  "it","IT",
  "pt","PT",
  "pt_BR","BR",
  "ru","RU",
  "sv","SE",
  "zh_CN","CN"
)
# Manually add Catalonia and fallbacks (e.g. Colombia)

all(langs_country$country %in% basename(file_path_sans_ext(images)))

lapply(transpose(langs_country), function(x){
  file.copy(paste0("data-raw/32/",x$country,".png"),
            paste0("inst/flags/png/",x$lang,".png"))
})


### Another attempt resizing SVGs directly.

# library(magick)
# images <- list.files(system.file("flags","svg", package = "shi18ny"), full.names = TRUE)
#
# lapply(images, function(image){
#   img <- image_read(image) %>% image_resize("32")
#   path <- gsub("\\/svg","\\/png32",image)
#   path <- gsub("\\.svg","\\.png",path)
#   image_write(img, path, format = "png")
# })




