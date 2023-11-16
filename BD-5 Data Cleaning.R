#library statements
library(dplyr)
library(stringr)

#read in dataframes
gdp_df <- read.csv("~/Downloads/GDP by Country 1999-2022.csv")
happiness_df <- read.csv("~/Downloads/2022.csv")

#join dataframes
df <- merge(x = gdp_df, y = happiness_df,
            by.x = "Country",
            by.y = "Country",
            all.x = TRUE
)

new_df <- filter(df, Year >= 2020)