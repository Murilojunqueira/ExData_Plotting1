####   Cousera Online course    ####
####   Exploratory Data Analysis  ####
####   Course Project 1   ####
####   Plot 1   ####


# Script to create plot1.png 
# "Course Project 1" of Exploratory Data Analysis course
# Coursera online course


# Check if necessary packages are installed and install them if is needed
list.of.packages <- c("data.table", "dplyr")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)
rm(list.of.packages, new.packages)

# load packages
library(data.table)
library(dplyr)

# Change working directory
WorkingDir <- "C:/Users/Murilo Junqueira/Dropbox/Acadêmico e Educação/Cursos Avulsos/2017-01 Exploratory Data Analysis/Semana 01/Course Project 1"
setwd(WorkingDir)
getwd() # checking if the working directory is correct
rm(WorkingDir)


# Download the dataset (if necessary)
if (!file.exists("household_power_consumption.zip")) {
  
  url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
  download.file(url, destfile = "household_power_consumption.zip")  
  rm(url)
  
}

## Set the class of the variables in order to load data more quickly
classVars <- c(rep("character", 2), rep("numeric", 4), rep("integer", 3))

# unzip and subset the file (if necessary)
# This commands avoid opening a large dataset or keep a big unziped file all the time
if (!file.exists("power_consumption_filtered.csv")) {
  unzip("household_power_consumption.zip")
  
  # load data full using fread
  data <- fread("household_power_consumption.txt", 
                colClasses = classVars,
                na.strings = "?")
  
  # Filter the first two days of February
  dataPlot <- data %>%
    filter(Date == "1/2/2007" | Date == "2/2/2007")
  
  # Save filtered dataset
  write.table(dataPlot, file = "power_consumption_filtered.csv",
              row.names=FALSE)
  
  # Drop the full dataset
  rm(data)
  
  # Deleted unziped file
  unlink("household_power_consumption.txt")
  
}


## Select variables (read only the columns that will be used)
Vars <- c("Date", "Global_active_power")

# read data
dataPlot <- fread("power_consumption_filtered.csv", 
              select = Vars,
              colClasses = classVars)


# Removing unused variables
rm(classVars, Vars)


# Set the right device
png(file="plot1.png",width=480,height=480)

# Create the plot
hist(dataPlot$Global_active_power, col = "red", 
     main = "Global Active Power",
     xlab = "Global Active Power (kilowats)",
     ylab = "Frequency")

# Close device
dev.off()
