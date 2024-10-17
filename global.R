library(googlesheets4);  # for persistence to Google Sheets
library(dplyr);          # for data wrangling
library(charlatan);      # for name generation

# lookup tables ----

# . crew_archetypes ----
crew_archetypes <- c("Engineer", "Deckhand", "Security", "Cook"
                     , "Bartender", "Waiter", "Steward", "Entertainment: Dance"
                     , "Entertainment: Musical Theater"
                     , "Entertainment: Comedian"
                     , "Entertainment: Musician"
                     , "Entertainment: Stage Tech"
                     , "Sales Clerk" , "Janitor"
                     , "Yoga Instructor", "Spa/Salon Staff"
                     , "Sports & Adventure Coach", "Lifeguard"
                     , "Kids Club Counsellor", "Ship Doctor", "Chaplain", "Bridge Crew"
                     , "Entertainment: Magician", "Casino Card Dealer", "Maintenance"
                     , "Computer Admin", "Entertainment Director"
                     , "Other","Surprise me");

# . passenger_archetypes ----
passenger_archetypes <- c("Eccentric Billionaire", "Conspiracy Theorist"
                          , "Influencer", "Pop Star", "Travel Journalist"
                          , "Nature-Lover", "Ghost Hunter"
                          , "Recent Armed Forces Veteran", "Off-duty Cop"
                          , "Environmentalist", "Firefighter", "Doctor"
                          , "Extreme Sports Enthusiast"
                          #, "The bodyguard of a someone who suddenly died of natural causes"
                          , "Lottery winner", "Actor"
                          , "Retired Detective", "Doomsday Prepper"
                          , "Tech Bro", "Gamer", "Rebellious Teenager"
                          , "Popular Teenager", "Athlete", "MMA Fighter"
                          , "Professor", "DIY Inventor", "Hipster"
                          , "Wokester", "Private Investigator", "Smuggler"
                          , "Gambler", "Con-Artist"
                          , "Other","Surprise me");


# . passenger_skills ----
passenger_skills <- c(
  "Basic first aid", "Navigation", "Wilderness survival",
  "Lockpicking", "Firearms","Bladed weapons", "Archery", "Stealth", "Endurance",
  "Electronic devices", "Mechanical devices", "Fishing", "Improvised weapons",
  "Martial arts", "Scuba diving", "Swimming", "Climbing", "Entertaining", "Agility",
  "Hacking", "Charisma", "Leadership", "Critical thinking", "Strength", "Toughness",
  "Skepticism", "Faith", "Situational awareness", "Sign language", "Sense motive",
  "Animal handling", "Explosives", "Disguises",
  "Willpower", "Scavenging", "Occult lore", "Maritime lore", "Science lore",
  "Magical cantrips", "Meditation")

passenger_skills_with_descriptions <- c(
  `Basic first aid` = "Use for treating wounds, injuries, or stabilizing someone.",
  `Navigation` = "Use for determining direction, plotting courses, or reading maps.",
  `Wilderness survival` = "Use for foraging, finding shelter, or surviving in nature.",
  `Lockpicking` = "Use for bypassing locked doors or containers.",
  `Firearms` = "Use for shooting guns with precision and control.",
  `Bladed weapons` = "Use for attacking with knives, swords, or other sharp tools.",
  `Archery` = "Use for shooting arrows or projectiles with a bow.",
  `Stealth` = "Use for sneaking, hiding, or avoiding detection.",
  `Endurance` = "Use for resisting fatigue, pain, or physical exhaustion.",
  `Electronic devices` = "Use for operating or repairing computers and gadgets.",
  `Mechanical devices` = "Use for fixing or understanding mechanical systems.",
  `Fishing` = "Use for catching fish with rods, nets, or improvised tools.",
  `Improvised weapons` = "Use for fighting with random objects at hand.",
  `Martial arts` = "Use for engaging in hand-to-hand combat or self-defense.",
  `Scuba diving` = "Use for swimming or navigating underwater with equipment.",
  `Swimming` = "Use for swimming or staying afloat without equipment.",
  `Climbing` = "Use for scaling walls, trees, or steep surfaces.",
  `Entertaining` = "Use for performing, singing, or keeping others entertained.",
  `Agility` = "Use for balancing, dodging, or moving gracefully.",
  `Hacking` = "Use for breaching security systems or accessing restricted data.",
  `Charisma` = "Use for persuading, influencing, or charming others.",
  `Leadership` = "Use for influencing groups of people or coordinating group efforts.",
  `Critical thinking` = "Use for solving problems or making logical deductions.",
  `Strength` = "Use for lifting, carrying, or breaking objects with force.",
  `Toughness` = "Use for resisting physical harm or enduring hardship.",
  `Skepticism` = "Use for seeing through lies, deceptions, insanity, or superstitions.",
  `Faith` = "Use for drawing strength from beliefs or inspiring others spiritually, providing protection against insanity.",
  `Situational awareness` = "Use for noticing hidden dangers or opportunities.",
  `Sign language` = "Use for communicating silently or across noisy spaces.",
  `Sense motive` = "Use for discerning others' intentions or emotions.",
  `Animal handling` = "Use for calming, training, or guiding animals.",
  `Explosives` = "Use for handling or setting up explosive devices.",
  `Disguises` = "Use for altering appearance to avoid recognition.",
  `Willpower` = "Use for resisting temptation, mental manipulation, or insanity.",
  `Scavenging` = "Use for finding useful items in unlikely places.",
  `Occult lore` = "Use for identifying magical rituals or supernatural knowledge.",
  `Maritime lore` = "Use for recalling sea-related knowledge and traditions.",
  `Science lore` = "Use for applying scientific knowledge to situations.",
  `Magical cantrips` = "Use for casting minor spells or illusions and resisting t.",
  `Meditation` = "Use on self or others for calming the mind or focusing inner energy, providing protection and partial reversal of insanity."
)


