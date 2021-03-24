##Calculating memory usage in MB
round(2075259*9*8/2^{20},2)

##Downloading and preparing the data
## Load packages
library(dplyr)
library(data.table)

## Download and unzip the file
zip <- "powerconsumption.zip"

if (!file.exists(zip)){
    fileurl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
    download.file(fileurl, zip, method = "curl")
}        

if(!file.exists("household_power_consumption")) {
    unzip(zip)
}   
##Read and prepare the data
pc1 <- fread("household_power_consumption.txt", sep = ";", header = TRUE)

pc1fil <- filter(pc1, Date == "1/2/2007"| Date == "2/2/2007") 

pc1fil <- mutate(pc1fil, datetime = paste(Date, Time, sep = " ")) %>%       
    relocate(datetime, .before = Global_active_power) %>%
    select(-Date, -Time) %>%
    transform(datetime=as.POSIXct(strptime(datetime, format = "%d/%m/%Y %H:%M:%S")))

pc1fil <- transform(pc1fil, Global_active_power = as.numeric(Global_active_power),
                    Global_reactive_power = as.numeric(Global_reactive_power),
                    Voltage = as.numeric(Voltage),
                    Global_intensity = as.numeric(Global_intensity),
                    Sub_metering_1 = as.numeric(Sub_metering_1),
                    Sub_metering_2 = as.numeric(Sub_metering_2)
)

##Multiple Base plot4
plot4 <- png(file = "plot4.png")

##
par(mfrow = c(2, 2))

##plot graphic 1
with(pc1fil,plot(datetime, Global_active_power, type = "l", ylab = "Global Active Power",
                 xlab = "")) 
##plot graphic 2
with(pc1fil,plot(datetime, Voltage, type = "l", ylab = "Voltage",
                 xlab = "datetime"))

##plot graphic 3
with(pc1fil,{ 
    plot(datetime, Sub_metering_1, type = "l", ylab = "Energy sub metering",
                      xlab = "")
    lines(datetime, Sub_metering_2, col = "red")
    lines(datetime, Sub_metering_3, col = "blue")
    legend("topright", col = c("black", "red", "blue"), legend = c("Sub_metering_1", "Sub_metering_2",
                    "Sub_metering_3"), lty = c(1,1), lwd = c(1,1), bty = "n")
})

##plot graphic 4
with(pc1fil,plot(datetime, Global_reactive_power, type = "l", ylab = "Global_reactive_power",
                 xlab = "datetime"))

dev.off()