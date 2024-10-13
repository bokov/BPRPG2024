# ui.R

library(shiny)

shinyUI(fluidPage(
  
  # App title
  titlePanel("The Silver Tide"),
  
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
        tabPanel("Contact & Itinerary", 
                 h2("A cruise to end all cruises!"),
                 p("Andrew Bokov is turning 13 this year and he would like to 
                 invite you to join him on a Halloween cruise! He would",
                 tags$i('like'),"to and so would we, but that many cruise tickets 
                 would get expensive. So... we're having a cruise-themed (and 
                 Halloween-themed) roleplaying game!"),
                 p("This is why you're being asked to choose a character on
                 the side-panel of this website. Feel free to make several
                 characters, because even though the Silver Tide has the best
                 safety record in the industry and there is no reason
                 whatsoever to expect that your character will die in some
                 spooky and dramatic manner... it is Halloween and... you 
                 know... it's good to have a backup character or two, just in 
                 case. But don't worry, all the rumours you've heard about the 
                 Bermuda Triangle are completely false and everything will be 
                 fine... just fine."),
                 p("The cruise departs from:"),
                 h3("Knight Watch Games"), 
                 h3("16350 Blanco Rd #116, San Antonio, TX 78232"), 
                 h3("The Deathstar Room"), 
                 h3("Saturday, November 2nd, 2024"), 
                 p("Boarding begins promptly at noon, lasting until 3pm with 
                   late pick-up available up to 6pm. Parents are welcome to 
                   stay and play boardgames next to the party room."),
                 p("Don’t miss this special journey... of a lifetime. 
                 Your adventure awaits with thrills, chills, delicious snacks, 
                 and wonderful friends."),
                 hr(),"Questions? Please contact...",
                 h4("Rebecca Lively & Alex Bokov"),
                 h5("Silver Tide Passenger Service Officers"),
                 h5("Innsmouth Luxury Cruises"),
                 p("210 639-0712"),
                 a("Email us with 'Birthday Party 2024' in the subject-line!", href="mailto:ai.supersloths@gmail.com?subject=Birthday%20Party%202024"),
                 ""
                 ),
        tabPanel("About The Silver Tide",
                 "We are going to be using a modified version of the 
                 Roll-for-Shoes roleplaying game. You can see the original",
                 a("here",href='https://rollforshoes.com/'),
                 ". Here is how our version will go:",
                 with(tags,ol(
                   li("The game will be led by a GM (game master) who will be 
                      describing to you what's going on. To help you visualize
                      things we'll probably have miniatures, maps, and props."),
                   li("You will have a PC (player character) which will interact
                      with other PCs and with NPCs (non-player characters 
                      controlled by the GM. Your PC will start with a 
                      general-purpose level-1 skill called 'Do anything' and one or two
                      specialized higher-level skills."),
                   li()
                 )),
                 ""),
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

