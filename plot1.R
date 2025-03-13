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

# Plot 1 -----------------------------------------------------------------------------------
hist(df$Global_active_power, main = "Global Active Power", xlab = "Global Active Power (kilowatts)", col = "red")
dev.copy(png, "plot1.png")
dev.off()
