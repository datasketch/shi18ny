library(shiny)
library(ggplot2)
library(dplyr)
library(leaflet)
library(shi18ny)
library(lfltmagic)

load_data <- read.csv("tidy-csse-langs.csv")

max_date <- max(load_data$date)

data <- load_data %>%
  group_by(country) %>%
  filter(date == max_date) %>%
  select(iso_alpha3, confirmed, country, en, de, es)

ui <- fluidPage(

  useShi18ny(),
  langSelectorInput("lang", position = "fixed"),
  h3(ui_("internationalize")),
  hr(),
  fluidRow(
    column(12,
           leafletOutput(outputId = "world_map")
    )),
  hr(),
  h5(ui_("annotate")),
  hr(),
  uiOutput("datestamp")
)

server <- function(input, output) {

  i18n <- list(
    defaultLang = "en",
    availableLangs = c("de","en","es")
  )

  lang <- callModule(langSelector,"lang", i18n = i18n, showSelector = TRUE)

  observeEvent(lang(),{
    uiLangUpdate(input$shi18ny_ui_classes, lang())
  })

  output$world_map <- renderLeaflet({

    # translate labels
    country <- i_("country", lang())
    cases <- i_("cases", lang())
    title <- i_("title", lang())
    subtitle <- i_("subtitle", lang())

    lflt_choropleth_Gcd(data,
                        map_tiles = "CartoDB",
                        tooltip = paste0("<b>",country,":</b> {",lang(),"} </br> <b>",cases,":</b> {confirmed}"),
                        palette_colors = c("#92a8d1", "#034f84"),
                        branding_include = FALSE,
                        title = title,
                        title_color = "#f7786b",
                        subtitle = subtitle,
                        subtitle_color = "#f7786b"
                        )
    })

  output$datestamp <- renderUI({
    h6(paste0(i_("status",lang()), ": ", max_date))
    })

}

shinyApp(ui, server)
