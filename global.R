
# Vectors for character archetypes
crew_archetypes <- c("Captain", "First Mate", "Chief Engineer", "Deckhand", "Security Officer", "Chef", "Bartender", "Entertainment Director", "Other")
passenger_archetypes <- c("Eccentric Billionaire", "Conspiracy Theorist", "Fashion Influencer", "Pop Star", "Bird Watcher", "Ghost Hunter", "Retired Detective", "Paranoid Doomsday Prepper", "Other")

# Vector for debuffs/weaknesses
debuffs <- c("Fear of Water", "Claustrophobic", "Motion Sickness", "Paranoia", "Terrible Luck", "Easily Distracted")

# Function to generate a random name
generate_random_name <- function() {
  names <- c("John Doe", "Jane Smith", "Charlie Johnson", "Alex Carter", "Taylor Davis", "Chris Evans", "Morgan Lee", "Riley Parker")
  sample(names, 1)
}

# Function to generate a unique ID for each character
generate_unique_id <- function() {
  paste0("ID-", sample(LETTERS, 3, replace = TRUE), "-", sample(1000:9999, 1))
}
