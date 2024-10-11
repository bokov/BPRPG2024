library(shiny)

shinyServer(function(input, output, session) {
  
  # init ----
  last_submitted_char <- reactiveVal(NULL);
  char_id <- reactive(generate_unique_id());
  
  # update menus for skill1 and motivation ----
  observeEvent(input$archetype,{
    # this part sets the options that vary between archetypes and crew/passenger
    char_options <- if(input$is_crew){
      select_for_arch(input$archetype
                      ,default_motivation = 'Have fun and try to neither die nor get fired'
                      ,common_skills = input$archetype
                      ,archdb = list()) %>% 
        c(skill_label='Automatic crew skill:')
    } else {
      select_for_arch(input$archetype
                      ,default_motivation = 'Have fun and try to not die') %>%
        c(skill_label='Passenger skill:')
    };
    # this part is generic, regardless of archetype or crew/passenger 
    updateSelectInput(inputId = 'skill1',label=char_options$skill_label
                        ,choices = c(char_options$skills,'Surprise me')
                      , selected=char_options$selected_skill);
    updateSelectInput(inputId = 'charactermotive'
                      ,label="Your character's goal:"
                      ,choices=c(char_options$motivations,'Surprise me','Other')
                      ,selected = char_options$selected_motivation)
  });
  
  # update menus for archetype and skill2 ----
  observeEvent(input$is_crew,{
    updateTextInput(inputId = 'character_name',value=generate_random_name());
    char_id <- reactive(generate_unique_id());
    updateSelectInput(inputId="debuff", selected=random_select(debuffs));
    
    if (isolate(input$is_crew)) {
      arch_label <- 'Crew Member:';
      arch_choices <- crew_archetypes;
      skill2_label <- 'Automatic crew skill:';
      skill2_choices <- 'Knowledge of the ship and access to crew-only areas';
    } else {
      arch_label <- 'Passenger:';
      arch_choices <- passenger_archetypes;
      skill2_label <- "Don't worry about your other skill, passenger:";
      skill2_choices <- "Sit back, relax, and let our highly skilled crew take care of everything.";
    }
    updateSelectInput(inputId = 'archetype',label=arch_label
                      ,choices = arch_choices
                      ,selected= random_select(arch_choices));
    # skill2 handled here because it's not affected by choice of archetype
    updateSelectInput(inputId = 'skill2',label=skill2_label
                      ,choices = skill2_choices);
  });
  
  
  # Generate a character ID when the app is loaded
  output$character_id <- renderText({
    paste("Character ID:", char_id())
  })
  
  # Handle the submission of character data ----
  observeEvent(input$submit, {
    last_submitted_char(reactiveValuesToList(input) %>% data.frame %>% 
      transmute(timestamp=Sys.time(),charid=char_id(),character_name,is_crew
                ,archetype=if(archetype=='Other') custom_archetype else archetype
                ,char_class=if(is_crew) toupper(archetype) else "PASSENGER"
                ,motivation=if(charactermotive=='Other') custom_motivation else charactermotive
                ,skill1,skill2,debuff,character_bio
                ,deck=if(is_crew) 1 else sample(c(3:5,8:13),1)
                ,cabin_number = sample(1:200,1)
                ,port_or_starbd = if(cabin_number %% 2) 'Port' else 'Starboard'
                ,front_or_back = if(cabin_number > 100) 'Aft' else 'Fore'
                ,cabin=sprintf("%d-%d (%s, %s)",deck,cabin_number,port_or_starbd,front_or_back)
                ,muster_station = LETTERS[deck]
                ));
    sheet_append(gsid,last_submitted_char(),sheet=gssheet);
    # Notify the user that their character was submitted
    output$submit_status <- renderText("Character submitted successfully!")
  })
  
  # cruisepass ----
  output$cruise_pass <- renderUI({
    char_cruisepass <- last_submitted_char();
    if(is.null(char_cruisepass)){div("Please click 'Update my CruisePass Card'")
    } else with(char_cruisepass,
                div(
                  style = "border: 2px solid #000; border-radius: 10px; width: 300px; height: 180px; padding: 15px; position: relative; background-color: #f8f8f8;",
                  # Logo in the upper right
                  tags$img(src = 'cruiselogo.png', style = 'position: absolute; top: 10px; right: 10px; width: 60px; height: 60px;'),
                  # Character Name at the top
                  h3(character_name, style = "margin-top: 0;"),
                  # Crew or Passenger designation
                  h4(char_class),
                  # Cabin Number
                  h5(paste0("Cabin: ",cabin), style = "margin-bottom: 5px;"),
                  # Muster Station based on the cabin's deck
                  h5(paste0("Muster Station: ", muster_station), style = "margin-bottom: 5px;")
                )
    )
  })
  
  
  # debug ----
  #observeEvent(input$debug, browser());
    
})
