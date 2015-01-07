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

hpc$Global_active_power[hpc$Global_active_power=="?"]<-NA
length(which(is.na(hpc$Global_active_power)))

hpc$Global_reactive_power[hpc$Global_reactive_power=="?"]<-NA
length(which(is.na(hpc$Global_reactive_power)))

hpc$Voltage[hpc$Voltage=="?"]<-NA
length(which(is.na(hpc$Voltage)))

par(mfrow = c(2, 2))
par("mar"=c(4, 4, 1, 1))
with(hpc, {
        plot(Dates, Global_active_power, cex.lab=.7, ylab="Global Active Power", xlab="", type="n")
        lines(Dates, Global_active_power)
        plot(Dates, Voltage, cex.lab=.7, ylab="Voltage", xlab="datetime", type="n")
        lines(Dates, Voltage)
        plot(Dates, Sub_metering_1, cex.lab=.7, ylab="Energy Sub Metering", xlab="", type="n")
        lines(Dates, Sub_metering_1)
        lines(Dates, Sub_metering_2, col="red")
        lines(Dates, Sub_metering_3, col="blue")
        legend("topright", box.lwd=0, lty = 1, cex=.5, lwd=1, col = c("black","blue", "red"), legend = c("Sub metering 1", "Sub metering 2", "Sub metering 3"))       
        plot(Dates, Global_reactive_power, cex.lab=.7, ylab="Global Reactive Power", xlab="datetime", type="n")
        lines(Dates, Global_reactive_power)
}
     )
          
dev.copy(png, file ="./figure/plot4.png")

dev.off() 
