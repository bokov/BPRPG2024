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
)

# . debuffs ----
debuffs <- c("Fear of Water", "Claustrophobic", "Motion Sickness", "Paranoia", "Terrible Luck", "Easily Distracted");

# functions ----

# Function for customized skills/motivations
select_for_arch <- function(archetype
                            ,default_motivation=NA
                            ,default_skill=NA
                            ,archdb=archetypes_plus
                            ,common_motivations=motivations
                            ,common_skills=passenger_skills){
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
generate_random_name <- function() paste(name_engine$first_name(),name_engine$last_name())

# Function to generate a unique ID for each character
generate_unique_id <- function() {
  paste0("ID-", paste0(sample(LETTERS, 3, replace = TRUE),collapse=''), "-", sample(1000:9999, 1))
};

random_select <- function(xx,exclude=c('Other','Surprise me!'),choose=1){
  sample(setdiff(xx,exclude),choose)};

source('local.config.R');
try(gs4_auth(token=token));

c()