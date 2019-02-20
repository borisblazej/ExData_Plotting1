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

two_days <- power %>% subset(Date >= start_date & Date <= end_date) %>%
    mutate(Datetime = ymd_hms(ymd(Date) + hms(Time)))
rm("power")

## format drawing area
par(mfrow = c(1,1))

## Generate plot3
### Line 1 -> black
with(two_days, plot(x=Datetime, y=Sub_metering_1, type ="l", xlab="",
                     ylab = "Energy Submetering"))

### Line 2 -> red
with(two_days, lines(x=Datetime, y=Sub_metering_2, col = "red"))

### Line 3 -> blue
with(two_days, lines(x=Datetime, y=Sub_metering_3, col = "blue"))

### Legend
legend("topright", col = c("black", "red", "blue"), lty=1, lwd=1,
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       y.intersp = 0.8)

## Seave the plot to a png file
dev.copy(device = png, filename = "plot3.png", width = 480, height = 480)
dev.off()
