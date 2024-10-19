# ui.R

library(shiny)

shinyUI(fluidPage(
  tags$head(
    tags$title("The Silver Tide - Innsmouth Luxury Cruises"),
    tags$link(rel = "stylesheet", type = "text/css", href = "styles.css"),
    tags$link(rel = "apple-touch-icon", sizes="180x180", href="/apple-touch-icon.png"),
    tags$link(rel="icon",type="image/png",sizes="32x32",href="/favicon-32x32.png"),
    tags$link(rel="icon",type="image/png",sizes="16x16",href="/favicon-16x16.png"),
    tags$link(rel="manifest",href="/site.webmanifest"),
    tags$link(rel = "stylesheet", href = "https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;700&display=swap")
  ),
  # App title
  titlePanel(div(
  "The Silver Tide"))
  ,

  # Sidebar layout
  sidebarLayout(

    # Sidebar with the character creation inputs
    sidebarPanel(
      if(file.exists('debug')) actionButton('debug','debug'),

      # Checkbox for crew or passenger ----
      checkboxInput("is_crew", "Do you want to be a member of the crew?", value = FALSE),
      p('Crew have some advantages at interacting with crew-member NPCs
        and the ship itself. Crew get two starting skills auto-assigned to them.
        Passengers only get one starting skill but it can be anything they
        choose.'),
      hr(),
      # archetypes ----
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
      # skills & motives ----
      selectInput('skill1','Please wait for the page to finish loading',choices= c()),
      uiOutput('skill1_info'),
      selectInput('skill2','Please wait for the page to finish loading',choices=c()),
      uiOutput('skill2_info'),
      selectInput('charactermotive',"Please wait for the page to finish loading",c()),
      conditionalPanel(
        condition = "input.charactermotive == 'Other'",
        textInput("custom_movtivation", "Custom motivation:",placeholder = "If left blank it's the same as choosing 'Surprise me'")
      ),

      # Dropdown for debuffs/weaknesses ----
      selectInput("debuff", "Choose a debuff/weakness:", choices = names(debuffs),random_select(names(debuffs))),
      uiOutput('debuff_info'),

      # Pre-filled textbox for name (modifiable) ----
      textInput("character_name", "Your character's name:", value = generate_random_name()),
      p("Generate random name:",
        actionButton('rnboy','boy',class='minibutton'),
        actionButton('rngirl','girl',class='minibutton'),
        actionButton('rn','either',class='minibutton')
        ),

      textAreaInput('character_bio',"Anything else you want to say about your character?",
                    placeholder = 'This is optional and only affects role-play, not game mechanics'),

      # Display generated character ID (read-only)
      textOutput("character_id"),

      # Submit button ----
      hr(),
      p('When you are happy with your settings, click this button. Each time
        you do so you will generate a new character.'),
      actionButton("submit", "Create my CruisePass Card")
    ),

    # Main panel with tabs
    mainPanel(
      tabsetPanel(
        # contact & itinerary ----
        tabPanel("Contact & Itinerary",
                 uiOutput("cruise_pass"),
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
        # game rules ----
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
                      controlled by the GM). Your PC will start with a
                      general-purpose level-1 skill called 'Do anything' and one or two
                      specialized higher-level skills."),
                   li("Often your PC will have to do something challenging-- for
                      example, 'put out a fire' or 'fight the bad-guy' or 'fix
                      the control panel'. The GM will set a target number or
                      will roll some dice. You will try to beat that number by
                      rolling your own dice and adding them together. The number
                      of dice you roll is determined by the level of the skill
                      you are using. For example, if you have
                      'repair electrical devices: 3' and you are trying to fix a
                      control panel, you get to roll three dice and add them
                      together. On the other hand, if you don't have a relevant
                      skill (let's say you have 'firearms: 3') then you'll have
                      to fall back on 'do anything: 1' and roll just one die."),
                   li("But, good news-- you will gain new skills as you play.
                      Every time you roll all sixes, you get a new, more
                      specific skill one level higher than the skill you
                      originally used. Let's say your PC with the firearms skill
                      used their 'do anything: 1' skill to fix a control panel
                      and rolled a six. Then you would get awarded a new skill,
                      perhaps 'repair: 2'. So next time you had to repair
                      something you would be able to roll and add together two
                      dice... and if both of them came out 6-es, you would gain
                      yet another even more specific skill at level-3, perhaps
                      'repair electrical devices: 3'. So from then on, if the
                      thing you were repairing was an electrical device, you
                      would get to roll three dice... though before you could
                      get a level-4 skill in that track you would have to roll
                      three 6-es."),
                   li("More good news-- you even learn from failure. If you
                      roll your dice and fail to beat the target number or the
                      GM's dice-roll, you get an experience point as a
                      consolation prize. You can spend an experience point to
                      convert one die roll into a 6",tags$i("after"),"the
                      outcome happens. In other words, let's say you roll a 6
                      and a 2 when trying to repair a control panel using your
                      'repair: 2' skill but that's not enough to repair it.
                      You get an experience point. You can save it for later
                      or you can spend it immediately to convert the 2 to a
                      second 6. Because this is after the outcome, that 6
                      doesn't change the fact that you failed. But now, for
                      the purpose of skill advancement only, it counts as
                      though you rolled two 6-es so you get that 'repair
                      electronic devices: 3' skill."),
                   li("Weaknesses subtract from your dice-rolls whenever they
                      are triggered. For example, if your weakness is 'fear of
                      the dark: 3' and you're trying to render first-aid in a
                      dark room, then 3 will be subtracted from whatever you
                      roll for your first-aid attempt whereas if you're doing
                      the same thing in a well-lit location, nothing gets
                      subtracted. Some weaknesses might behave differently and
                      if you have one of those, the GM will explain to you
                      what's different."),
                   li(p("You know how in most computer games and RPGs healing
                      works remarkably quickly and thoroughly? Like, you use
                      up a med-kit or a healing potion and suddenly that
                      severed limb or pneumothorax is all better within
                      seconds and you can jump right back into battle? Or you
                      can run around fighting with only one hitpoint left?
                      Yeah, nah, we're going to be more realistic here. There
                      are three levels of hurt-- mild, moderate, and severe.
                      Mild injuries can be cured completely by a successful
                      use of a medical-type skill. If you're mildly injured
                      and get injured again, (of if you're uninjured but take
                      enough damage) you are moderately injured. Think, broken
                      bone, concussion, laceration, torn ligaments. You cannot
                      be completely cured during this game-- the best a doctor
                      or paramedic can do for you is get you back to mildly
                      injured, though no further. Likewise, you can go from
                      moderate to severe injuries (or jump straight to severe
                      injuries when taking massive damage). From severe
                      injuries you can only be healed back down to moderate
                      injuries, but no further. The next injury level past
                      severe is dead. You do have a backup character or two,
                      don't you?"),
                      p("Like in real life, injuries are very inconvenient.
                      For each level of injury you are given one injury die
                      Unless otherwise told by the GM, you throw your injury
                      dice at the same time as you roll your normal dice. You
                      add the injury dice together and subtract them from your
                      skill dice.")),
                   li("The same happens with mental trauma. Certain disturbing
                      experiences take a toll on your characters's sanity, and
                      you get trauma dice each time it happens. If you fail your
                      dice roll because of mental trauma, your character does
                      something you didn't intend-- maybe they run away
                      screaming, maybe they freeze up, maybe they procrastinate
                      on doing something urgent. If you rack up more than three
                      mental dice, you don't die, but your character 'snaps' and
                      becomes an NPC and you will need to switch to a backup
                      character.")
                 )),
                 ""),
        # info for crew ----
        #tabPanel("Jobs", "Placeholder Jobs"),
        # FAQ ----
        tabPanel("FAQ",with(tags,
                            dl(
                              dt("Is the party actually going to be on a real boat?"),
                              dd("'Yes', depending on what you mean by 'real' and
                                 by 'boat'.", i("You"), "will party in a
                                 comfortable and creatively appointed
                                land-ship made of drywall and concrete
                                 with a sturdy asphalt hull. Name: Knight Watch
                                 Games. Flag: United States. Port of registry:
                                 San Antonio, Texas. Displacement: ~100,000
                                 tonnes not counting the cars parked on its 'deck'.
                                 Top speed: 0.00000000154 knots.",i("Your
                                 character"),", on the other hand, will be sailing
                                 the Atlantic Ocean aboard The Silver Tide, and
                                 that will indeed be real boat-- to your character."),
                              dt("Okay, so what are the deets on The Silver Tide?
                                 Displacement and all that junk?"),
                              dd("Name: The Silver Tide. Flag: Bahamas.
                                 Port of Registry: Nassau, Bahamas.
                                 Displacement: 180,000 tonnes,
                                 Top speed: 17 knots"),
                              dt("What does skill <X> do?"),
                              dd("All the skills give you two dice to roll for
                                 doing some specific type of task, as opposed to
                                 the one die you roll for doing anything at all.
                                 If time permits we will update this website
                                 with descriptions of every skill, so",
                                 b("check back here before the birthday party for
                                   descriptions and other updates")),
                              dt("Why can't crew members choose their skills?"),
                              dd("To keep them from being OP. Crew members
                                 get two skills instead of one. The first, 'Knowledge of the
                                 ship and access to crew-only areas' gives them
                                 two dice to roll for things like knowing where
                                 various things are located on the ship,
                                 unlocking doors, and getting NPCs to do what
                                 they want them to. The other skill is their
                                 specialty as a crew member. So if you pick
                                 'Lifeguard', your skill is also 'Lifeguard'.
                                 This means you get to roll two dice when trying
                                 to do something you'd expect a lifeguard to be
                                 able to do-- not only swimming but also
                                 first-aid, and even charisma (from looking cute in
                                 that bright-red lifeguard swimsuit). So by
                                 choosing to be a crew-member you're trading off
                                 customizability for special pre-determined
                                 abilities."),
                              dt("Let's say I pick a martial artist as a character
                                 but choose some skill other than martial arts.
                                 Can my character still do martial arts?"),
                              dd("For roleplay purposes, you can say that your
                                 character is doing martial arts when they fight.
                                 But they will still only roll one die, same as
                                 any other passenger who didn't choose the martial
                                 arts skill. But don't worry-- the more martial
                                 arts stuff you attempt to do, the more you'll
                                 fail and the more sixes you'll roll-- both of
                                 which will grow your martial arts skill-tree.
                                 So by acting like a martial artist your character
                                 will eventually become one."),
                              dt("How will I get my character when I go to the party?"),
                              dd("The GM will call out characters by name and
                                 cabin-number. If it matches one of the
                                 CruisPasses you printed or saved, you raise
                                 your hand and get that character's packet"),
                              dt("So, when I press 'Create my CruisePass' that
                                 registers a new character?"),
                              dd("Yes"),
                              dt("How do I make multiple characters?"),
                              dd("Press 'Create my CruisePass' multiple times
                                 (and each time print or save the CruisePass
                                 so you can claim that character)"),
                              dt("What if I make a character by mistake?"),
                              dd("Just tell the GM when he calls that character."),
                              dt("What if I only make one character or I make a
                                 few but I still run out of characters because
                                 things get more Halloweeny than I expected?"),
                              dd("No problem. We'll help you roll up a new one
                                 on-site."),
                              dt("So I can make 20 characters and be immortal?"),
                              dd("There's no hard limit on characters but you
                                  only play one at a time until/unless something
                                  happens to them. Just make 2-3. If you run
                                 out of characters, you can get a new one
                                 rolled up on the spot. That makes it easier for
                                 everyone."),
                              dt("What if I think I found a bug or typo?"),
                              dd("Please post it here:",a("https://bokov.shinyapps.io/BPRPG2024/",href="https://github.com/bokov/BPRPG2024/issues"))

                            )))
      #   tabPanel("Your CruisePass",
      #            p('Please save or print out your CruisePass card. Or at least
      #              remember your cabin number. Your CruisPass card reflects the
      #              information you entered before the latest time you pressed
      #              "Create my CruisePass Card"'),
      # )
    )
  )
)))

