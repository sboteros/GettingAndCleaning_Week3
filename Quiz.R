# Quiz 3. `dplyr` and `tidyr`
# Course: Getting and Cleaning data
# Data Science Specialization
# Santiago Botero S.
# sboteros@unal.edu.co

# General settings
  direccion <- "C:/Users/sbote/OneDrive/Documentos/DataScienceSpecialization/3 Getting and cleaning data/Week3/GettingAndCleaning_Week3"
  setwd(direccion)
  
  paquetes <- c("dplyr", "tidyr", "jpeg")
  for (i in paquetes) {
    if (!require(i, character.only = TRUE)) {
      install.packages(i)
    }
    library(i, character.only = TRUE)
  }
  
  if (!dir.exists("./data")) {dir.create("./data")}

# 1. The American Community Survey distributes downloadable data about United
# States communities. Download the 2006 microdata survey about housing for the
# state of Idaho using download.file() from here:
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv and load
# the data into R. The code book, describing the variable names is here:
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf
# Create a logical vector that identifies the households on greater than 10
# acres who sold more than $10,000 worth of agriculture products. Assign that
# logical vector to the variable agricultureLogical. Apply the which() function
# like this to identify the rows of the data frame where the logical vector is
# TRUE.
  
  if (!file.exists("./data/idaho.csv")) {
    download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv",
                  "./data/idaho.csv")
    download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf",
                  "./data/idaho.pdf", method = "curl")
  }
  idaho <- read.csv("./data/idaho.csv") %>% 
    tbl_df %>%
    mutate(agricultureLogical = (ACR == 3 & AGS == 6))

  which(idaho$agricultureLogical)

# What are the first 3 values that result?

  which(idaho$agricultureLogical)[1:3]
  
# 2. Using the jpeg package read in the following picture of your instructor
# into R https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg Use the
# parameter native=TRUE. What are the 30th and 80th quantiles of the resulting
# data? (some Linux systems may produce an answer 638 different for the 30th
# quantile)
  
  if (!file.exists("./data/picture.jpeg")) {
    download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg",
                  "./data/picture.jpeg", method = "curl")
  }
  readJPEG("./data/picture.jpeg", native = TRUE) %>%
    quantile(probs = c(0.3, 0.8))

# 3. Load the Gross Domestic Product data for the 190 ranked countries in this
# data set: https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv Load
# the educational data from this data set:
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv
# Match the data based on the country shortcode. How many of the IDs match? Sort
# the data frame in descending order by GDP rank (so United States is last).
# What is the 13th country in the resulting data frame? Original data sources:
# http://data.worldbank.org/data-catalog/GDP-ranking-table
# http://data.worldbank.org/data-catalog/ed-stats
  
  if (!file.exists("./data/gdp.csv")) {
    download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv",
                  "./data/gdp.csv")
  }
  if (!file.exists("./data/education.csv")) {
    download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv",
                  "./data/education.csv")
  }
  
  gdp <- read.csv("./data/gdp.csv", header = FALSE, skip = 5, 
                  na.strings = "", stringsAsFactors = FALSE) %>% 
    tbl_df %>%
    select(country = V1, ranking = V2, economy = V4, gdp = V5) %>%
    na.omit %>% 
    mutate(ranking = as.numeric(ranking), 
           gdp = gsub(",", "", gdp),
           gdp = as.numeric(gdp)) %>%
    print
  
  education <- read.csv("./data/education.csv") %>% tbl_df %>% print
  
  # How many ID match?
  length(intersect(gdp$country, education$CountryCode))
  
  # Unifying data
  unified <- merge(gdp, education,
                   by.x = "country", by.y = "CountryCode") %>% 
    tbl_df %>%
    arrange(desc(ranking)) %>%
    print
  
  # What is the 13th country in the resulting data frame?
  unified[13, c("country", "economy")]
  
# 4. What is the average GDP ranking for the "High income: OECD" and "High
# income: nonOECD" group?
  str(unified)
  table(unified$Income.Group)
  avg_gdp <- unified %>% 
    group_by(Income.Group) %>%
    summarize(mean(ranking)) %>%
    print
  
# 5. Cut the GDP ranking into 5 separate quantile groups. Make a table versus
# Income.Group. How many countries are Lower middle income but among the 38
# nations with highest GDP?
  
  quantiles <- quantile(unified$ranking, seq(0, 1, 0.2))
  highest <- unified %>%
    mutate(quantile = cut(ranking, breaks = quantiles))
  highest <- table(highest$Income.Group, highest$quantile) %>% print
  