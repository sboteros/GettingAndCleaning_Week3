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

# Do not read strings as factors!
gdp_factor <- read.csv("./data/gdp.csv", header = FALSE, skip = 5,
                       na.strings = "", 
                       stringsAsFactors = FALSE) %>%  # Not factors
  tbl_df %>%
  select(country = V1, ranking = V2, economy = V4, gdp = V5) %>%
  mutate(ranking = as.numeric(ranking),
         gdp = gsub(",", "", gdp), # Drop commas in numeric strings!
         gdp = as.numeric(gdp)) %>%
  na.omit %>% print

# If you read numeric 'strings' as factors, you'll get strange results!