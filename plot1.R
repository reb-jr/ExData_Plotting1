#Post-Tidy Data
#    DateTime: POSIXlt
#    Global_active_power: household global minute-averaged active power (in kilowatt)
#    Global_reactive_power: household global minute-averaged reactive power (in kilowatt)
#    Voltage: minute-averaged voltage (in volt)
#    Global_intensity: household global minute-averaged current intensity (in ampere)
#    Sub_metering_1: energy sub-metering No. 1 (in watt-hour of active energy). It corresponds to the kitchen, containing mainly a dishwasher, an oven and a microwave (hot plates are not electric but gas powered).
#    Sub_metering_2: energy sub-metering No. 2 (in watt-hour of active energy). It corresponds to the laundry room, containing a washing-machine, a tumble-drier, a refrigerator and a light.
#    Sub_metering_3: energy sub-metering No. 3 (in watt-hour of active energy). It corresponds to an electric water-heater and an air-conditioner.

plot1 <- function(){
     getUsageData <- function(){
          #download the dataset if it doesn't exist
          if (!file.exists("household_power_consumption.txt")){
               print("downloading source data...")
               download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip","source_data.zip")
               
               print("extracting source data...")
               unzip("source_data.zip")
          }
          
          #load the data we care about
          print("loading data")
          data <- subset(read.table(
               "household_power_consumption.txt"
               ,col.names = c("Date","Time","Global_active_power","Global_reactive_power","Voltage","Global_intensity","Sub_metering_1","Sub_metering_2","Sub_metering_3")
               ,header=TRUE
               ,sep=";"
               ,na.strings="?"
               ,colClasses = c("character","character","numeric","numeric","numeric","numeric","numeric","numeric","numeric")
          ),Date=="1/2/2007" | Date == "2/2/2007")
          
          #clean-up the dates and times into a unified, POSIXlt DateTime column
          print("tidying data")
          data$Date <- strptime(paste(data$Date,data$Time),"%d/%m/%Y %H:%M:%S")
          data <- data %>% subset(select=-c(Time)) 
          names(data)[names(data)=="Date"] <- "DateTime"
          
          data
     }
     
     usageData <- getUsageData()
     
     print("plotting usageData")
     png('plot1.png',width = 480, height = 480,units = "px")
     hist(usageData$Global_active_power, col = "red", xlab="Global Active Power (kilowatts)", main = "Global Active Power")
     dev.off()
     
     #data
}

#execute the plot
plot1()