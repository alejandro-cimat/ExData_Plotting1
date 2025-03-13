# Loading specific data -----------------------------------------------------------------------------------
my_file <- file("household_power_consumption.txt", "r")

# Reading column names
df <- data.frame(matrix(ncol=9, nrow=0)) 
header <- unlist( strsplit( readLines(my_file, 1), ';' ) )
colnames(df) <- header

# Reading specific lines
while (TRUE)
{
    line <- readLines(my_file, 1)
    
    if ( length(line) == 0 ) break
    else if (grepl("^[1-2]/2/2007", line))
        df[nrow(df)+1,] <- unlist( strsplit(line, ';') )
}
close(my_file)

# Removing NA
df[df == "?"] <- NA
df <- df[complete.cases(df), ]

# Date values
df$Date <- as.Date(df$Date[1], format = "%d/%m/%Y")

# Numeric values
for (i in 3:ncol(df))
    df[,i] <- as.numeric(df[,i]) 

# Plot 3 -----------------------------------------------------------------------------------
plot(df$Sub_metering_1, type="l", col="black", xlab="", ylab = "Energy sub metering", xaxt="n")
lines(df$Sub_metering_2, type="l", col="red")
lines(df$Sub_metering_3, type="l", col="blue")
axis(1, at=c(1,1440,2880), labels=c("Thu", "Fri", "Sat"))
legend("topright", legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lty=c(1,1,1), col=c("black", "red", "blue"))
dev.copy(png, "plot3.png")
dev.off()