# . motivations ----
motivations <- c(
  "Escape a troubled past",
  "Find hidden treasure",
  "Discover a family secret",
  "Prove bravery or strength",
  "Investigate strange occurrences",
  "Reconnect with a lost love",
  "Protect a valuable artifact",
  "Uncover a cult conspiracy",
  "Seek revenge on someone aboard",
  "Solve a mysterious disappearance",
  "Hide from dangerous enemies",
  #"Complete a secret mission",
  "Win the approval of a loved one",
  "Protect a fellow passenger or crew member",
  "Cover up a personal crime",
  "Uncover a crime",
  "Fulfill a personal prophecy",
  "Expose someone’s dark secret",
  "Overcome a personal fear or phobia",
  #  "Protect the ship from impending danger",
  "Seek spiritual enlightenment",
  "Pull off a lucrative con or heist"
)

# . archetypes_plus ----
archetypes_plus <- list(
  `Doomsday Prepper` = list(
    skills = c("Basic first aid", "Wilderness survival", "Firearms", "Bladed weapons", "Archery", "Fishing","Mechanical devices","Improvised weapons","Scavenging"),
    motivations = c()
  ),
  `Eccentric Billionaire` = list(
    skills = c("Charisma", "Leadership", "Critical thinking","Skepticism", "Situational awareness","Sense motive"),
    motivations = c("Find hidden treasure",
                    "Hide from dangerous enemies",
                    "Seek revenge on someone aboard",
                    "Cover up a personal crime")
  ),
  `Conspiracy Theorist` = list(
    skills = c("Hacking","Faith","Skepticism","Occult lore"),
    motivations = c("Find hidden treasure",
                    "Investigate strange occurrences",
                    "Uncover a cult conspiracy",
                    "Hide from dangerous enemies",
                    "Solve a mysterious disappearance",
                    "Uncover a crime",
                    "Expose someone’s dark secret")
  ),
  `Influencer` = list(
    skills = c("Entertaining", "Charisma"),
    motivations = c()
  ),
  `Pop Star` = list(
    skills = c("Entertaining", "Charisma"),
    motivations = c()
  ),
  `Nature-Lover` = list(
    skills = c("Animal handling", "Fishing", "Swimming", "Climbing","Wilderness survival"),
    motivations = c()
  ),
  `Ghost Hunter` = list(
    skills = c("Critical thinking","Skepticism", "Faith", "Willpower", "Scavenging", "Magical cantrips"),
    motivations = c("Find hidden treasure",
                    "Discover a family secret",
                    "Investigate strange occurrences",
                    "Uncover a cult conspiracy",
                    "Solve a mysterious disappearance",
                    "Fulfill a personal prophecy",
                    "Expose someone’s dark secret")
  ),
  `Retired Detective` = list(
    skills = c("Critical thinking", "Lockpicking", "Firearms", "Hacking", "Skepticism","Situational awareness","Sense motive","Disguises"),
    motivations = c("Find hidden treasure",
                    "Discover a family secret",
                    "Investigate strange occurrences",
                    "Uncover a cult conspiracy",
                    "Solve a mysterious disappearance",
                    "Uncover a crime",
                    "Fulfill a personal prophecy",
                    "Expose someone’s dark secret")
  )
  ,`Gambler`=list(skills=c("Critical thinking","Skepticism","Situational awareness","Sense motive"),motivations=c())
  ,`Con-Artist`=list(skills=c("Lockpicking","Hacking","Skepticism","Situational awareness","Sense motive","Charisma","Disguises"),motivations=c())
  ,`Private Investigator`=list(skills=c("Critical thinking","Lockpicking","Firearms","Hacking","Skepticism","Situational awareness","Sense motive","Disguises"),motivations=c())
  ,`Smuggler`=list(skills=c("Firearms","Situational awareness","Sense motive","Disguises","Maritime lore","Navigation"),motivations=c())
  ,`Travel Journalist`=list(skills=c('Wilderness survival', 'Scuba diving', 'Entertaining', 'Maritime lore', 'Navigation','Fishing','Charisma'),motivations=c())
  ,`Nature-Lover`=list(skills=c('Wilderness survival','Navigation','Endurance','Archery','Fishing','Scuba diving','Swimming','Climbing','Agility','Toughness','Animal handling'),motivations=c())
  ,`Recent Armed Forces Veteran`=list(skills=c('Basic first aid','Navigation','Wilderness survival','Firearms','Stealth','Endurance','Martial arts','Climbing','Agility','Leadership','Strength','Toughness','Situational awareness','Explosives','Willpower','Maritime lore'),motivations=c())
  ,`Off-duty cop`=list(skills=c('Basic first aid','Firearms','Martial arts','Leadership','Strength','Toughness','Situational awareness','Sense motive'),motivations=c())
  ,`Environmentalist`=list(skills=c('Hacking','Charisma','Leadership','Skepticism','Faith','Science lore','Critical thinking'),motivations=c())
  ,`Firefighter`=list(skills=c('Basic first aid','Leadership','Strength','Toughness','Situational awareness','Endurance','Climbing'),motivations=c())
  ,`Doctor`=list(skills=c('Basic first aid','Critical thinking','Science lore'),motivations=c())
  ,`Extreme Sports Enthusiast`=list(skills=c('Endurance','Agility','Climbing','Swimming'),motivations=c())
  ,`Actor`=list(skills=c('Entertaining','Charisma','Disguises'),motivations=c())
  ,`Tech Bro`=list(skills=c('Hacking','Electronic devices','Charisma','Leadership','Critical thinking','Sense motive'),motivations=c())
  ,`Gamer`=list(skills=c('Electronic devices','Hacking','Critical thinking'),motivations=c())
  ,`Rebellious Teenager`=list(skills=c('Lockpicking','Improvised weapons','Hacking','Skepticism','Sense motive'),motivations=c())
  ,`Popular Teenager`=list(skills=c('Charisma','Leadership','Sense motive'),motivations=c())
  ,`Athlete`=list(skills=c('Endurance','Agility','Toughness','Strength'),motivations=c())
  ,`MMA Fighter`=list(skills=c('Martial arts'),motivations=c())
  ,`Professor`=list(skills=c('Critical thinking','Skepticism','Occult lore','Science lore'),motivations=c())
  ,`DIY Inventor`=list(skills=c('Critical thinking','Skepticism','Science lore','Explosives','Electronic devices','Mechanical devices','Hacking','Scavenging'),motivations=c())
)

