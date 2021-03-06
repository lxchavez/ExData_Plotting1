library(data.table)

######### Read in zip file #########
setwd("~/Projects/ExData_Plotting1/")
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
file <- "household_power_consumption"
download.file(url, file, method = "curl")
unzip(file, exdir = "~/Projects/ExData_Plotting1/")
data <- fread("household_power_consumption.txt")

# Data and time variables are characters
class(data$Date)
class(data$Time)

# Change the format of Date variable
data$Date <- as.Date(data$Date, format="%d/%m/%Y")
class(data$Date)

# Subset the data for the two dates of interest
data_subset <- data[data$Date=="2007-02-01" | data$Date=="2007-02-02"]

# Convert data subset to a data frame
class(data_subset)
data_subset <- data.frame(data_subset)

# Convert columns to numeric
for(i in c(3:9)) {
  data_subset[,i] <- as.numeric(as.character(data_subset[,i]))
}

# Create Date_Time variable
data_subset$Date_Time <- paste(data_subset$Date, data_subset$Time)

# Convert Date_Time variable to proper format
data_subset$Date_Time <- strptime(data_subset$Date_Time, format="%Y-%m-%d %H:%M:%S")
class(data_subset$Date_Time)

# Export plot
png(filename = "plot4.png", width = 480, height = 480, units = "px", bg = "white")
par(mfrow = c(2, 2), mar = c(14, 6, 2, 2), cex=.5)

# Plot 2 in top left
plot(data_subset$Date_Time, data_subset$Global_active_power, xaxt = NULL, xlab = "", ylab = "Global Active Power", type = "n")
lines(data_subset$Date_Time, data_subset$Global_active_power, type = "S")

# Top right graph
plot(data_subset$Date_Time, data_subset$Voltage, xaxt=NULL, xlab = "datetime", ylab = "Voltage", type = "n")
lines(data_subset$Date_Time, data_subset$Voltage, type="S")

# Plot 3 in bottom left
plot(data_subset$Date_Time, data_subset$Sub_metering_1, xaxt=NULL, xlab = "", ylab = "Energy sub metering", type = "n")
lines(data_subset$Date_Time, data_subset$Sub_metering_1, col = "black", type = "S")
lines(data_subset$Date_Time, data_subset$Sub_metering_2, col = "red", type = "S")
lines(data_subset$Date_Time, data_subset$Sub_metering_3, col = "blue", type = "S")
legend("topright", bty = "n", lty = c(1, 1), lwd = c(1, 1, 1), col = c("black", "red", "blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))#### Bottom right graph

# Plot 4 in the bottom right
plot(data_subset$Date_Time, data_subset$Global_reactive_power, xaxt=NULL, xlab = "datetime", ylab = "Global_reactive_power", type="n")
lines(data_subset$Date_Time, data_subset$Global_reactive_power, type="S")

# Turn off device 
dev.off()