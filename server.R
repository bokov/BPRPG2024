# server.R

library(shiny)
library(googlesheets4)

# Authenticate with Google Sheets (assuming you've already set up authentication)
# You'll need to follow the instructions for using googlesheets4 authentication.
# sheets_auth(email = "your-email@example.com")

shinyServer(function(input, output, session) {
  
  # Dynamically update the archetype dropdown based on the crew checkbox
  output$archetype_ui <- renderUI({
    if (input$is_crew) {
      selectInput("archetype", "Choose your crew archetype:", choices = crew_archetypes)
    } else {
      selectInput("archetype", "Choose your passenger archetype:", choices = passenger_archetypes)
    }
  })
  
  # Generate a character ID when the app is loaded
  output$character_id <- renderText({
    paste("Character ID:", generate_unique_id())
  })
  
  # Handle the submission of character data
  observeEvent(input$submit, {
    # Collect input data
    character_data <- list(
      character_name = input$character_name,
      archetype = ifelse(input$archetype == "Other", input$custom_archetype, input$archetype),
      debuff = input$debuff,
      character_id = output$character_id
    )
    
    # Append the data to Google Sheets
    # Assuming you have the appropriate permissions set for the sheet
    sheet_id <- "your-google-sheet-id"
    sheet_append(sheet_id, data.frame(character_data))
    
    # Notify the user that their character was submitted
    output$submit_status <- renderText("Character submitted successfully!")
  })
})