# . debuffs ----
debuffs <- debuffs <- c(
  `Seasickness` = "Easily nauseated by the ship’s movement, reducing effectiveness in physical tasks.",
  `Aquaphobia` = "Fear of water makes it hard to deal with the sea or swim.",
  `Claustrophobic` = "Becomes anxious in small or enclosed spaces, impacting focus and decision-making.",
  `Motion Sickness` = "Trouble focusing during movement, especially on unstable surfaces like the ship’s deck.",
  `Vertigo` = "Difficulty maintaining balance, especially in high places.",
  `Nightmares` = "Experiences terrifying dreams that disrupt sleep, reducing stamina and mental clarity.",
  `Paranoia` = "Always suspects others of foul play, causing difficulty trusting allies and following plans.",
  `Poor Vision` = "Struggles to see clearly without glasses or in dimly lit areas.",
  `Nervous` = "Easily panicked or flustered, causing slow reactions in high-pressure situations.",
  `Insomnia` = "Has trouble sleeping, leading to exhaustion and reduced performance.",
  `Imposter Syndrome` = "Constant self-doubt, hindering confidence in skills or decisions.",
  `Weak Constitution` = "Prone to illnesses and physical fatigue, making recovery from injuries slower.",
  `Loudmouth` = "Tends to speak loudly or at the wrong time, attracting unwanted attention.",
  `Fear of Blood` = "Panics or becomes faint when exposed to blood, reducing effectiveness in medical or combat situations.",
  `Cowardice` = "Easily frightened and more likely to flee from danger instead of fighting.",
  `Forgetful` = "Frequently forgets important details or items, causing issues when managing resources or planning.",
  `Overconfidence` = "Takes unnecessary risks, assuming they’ll always succeed.",
  `Poor Swimmer` = "Struggles with swimming, making it difficult to survive or escape water-related dangers.",
  `Gullible` = "Easily tricked or manipulated by others.",
  `Greedy` = "Has to roll to resist temptation to acquire wealth or valuables, causing distraction or reckless decisions.",
  `Pacifist` = "Refuses to engage in combat (automatic fail of any aggressive action), severely limiting options in violent encounters.",
  `Superstitious` = "Easily swayed by irrational beliefs, making it difficult to focus on logic or reason, vulnerable to indoctrination.",
  `Frail` = "Physically weak and easily injured, lowering effectiveness in physically demanding tasks.",
  `Slow Reflexes` = "Has trouble reacting quickly in time-sensitive situations.",
  `Clumsy` = "Often trips, drops things, or makes mistakes, leading to accidents or failures.",
  `Overanxious` = "Frequently worries about worst-case scenarios, causing indecision or hesitation.",
  `Compulsive gambler` = "Must roll to resist any temptation to gamble. Ironic, right?",
  `Fear of Heights` = "Becomes dizzy and frightened when near balconies or the edges of open-air decks",
  `Easily Distracted` = "Struggles to stay focused on tasks, especially in chaotic or noisy environments.",
  `Compulsive Gambler` = "Always looking for an opportunity to gamble, even in inappropriate situations.",
  `Bad Liar` = "Terrible at deception, often getting caught when trying to lie or manipulate.",
  `Overtly Honest` = "Struggles to keep secrets or tell lies, even when necessary.",
  `Inflexible` = "Rigid in their thinking, unable to adapt easily to new plans or strategies.",
  `Vain` = "Preoccupied with appearance and reputation, sometimes prioritizing these over practical concerns.",
  `Lazy` = "Avoids exerting effort unless absolutely necessary, preferring to let others take charge.",
  `Impulsive` = "Tends to act without thinking, often getting into trouble or causing unintended consequences.",
  `Fear of Darkness` = "Becomes anxious and ineffective in dark areas, refusing to go into unlit spaces.",
  `Nearsighted` = "Has difficulty seeing things clearly at a distance, making long-range perception or aiming difficult.",
  `Hot-headed` = "Easily angered, leading to rash decisions or unnecessary conflict.",
  `Obsessive` = "Fixates on a particular goal or idea, to the detriment of everything else.",
  `Unlucky` = "Seems to attract bad luck, with plans often going wrong for no apparent reason.",
  #`Overburdened` = "Carries too much equipment or personal items, slowing them down or limiting physical ability.",
  `Stubborn` = "Refuses to change their mind or admit they’re wrong, even when it’s obvious.",
  `Shaky Hands` = "Has trouble with fine motor skills, making delicate tasks like aiming or lockpicking difficult."
)



