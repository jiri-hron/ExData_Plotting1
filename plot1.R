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
png(filename = "plot1.png",
    width=480,
    height=480,
    units="px");

hist(consumpt07$Global_active_power,
     freq = T,
     main = "Global Active Power",
     xlab = "Global Active Power (killowatts)",
     ylab = "Frequency", col = "red");

dev.off();