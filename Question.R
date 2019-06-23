# Quiz 3. Unable to convert some data
# Course: Getting and Cleaning data
# Data Science Specialization
# Santiago Botero S.
# sboteros@unal.edu.co
# Date: 2019/06/22
# Encoding: UTF-8

# General settings
direccion <- "WorkingDirectoryHere!"
setwd(direccion)

paquetes <- c("dplyr", "tidyr", "jpeg")
for (i in paquetes) {
  if (!require(i, character.only = TRUE)) {
    install.packages(i)
  }
  library(i, character.only = TRUE)
}

if (!dir.exists("./data")) {dir.create("./data")}

# Used data
if (!file.exists("./data/gdp.csv")) {
  download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv",
                "./data/gdp.csv")
}

# Data in "factor" class.
gdp_factor <- read.csv("./data/gdp.csv", header = FALSE, skip = 5,
                       na.strings = "") %>% 
  tbl_df %>%
  select(country = V1, ranking = V2, economy = V4, gdp = V5) %>%
  na.omit %>% print

# Data in "numeric" class.
gdp_numeric <- read.csv("./data/gdp.csv", header = FALSE, skip = 5,
                        na.strings = "") %>% 
  tbl_df %>%
  select(country = V1, ranking = V2, economy = V4, gdp = V5) %>%
  mutate(ranking = as.numeric(ranking), gdp = as.numeric(gdp)) %>%
  na.omit %>% print

# In the "numeric" version I got a Chinesse GDP of 39 and a ranking of 103, but
# in the factor version it's 8.2M and 2, respectively. Similar errors occurs in
# these two vectors.