library(shiny)
library(shi18ny)


all_images <- get_flags_image(availableLangs())
names(all_images) <- availableLangs()

ui <- fluidPage(
  useShi18ny(),
  column(4,
         actionButton("button", "Randomize"),
         verbatimTextOutput("debug"),
         # selectImageInput("select_image", label = "select_image",
         #                  choices = c(DA = "da",SV = "sv",DE = "de"),
         #                  images = get_flags_image(c("da","sv","de"))),
         selectLangInput("lang_selector", "Lang Selector",
                         langs = c(EN = "en", ES = "es", PT = "pt")),
         br()
  ),
  column(4,
         br(),
         selectInput("mylang", "Lang", availableLangs(), multiple = TRUE),
         selectLangInput("lang_selector_update", "Lang Selector Update",
                         langs = NULL),
         br()
  ),
  column(4,
         actionButton("button2", "Select ES"),
         selectLangInput("lang_selector_3", "Lang Selector",
                         langs = c(EN = "en", ES = "es", PT = "pt")),
         textOutput("lang_selected_3"),
         br()
  )
)

server <- function(input, output, session) {

  output$debug <- reactive({
    capture.output(str(newlangs()))
  })

  lang <- reactive({
    input$mylang[1]
  })

  newlangs <- reactive({
    input$button
    x <- sample(availableLangs(),3)
    names(x) <- toupper(x)
    x
  })

  observeEvent(input$button,{
    message(newlangs())
    updateSelectImageInput(session, 'select_image', label = "SELECT IMAGE",
                          choices = newlangs(),
                          images = all_images[newlangs()]
                          )
    updateSelectLangInput(session, 'lang_selector',
                          langs = newlangs())
  })

  observeEvent(input$button2,{
    updateSelectLangInput(session, 'lang_selector_3',
                          selected = "es")
  })



  observe({
    newlangs <- input$mylang
    message(newlangs)
    updateSelectLangInput(session, 'lang_selector_update',
                          label = "",
                          langs = newlangs)
  })

  output$lang_selected_3 <- renderText({
    paste("SELECTED LANG 3: ",input$lang_selector_3)
  })

}

shinyApp(ui, server)

