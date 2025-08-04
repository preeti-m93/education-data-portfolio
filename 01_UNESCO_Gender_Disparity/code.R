#Load required libraries
library(httr) # for making HTTP requests
library(jsonlite) 
library(dplyr)
library(ggplot2)
library(tidyr)
library(DT) # for interactive tables

# Fetch data for gender-wise primary and lower secondary completion
# Indicator codes for:
# CR.1.F = Primary completion rate (Female)
# CR.1.M = Primary completion rate (Male)
# CR.2.F = Lower Secondary completion rate (Female)
# CR.2.M = Lower Secondary completion rate (Male)
indicators <- c("CR.1.F", "CR.1.M", "CR.2.F", "CR.2.M")

# Define the countries with their ISO codes
countries <- c("IND" = "India", "NPL" = "Nepal", "BGD" = "Bangladesh")

# Function to fetch data from the UIS API for a given indicator and country
fetch_data <- function(indicator, country_code) {
  url <- "https://api.uis.unesco.org/api/public/data/indicators"
  
# Make the API request
response <- VERB("GET", url, query = list(
    indicator = indicator,
    geoUnit = country_code,
    start = "2000",                   # Start from year 2000
    footnotes = "false",
    indicatorMetadata = "false"
  ))

# Parse the JSON response and handle errors
  json <- tryCatch({
    fromJSON(content(response, "text"), flatten = TRUE)
  }, error = function(e) return(NULL))

# Extract records from JSON structure
  records <- json$records
  if (length(records) == 0) return(NULL)

# Convert to data frame and attach metadata
df <- as.data.frame(records)
df$indicator <- indicator
df$country <- countries[[country_code]]
return(df)
}

# Fetch and combine all data for all indicator-country combinations
all_data <- bind_rows(lapply(indicators, function(ind) {
  bind_rows(lapply(names(countries), function(cty) {
    fetch_data(ind, cty)
  }))
}))

# Data preparation and cleaning
# Clean and prepare the combined dataset
df_clean <- all_data %>%
  select(year, value, country, indicator) %>% # Keep only relevant columns
  filter(!is.na(value)) %>%                   # Remove NAs
  mutate(
    # Create a new variable for level of education based on indicator code
    level = case_when(
    grepl("CR.1", indicator) ~ "Primary",
    grepl("CR.2", indicator) ~ "Lower Secondary"
  ),
  # Create a new variable for gender based on indicator suffix
  gender = case_when(
    grepl(".F$", indicator) ~ "Female",
    grepl(".M$", indicator) ~ "Male"
  ))


# Create an interactive searchable table of the cleaned data
datatable(df_clean, filter = "top", 
          caption = "Completion Rate (Primary and Lower Secondary) by Gender and Country",
          options = list(pageLength = 10))
                   
#Gender-wise plot (Country comparison)
# Create a faceted line plot showing trends in completion rate
# Facets: education level (Primary vs Lower Secondary) × gender (Male vs Female)
# Line color = country (India, Nepal, Bangladesh)

ggplot(df_clean, aes(x = year, y = value, color = country)) +
  geom_line(size = 1.1) +                # Draw lines connecting yearly data
  geom_point(size = 2) +                 # Add points for each data value
  facet_grid(level ~ gender) +           # Facet the plot by education level and gender
  labs(
    title = "Completion rate by gender and education level",
    subtitle = "Compared across India, Nepal and Bangladesh",
    x = "Year", y = "Completion rate (%)", color = "Country"
  ) +
  theme_minimal()    


                   
                   
                   
