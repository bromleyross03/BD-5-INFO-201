#library statements
library(dplyr)
library(stringr)

#read in dataframes
gdp_df <- read.csv("GDP by Country 1999-2022.csv")
happiness_df <- read.csv("2022.csv")

#modify_country <- happiness_df$Country
#happiness_df[, modify_country] <- lapply(df[, modify_country], function(x) as.numeric(gsub("*", "", x)))

#happiness_df <- gsub("\\*", "", happiness_df$Country)

#join dataframes
df <- merge(x = gdp_df, y = happiness_df,
            by.x = "Country",
            by.y = "Country",
            all.x = TRUE
)


df$"X1999" <- NULL
df$"X2000" <- NULL
df$"X2001" <- NULL
df$"X2002" <- NULL
df$"X2003" <- NULL
df$"X2004" <- NULL
df$"X2005" <- NULL
df$"X2006" <- NULL
df$"X2007" <- NULL
df$"X2008" <- NULL
df$"X2009" <- NULL
df$"X2010" <- NULL
df$"X2011" <- NULL
df$"X2012" <- NULL
df$"X2013" <- NULL
df$"X2014" <- NULL
df$"X2015" <- NULL
df$"X2016" <- NULL
df$"X2017" <- NULL
df$"X2018" <- NULL
df$"X2019" <- NULL

columns_to_modify <- c("Happiness.score", "Whisker.high", "Whisker.low", "Dystopia..1.83....residual",
                       "Explained.by..GDP.per.capita", "Explained.by..Social.support",
                       "Explained.by..Healthy.life.expectancy", "Explained.by..Freedom.to.make.life.choices",
                       "Explained.by..Generosity", "Explained.by..Perceptions.of.corruption")

df[, columns_to_modify] <- lapply(df[, columns_to_modify], function(x) as.numeric(gsub(",", ".", x)))
df <- na.omit(df)
#df[] <- lapply(df, function(x) as.numeric(gsub(",", ".", x)))
