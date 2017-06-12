library(tidyverse)

x <- read_csv("inst/config/ui-translations.csv")

langs <- names(x)[-1]

map(langs, function(lang){
  l <- x[[lang]] %>% as.list() %>% set_names(x$id)
  l <- list(sys = l)
  writeLines(yaml::as.yaml(l),paste0("inst/config/locale/",lang,".yaml"))
})



