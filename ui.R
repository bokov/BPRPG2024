# ui.R

library(shiny)

shinyUI(fluidPage(
  
  # App title
  titlePanel("Cruise Ship Character Creation"),
  
  # Sidebar layout
  sidebarLayout(
    
    # Sidebar with the character creation inputs
    sidebarPanel(
      #actionButton('debug','debug'),
      
      # Checkbox for crew or passenger
      checkboxInput("is_crew", "Do you want to be a member of the crew?", value = FALSE),
      p('Crew have some advantages at interacting with crew-member NPCs 
        and the ship itself. Crew get two starting skills auto-assigned to them. 
        Passengers only get one starting skill but it can be anything they 
        choose.'),
      hr(),
      p("What kind of character do you want? If you can't decide, choose 
        'Surprise me' and the GM will pick something for you. On the other hand
        if you have a very specific idea in mind pick 'Other' so you can 
        fill in a custom archetype or motivation (sorry, no custom skills 
        because of game-balance and simplicity)."),
      selectInput("archetype", "Passenger:", 
                  choices = passenger_archetypes, 
                  selected = random_select(passenger_archetypes)),
      # Text input for custom character summary (only shown if "Other" is chosen)
      conditionalPanel(
        condition = "input.archetype == 'Other'",
        textInput("custom_archetype", "Custom character:",placeholder = "If left blank it's the same as choosing 'Surprise me'")
      ),
      selectInput('skill1','Please wait for the page to finish loading',choices= c()),
      selectInput('skill2','Please wait for the page to finish loading',choices=c()),
      selectInput('charactermotive',"Please wait for the page to finish loading",c()),
      conditionalPanel(
        condition = "input.charactermotive == 'Other'",
        textInput("custom_movtivation", "Custom motivation:",placeholder = "If left blank it's the same as choosing 'Surprise me'")
      ),
      
      # Dropdown for debuffs/weaknesses
      selectInput("debuff", "Choose a debuff/weakness:", choices = debuffs,random_select(debuffs)),
      
      # Pre-filled textbox for name (modifiable)
      textInput("character_name", "Your character's name:", value = generate_random_name()),
      
      textAreaInput('character_bio',"Anything else you want to say about your character?",
                    placeholder = 'This is optional and only affects role-play, not game mechanics'),
      
      # Display generated character ID (read-only)
      textOutput("character_id"),
      
      # Submit button
      hr(),
      p('When you are happy with your settings, click this button. Each time 
        you do so you will generate a new character.'),
      actionButton("submit", "Update my CruisePass Card")
    ),
    
    # Main panel for displaying information
    # Main panel with tabs
    mainPanel(
      tabsetPanel(
        tabPanel("Contact & Itinerary", "Placeholder Contact & Itinerary"),
        tabPanel("About Us", "Placeholder About Us"),
        tabPanel("Jobs", "Placeholder Jobs"),
        tabPanel("FAQ", "Placeholder FAQ"),
        tabPanel("Your CruisePass",
                 p('Please save or print out your CruisePass card. Or at least 
                   remember your cabin number. Your CruisPass card reflects the 
                   information you entered before the latest time you pressed
                   "Update my CruisePass Card"'),
                 uiOutput("cruise_pass"))
      )
    )
  )
))
