library(httr)
library(sqldf)

if (!file.exists("data")) {
        dir.create("data")
        
        download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", "./data/1_1.zip", method="curl")
        
        unzip("data/1_1.zip", exdir="./data/")
        
}

if (!exists("hpc")) {
        hpc<-read.csv.sql("./data/household_power_consumption.txt", sql='select * from file where Date = "1/2/2007" OR Date = "2/2/2007"', sep=";")
        
        hpc$Dates <- strptime(paste(hpc$Date,hpc$Time), "%d/%m/%Y %H:%M:%S")
}

# change their empty data to NA
hpc$Global_active_power[hpc$Global_active_power=="?"]<-NA
length(which(is.na(hpc$Global_active_power)))

with(hpc, plot(Dates, Global_active_power, ylab="Global Active Power (kilowatts)", xlab="", type="n"))
with(hpc, lines(Dates, Global_active_power))

dev.copy(png, file ="./figure/plot2.png")

dev.off() 