# functions ----

# Function for customized skills/motivations
select_for_arch <- function(archetype
                            ,default_motivation=NA
                            ,default_skill=NA
                            ,archdb=archetypes_plus
                            ,common_motivations=motivations
                            ,common_skills=names(passenger_skills_with_descriptions)){
  # find the entry if any
  arch <- archdb[[archetype]];

  # select one random skill and one random motivation falling back on
  # common skills and motivations if no archetype-specific ones found
  # if there
  selected_skill <- arch$skills %>% {
    if(length(.)>0) . else {
      if(is.na(default_skill)) common_skills else default_skill
    }} %>% sample(1)
  selected_motivation <- arch$motivations %>% {
    if(length(.)>0) . else {
      if(is.na(default_motivation)) common_motivations else default_motivation
    }} %>% sample(1)

  # select that entry's available skills and motivations if any,
  # appending the common skills and motivations respectively
  out <- list(skills=union(default_skill,arch$skills) %>%
                na.omit %>% union(common_skills)
              ,motivations=union(default_motivation,arch$motivations) %>%
                na.omit %>% union(common_motivations)
              ,selected_skill = selected_skill
              ,selected_motivation = selected_motivation);
  out;
}

# Function to generate a random name
name_engine <- PersonProvider$new();
generate_random_name <- function(gender=c('either','male','female')){
  switch(match.arg(gender)
         ,male=paste(name_engine$first_name_male(),name_engine$last_name_male())
         ,female=paste(name_engine$first_name_female(),name_engine$last_name_female())
         ,paste(name_engine$first_name(),name_engine$last_name()))}

# Function to generate a unique ID for each character
generate_unique_id <- function() {
  paste0("ID-", paste0(sample(LETTERS, 3, replace = TRUE),collapse=''), "-", sample(1000:9999, 1))
};

random_select <- function(xx,exclude=c('Other','Surprise me!'),choose=1){
  sample(setdiff(xx,exclude),choose)};

source('local.config.R');
try(gs4_auth(token=token));

c()