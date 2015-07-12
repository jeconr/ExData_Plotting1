##helper function to download file if necessary
.manage_data_file <- function(download=TRUE) {
  if (download == TRUE) {
    data_url <- 'https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip'
    download.file(data_url, destfile = './data/IHEPC.zip')
  }
  ## Unzip
  if (file.exists('./data/IHEPC.zip')) {
    if (!file.exists('./data/household_power_consumption.txt')) {
      unzip('./data/IHEPC.zip', exdir='./data')
    }
  } else {
    stop('Downloading the file failed, please try downloading manually.')
  }
}

## Downloading data (if not yet available)
if (!file.exists('./data')) {
  dir.create('./data')
  .manage_data_file(download=TRUE)
} else { # data directory exists
  if (!file.exists('./data/household_power_consumption.txt')) {
    if (!file.exists('./data/IHEPC.zip')) 
      .manage_data_file(download=TRUE)
    else 
      .manage_data_file(download=FALSE)
  }
}

## read table data and header
header  <- read.table(file = './data/household_power_consumption.txt',sep = ';', nrows=1)
epc    <- read.table(file = './data/household_power_consumption.txt',sep = ';', nrows=2880, skip = 66637, stringsAsFactors = FALSE)

colnames(epc) <- unlist(header)


## convert Dates and Times

epc$Time <- strptime(paste(epc$Date, epc$Time), format = "%d/%m/%Y %H:%M:%S")
epc$Date <- as.Date(x=epc$Date, format="%d/%m/%Y")

##  1
png("plot1.png", width = 480, height = 480)
hist(x = epc$Global_active_power, col = "red", main = "Global Active Power", xlab = "Global Active Power(kilowatts)")
dev.off()

