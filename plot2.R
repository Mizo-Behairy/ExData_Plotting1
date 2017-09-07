
# Getting the current working directory

initWorkDir <- getwd()

# Initiating new working directories

parentWorkDir <- "ExData_Plotting1"

dataWorkDir <- paste(parentWorkDir,"data", sep = "/")

# Checking if the new directory exists, if not create it

if(!file.exists(parentWorkDir)){
    
    dir.create(dataWorkDir, recursive = TRUE)
    
} else if(file.exists(parentWorkDir)){
    
    setwd(parentWorkDir)
    
    if(!file.exists("data")){
        
        dir.create("data")
        
    }
    
}

# Set the newely created directory as the session working directory for ease of coding

setwd(paste(initWorkDir,dataWorkDir, sep = "/"))

# URL for the required data sets file

dataSetsURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

# Checking if the dataset exists, if not download it

if(!file.exists("household_power_consumption.txt")){
    
    if(!file.exists("dataset.zip")){
        
        # Downloading the data sets file
        
        download.file(url = dataSetsURL, destfile = "dataset.zip")
        
    }
    
}

# Unzipping the downloaded data sets file

unzip(zipfile = "dataset.zip", overwrite = TRUE)

# Importing all the required data sets

hpc_data <- read.table(file = "household_power_consumption.txt", 
                       sep = ";", 
                       header = TRUE,
                       as.is = TRUE)

hpc_data <- hpc_data[hpc_data$Date %in% c("1/2/2007","2/2/2007"),]
    
# Identifying rows with special character "?"

special_rows <- rownames(hpc_data[(hpc_data$Global_active_power == "?" |
                                   hpc_data$Global_reactive_power == "?" |
                                   hpc_data$Voltage == "?" |
                                   hpc_data$Global_intensity == "?" |
                                   hpc_data$Sub_metering_1 == "?" |
                                   hpc_data$Sub_metering_2 == "?" |
                                   hpc_data$Sub_metering_3 == "?"),])

# Replacing character "?" with NA in each column

for(i in special_rows){
    
    hpc_data[i,] = gsub("?",NA,hpc_data[i,], fixed = TRUE)
    
}

# Rassign each column class

hpc_data$Time = strptime(paste(hpc_data$Date, hpc_data$Time), format = "%d/%m/%Y %H:%M:%S")

hpc_data$Date = as.Date(hpc_data$Date, format = "%d/%m/%Y")

classes <- c("date","time", "double","double","double","double","double","double","double")

for(i in colnames(hpc_data[, 3:9])){
    
    class(hpc_data[, i]) = classes[grep(i, colnames(hpc_data))]
    
}

# Resetting the parent directory as the working directory to export the PNG file

setwd(paste(initWorkDir, parentWorkDir, sep = "/"))

# Activating the PNG device to be the current device for plotting

png(filename = "plot2.png",
    width = 480, 
    height = 480, 
    units = "px")

# Creating the required plot

plot(hpc_data$Time,
     hpc_data$Global_active_power, 
     type = "l", 
     ylab = "Global Active Power (kilowatts)", 
     xlab = "")

# Export to and close the PNG device

dev.off()

setwd(initWorkDir)









