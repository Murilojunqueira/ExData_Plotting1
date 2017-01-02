####   Cousera Online course    ####
####   Exploratory Data Analysis  ####
####   Course Project 1   ####
####   Plot 4   ####


# Script to create plot4.png 
# "Course Project 1" of Exploratory Data Analysis course
# Coursera online course


# Check if necessary packages are installed and install them if is needed
list.of.packages <- c("data.table", "dplyr", "lubridate")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)
rm(list.of.packages, new.packages)

# load packages
library(data.table)
library(dplyr)
library(lubridate)

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


# read data
dataPlot <- fread("power_consumption_filtered.csv", 
                  colClasses = classVars)

# Removing unused variables
rm(classVars)

# Creating date/time variable
dataPlot <- dataPlot %>%
  mutate(DateTime = dmy_hms(paste(Date, Time))) %>%
  select(DateTime, everything()) %>%
  select(-Date, -Time)

# Set week names in English
Sys.setlocale("LC_TIME", "English")

# Set the right device
png(file="plot4.png",width=480,height=480)

# set the multiple graphs (2 x 2) layout
par(mfrow = c(2,2))

# Ajust Margins
par(mar = c(5, 5, 1, 1))

#### Plot 4.1 ####

plot(dataPlot$DateTime, dataPlot$Global_active_power, 
     type = "l",
     ylab = "Global Active Power (kilowats)",
     xlab = "")

#### Plot 4.2 ####

plot(dataPlot$DateTime, dataPlot$Voltage, 
     type = "l",
     ylab = "Voltage",
     xlab = "datetime")

#### Plot 4.3 ####

# Add one line and axis labels
plot(dataPlot$DateTime, dataPlot$Sub_metering_1, 
     type = "l",
     ylab = "Energy sub metering",
     xlab = "")

# add sub metering 2 line
lines(dataPlot$DateTime, dataPlot$Sub_metering_2,
      col = "red")

# add sub metering 3 line
lines(dataPlot$DateTime, dataPlot$Sub_metering_3,
      col = "blue")

# Add legend
legend("topright", 
       lty=c(1,1), 
       col = c("black", "blue", "red"), 
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))


#### Plot 4.4 ####

plot(dataPlot$DateTime, dataPlot$Global_reactive_power, 
     type = "l",
     ylab = "Global_reactive_power",
     xlab = "datetime")

# Close device
dev.off()
