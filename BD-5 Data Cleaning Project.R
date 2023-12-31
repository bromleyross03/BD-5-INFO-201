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
rownames(df) <- 1:nrow(df)

df_sorted <- df[order(-df$Happiness.score), ]

df$Ranked_Country <- df_sorted$Country

df$happy_index <- df$Happiness.score[order(-df$Happiness.score)]

df_sorted$gdp_fix <- as.numeric(df$X2022)

#max_index <- max(happy_index)
#df$scaled_happiness_effienciency <- (df$happy_index / max_index) * 100
#new_df <- data.frame(summary(df$Happiness.score))
#g_df <- group_by(df, Country)
#stats_per_region <- summarise(g_df, 
 #                          avg_poverty_percent = mean(Happiness.score),
    #                       median_poverty_percent = median(Happiness.score))

#summary <- summarise(group_by(df, Country)),


# Summarize data
summary_df <- summarise(group_by(df), 
                           AverageHappiness = mean(happy_index, na.rm = TRUE), 
                           MedianHappiness = median(happy_index, na.rm = TRUE),
                           SDHappiness = sd(happy_index, na.rm = TRUE),
                           MinHappiness = min(happy_index, na.rm = TRUE),
                           MaxHappiness = max(happy_index, na.rm = TRUE),
                           AverageGDP = mean(Explained.by..GDP.per.capita, na.rm = TRUE),
                           MedianGDP = median(Explained.by..GDP.per.capita, na.rm = TRUE),
                           SDGDP = sd(Explained.by..GDP.per.capita, na.rm = TRUE),
                           MinGDP = min(Explained.by..GDP.per.capita, na.rm = TRUE),
                           MaxGDP = max(Explained.by..GDP.per.capita, na.rm = TRUE))


#df[] <- lapply(df, function(x) as.numeric(gsub(",", ".", x)))
