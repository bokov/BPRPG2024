# ui.R

library(shiny)

shinyUI(fluidPage(
  
  # App title
  titlePanel("Cruise Ship Character Creation"),
  
  # Sidebar layout
  sidebarLayout(
    
    # Sidebar with the character creation inputs
    sidebarPanel(
      # Checkbox for crew or passenger
      checkboxInput("is_crew", "Are you a member of the crew?", value = FALSE),
      
      # Dropdown for archetypes (populated dynamically)
      uiOutput("archetype_ui"),
      
      # Text input for custom character summary (only shown if "Other" is chosen)
      conditionalPanel(
        condition = "input.archetype == 'Other'",
        textInput("custom_archetype", "Summarize your character:")
      ),
      
      # Dropdown for debuffs/weaknesses
      selectInput("debuff", "Choose a debuff/weakness:", choices = debuffs),
      
      # Pre-filled textbox for name (modifiable)
      textInput("character_name", "Your character's name:", value = generate_random_name()),
      
      # Display generated character ID (read-only)
      textOutput("character_id"),
      
      # Submit button
      actionButton("submit", "Submit Character")
    ),
    
    # Main panel for displaying information
    mainPanel(
      textOutput("submit_status")
    )
  )
))
