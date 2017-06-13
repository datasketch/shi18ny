library(tidyverse)

x <- read_csv("inst/config/ui-translations.csv")

langs <- names(x)[-1]

map(langs, function(lang){
  l <- x[[lang]] %>% as.list() %>% set_names(x$id)
  l <- list(sys = l)
  yaml <- paste0(yaml::as.yaml(l),"\n")
  filename <- paste0("inst/config/locale/",lang,".yaml")
  writeLines(yaml,filename)
})



