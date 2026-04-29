setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

library(shiny)
library(lubridate)
library(DT)

# Save function
log_line <- function(newdata, filename = 'traffic_data.csv') {
  dt <- Sys.time() %>% round() %>% as.character()
  newline <- paste(c(dt, newdata), collapse = ",")
  cat(paste0(newline, "\n"), file = filename, append = TRUE)
  print('Data stored!')
}

# UI
ui <- fluidPage(
  titlePanel(h2("Sewanee Traffic Logger")),
  
  p(
    "Use this tool to quickly log passing vehicles on University Avenue."
  ),
  
  br(),
  
  fluidRow(
    column(
      4,
      selectInput(
        "vehicle",
        "Vehicle Type",
        choices = c("Sedan", "SUV", "Truck", "Motorcycle", "Bus", "Other"),
        width = "95%"
      )
    ),
    
    column(
      4,
      selectInput(
        "color",
        "Vehicle Color",
        choices = c("White", "Black", "Gray", "Blue", "Red", "Other"),
        width = "95%"
      )
    ),
    
    column(
      4,
      radioButtons(
        "speed",
        "Estimated Speed",
        choices = c("Slow", "Moderate", "Fast"),
        inline = TRUE
      )
    )
  ),
  
  fluidRow(column(
    12,
    radioButtons(
      "direction",
      "Direction",
      choices = c("Northbound on University", "Southbound on University"),
      inline = FALSE
    )
  )),
  
  br(),
  
  fluidRow(column(2), column(
    8, actionButton("save", h2("Log Observation"), width = "100%")
  ), column(2)),
  
  br(),
  
  p(
    "Instructions: Stand in one location on University Ave. and log each passing vehicle.",
    "Click 'Log Observation' after each entry. Data is automatically saved."
  )
)

# Server
server <- function(input, output) {
  observeEvent(input$save, {
    newdata <- c(input$vehicle, input$color, input$speed, input$direction)
    
    log_line(newdata)
    
    showNotification("Observation Logged", type = "message")
  })
}

# run app
shinyApp(ui, server)