library(shiny)
library(ggplot2)
library(dplyr)
library(leaflet)
library(shi18ny)
library(lfltmagic)

data_dir <- system.file("examples", "ex06-translate_covid_viz","tidy-csse-langs.csv", package = "shi18ny")
load_data <- readr::read_csv(data_dir)

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

  opts <- list(
    defaultLang = "en",
    availableLangs = c("de","en","es"),
    customTranslationSource = "csv"
  )

  i18n <- i18nLoad(opts)

  lang <- callModule(langSelector,"lang", i18n = opts, showSelector = TRUE)

  observeEvent(lang(),{
    shinyjs::delay(500, uiLangUpdate(input$shi18ny_ui_classes, lang = lang(), i18n = i18n))
  })

  output$world_map <- renderLeaflet({

    # translate labels
    country <- i_("country", lang = lang(), i18n = i18n)
    cases <- i_("cases", lang = lang(), i18n = i18n)
    title <- i_("title", lang = lang(), i18n = i18n)
    subtitle <- i_("subtitle", lang = lang(), i18n = i18n)

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
    h6(paste0(i_("status", lang = lang(), i18n = i18n), ": ", max_date))
    })

}

shinyApp(ui, server)
