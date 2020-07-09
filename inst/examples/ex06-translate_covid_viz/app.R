library(shiny)
library(ggplot2)
library(dplyr)
library(leaflet)
library(shi18ny)
library(lfltmagic)

data <- read.csv("tidy-csse-langs.csv") %>%
  filter(date == "2020-04-12") %>%
  select(iso_alpha3, confirmed, country, en, de, es)

ui <- fluidPage(

  useShi18ny(),
  langSelectorInput("lang", position = "fixed"),
  h3(ui_("internationalize")),
  hr(),
  fluidRow(

    column(6,
           leafletOutput(outputId = "world_map")
    )),
  hr(),
  h5(ui_("annotate")),
  hr(),
  h6(ui_("status")),
)

server <- function(input, output) {

  output$world_map <- renderLeaflet({
    country = i_("country", lang())
    cases = i_("cases", lang())

    lflt_choropleth_Gcd(data,
                        map_tiles = "CartoDB",
                        tooltip = paste0("<b>",country,":</b> {",lang(),"} </br> <b>",cases,":</b> {confirmed}"),
                        palette_colors = c("#99f2c8", "#1f4037"),
                        branding_include = TRUE,
                        title = i_("title", lang()),
                        subtitle = i_("subtitle", lang())
                        )
  })

  i18n <- list(
    defaultLang = "en",
    availableLangs = c("de","en","es")
  )

  lang <- callModule(langSelector,"lang", i18n = i18n, showSelector = TRUE)

  observeEvent(lang(),{
    uiLangUpdate(input$shi18ny_ui_classes, lang())
  })

}

shinyApp(ui, server)
