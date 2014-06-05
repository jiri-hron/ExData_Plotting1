## Path should point to the file containing the original data, if not the file
## is downloaded from the url specified in README. Note that this may take
## a while.
plot1 <- function(path = "") {
  if(is.null(path) | path == "") {
    tmpDir = tempdir();
    on.exit(function() unlink(tmpDir, T, T));
    
    # ensure it's created
    dir.create(tmpDir, recursive=T, showWarnings=F);
   
    if(require(httr)) {
      message("no path specified, starting download, this may take a while ...");
      
      file = content(GET(paste0("https://d396qusza40orc.cloudfront.net",
                                "/exdata%2Fdata%2Fhousehold_power_consumption.zip")));
      
      message(paste("time downloaded:", date()));
      zipped = file.path(path, "data.zip");
      file.create(zipped);
      writeBin(file, zipped);
      
      unzippedDir = file.path(tmpDir, "unzipped");
      # recursive to ensure also tmp
      dir.create(unzippedDir, showWarnings=F);
      message("unzipping file");
      unzip(zipfile=zipped,exdir=unzippedDir);
      message("")
      path = file.path(unzippedDir, "household_power_consumption.txt");
    }
    else {
      stop(paste("wrong file-path",
                 filePath,
                 "and cannot access the httr library to download it instead"));
    }
  }
  
  ## read the data
  message("reading the data");
  consumpt = read.table(path,
                        header = T, 
                        sep = ";",
                        comment.char="",
                        na.strings="?",
                        stringsAsFactors = F);
  
  message("creating datetime");
  consumpt$DateTime = strptime(paste(consumpt$Date,
                                     consumpt$Time),
                               format = "%d/%m/%Y %H:%M:%S");
  
  ## subset the sample
  lowerBound = as.POSIXlt("2007-02-01 00:00:00");
  upperBound = as.POSIXlt("2007-02-02 23:59:59");
  
  message("subsetting from 2007-02-01 to 2007-02-02");
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
}