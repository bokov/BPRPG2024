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
    #updateSelectInput(inputId="debuff", selected=random_select(debuffs));

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

  observeEvent(input$debuff,{
    output$debuff_info <- renderUI(p(class='selectedinfo',debuffs[input$debuff]));
  })

  observeEvent(input$skill1,{
    output$skill1_info <- renderUI(p(class='selectedinfo',if(!input$is_crew) passenger_skills_with_descriptions[input$skill1] else ''));
  })


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
                ,skill1,skill2,debuff,character_bio=paste(character_bio,if(file.exists('debug')) '[test]' else '')
                ,deck=if(is_crew) 3 else sample(c(4,5,8,9,12,14:17),1)
                ,cabin_number = sample(cabins[[paste0('D',deck)]],1)
                ,port_or_starbd = if(cabin_number %% 2) 'Port' else 'Starboard'
                ,front_or_back = if(cabin_number > 350) 'Aft' else 'Fore'
                ,cabin=sprintf("%d (%s, %s)",cabin_number,port_or_starbd,front_or_back)
                ,muster_station = paste0(LETTERS[deck],if(cabin_number %%2) 1 else 2,floor((cabin_number - deck*1000)/100))
                ));
    sheet_append(gsid,last_submitted_char(),sheet=gssheet);
    # Notify the user that their character was submitted
    output$submit_status <- renderText("Character submitted successfully!")
  })

  # cruisepass ----
  output$cruise_pass <- renderUI({
    char_cruisepass <- last_submitted_char();
    if(is.null(char_cruisepass)){
      div(
        style = "border: 2px solid #000; border-radius: 10px; width: 300px; height: 180px; padding: 15px; position: relative; background-color: #f8f8f8;",
        "Please fill out your character info on the left sidebar (or above if you're using a phone) and then click
          'Create my CruisePass Card'")
    } else with(char_cruisepass,
                p(div(
                  style = "border: 2px solid #000; border-radius: 10px; width: 300px; height: 180px; padding: 15px; position: relative; background-color: #f8f8f8;",
                  # Logo in the upper right
                  tags$img(src = 'cruiselogo_cropped.svg', style = 'position: absolute; top: 10px; right: 10px; width: 60px; height: 60px;'),
                  # Character Name at the top
                  h3(character_name, style = "margin-top: 0;"),
                  # Crew or Passenger designation
                  h4(char_class),
                  # Cabin Number
                  h5(paste0("Cabin: ",cabin), style = "margin-bottom: 5px;"),
                  # Muster Station based on the cabin's deck
                  h5(paste0("Muster Station: ", muster_station), style = "margin-bottom: 5px;")
                ),"Please save or print out this CruisePass card. Or at least
                   write down your character's name and cabin number. Your
                   CruisPass card reflects the information you entered the most
                   recent time you pressed 'Create my CruisePass Card'")
    )
  })

  observeEvent(input$rnboy,updateTextInput(inputId='character_name',value=generate_random_name('m')));
  observeEvent(input$rngirl,updateTextInput(inputId='character_name',value=generate_random_name('f')));
  observeEvent(input$rn,updateTextInput(inputId='character_name',value=generate_random_name()));


  output$deckplan <- renderUI({
    # Ensure the deck number has two digits (e.g., 03, 04)
    img_path <- sprintf("deck%d.png", input$deck_slider)

    # Calculate the scaling percentage
    scale_percent <- input$image_scale / 100;

    # Use img() tag to display the image
    div(img(src = img_path,style = paste0(
        #"width:", 600 * scale_percent, "px; ",
        "height:", 800 * scale_percent, "px; ",
        "object-fit: contain;"
      )
    ),class='deckplan')
  })

  # debug ----
  observeEvent(input$debug, browser());

})
