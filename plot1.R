# Explorartory Data ANalysis, Week 1 Project 

library(tidyverse)
library(readr)
library(lubridate)

## Download original dataset

zipUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
zipFile <- "exdata_data_household_power_consumption.zip"
if (!file.exists(zipFile)) {
    download.file(zipUrl, zipFile, mode = "wb")
}

## unzip zip file containing data if data directory doesn't already exist
extracted <- "household_power_consumption.txt"
if (!file.exists(extracted)) {
    unzip(zipFile)
}

## read data and delete files
power <- read_delim("household_power_consumption.txt", ";", 
                    escape_double = FALSE,
                    col_types = cols(Date = col_date(format = "%d/%m/%Y"),
                                     Time = col_time(format = "%H:%M:%S")),
                    trim_ws = TRUE)

file.remove("./exdata_data_household_power_consumption.zip")
file.remove("./household_power_consumption.txt")

## subset data and free memory

start_date <- dmy("1/2/2007")
end_date <- dmy("2/2/2007")

two_days <- power %>% subset(Date >= start_date & Date <= end_date)
rm("power")


## format drawing area
par(mfrow = c(1,1))

## Generate plot1
with(two_days, hist(Global_active_power, xlab = "Global Active Power (kilowatts)", 
                    ylab = "Frequency", main = "Global Active Power",
                    col = "red"))


## Seave the plot to a png file
dev.copy(device = png, filename = "plot1.png", width = 480, height = 480)
dev.off()
