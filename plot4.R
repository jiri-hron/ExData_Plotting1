## read the data
consumpt = read.table(
  "./exdata_data_household_power_consumption/household_power_consumption.txt",
  header = T,
  sep = ";",
  comment.char="",
  na.strings="?",
  stringsAsFactors = F);

consumpt$DateTime = strptime(paste(consumpt$Date,
                                   consumpt$Time),
                             format = "%d/%m/%Y %H:%M:%S");

## subset the sample
lowerBound = as.POSIXlt("2007-02-01 00:00:00");
upperBound = as.POSIXlt("2007-02-02 23:59:59");

consumpt07 = subset(consumpt,
                    consumpt$DateTime >= lowerBound
                    & consumpt$DateTime <= upperBound);

## print the graph
png(filename = "plot4.png",
    width=480,
    height=480,
    units="px");

par(mfrow = c(2,2));

## set locale to english (otherwise will take system locale for x-axis desc)
Sys.setlocale("LC_TIME", "English");

## first graph
plot(consumpt07$DateTime,
     consumpt07$Global_active_power,
     type = "l",
     xlab = "",
     ylab = "Global Active Power (killowatts)");

## second graph
plot(consumpt07$DateTime,
     consumpt07$Voltage,
     type = "l", 
     xlab = "datetime",
     ylab = "Voltage");

## third graph
plot(consumpt07$DateTime,
     consumpt07$Sub_metering_1,
     type = "l",
     xlab = "",
     ylab = "Energy sub metering");
lines(consumpt07$DateTime,
      consumpt07$Sub_metering_2,
      col = "red");
lines(consumpt07$DateTime,
      consumpt07$Sub_metering_3,
      col = "blue");
legend("topright",
       col = c("black", "red", "blue"),
       legend = c("Sub_metering_1",
                  "Sub_metering_2",
                  "Sub_metering_3"),
       lwd = 1,
       bty = "n");

## fourth graph
plot(consumpt07$DateTime,
     consumpt07$Global_reactive_power,
     type = "l",
     xlab = "datetime",
     ylab = "Global_reactive_power");

par(mfrow = c(1,1));

dev.off();