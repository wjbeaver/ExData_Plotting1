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
hpc$Sub_metering_1[hpc$Sub_metering_1=="?"]<-NA
length(which(is.na(hpc$Sub_metering_1)))

hpc$Sub_metering_2[hpc$Sub_metering_2=="?"]<-NA
length(which(is.na(hpc$Sub_metering_2)))

hpc$Sub_metering_3[hpc$Sub_metering_3=="?"]<-NA
length(which(is.na(hpc$Sub_metering_3)))

with(hpc, plot(Dates, Sub_metering_1, ylab="Energy Sub Metering", xlab="", type="n"))
with(hpc, lines(Dates, Sub_metering_1))
with(hpc, lines(Dates, Sub_metering_2, col="red"))
with(hpc, lines(Dates, Sub_metering_3, col="blue"))
legend("topright", lty = 1, cex=.7, lwd=1, col = c("black","blue", "red"), legend = c("Sub metering 1", "Sub metering 2", "Sub metering 3"))

dev.copy(png, file ="./figure/plot3.png")

dev.off() 
