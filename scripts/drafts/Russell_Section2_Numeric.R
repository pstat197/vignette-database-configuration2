library(RMariaDB)
library(DBI)



df_day <- read.csv("data/day.csv", header=TRUE)
head(df_day)

df_hour <-read.csv("data/hour.csv", header=TRUE)
head(df_hour)

# create a new database
dbSendQuery(con, "CREATE DATABASE bikes")
dbSendQuery(con, "USE bikes")


# Write the data frames to database tables
dbWriteTable(conn = mydb,
             name = "day",
             value = df_day)

dbWriteTable(conn = mydb,
             name = "hour",
             value = df_hour)

# list the tables available in bikes
dbListTables(mydb)


#Numeric 

#rand()
dbGetQuery(mydb, "SELECT RAND()" )

#round()
#We want to round up temperature and windspeed to 3 decimals 
dbGetQuery(mydb, "SELECT temp,round(temp,3),windspeed, round(windspeed, 3) FROM day" )

#FLOOR()
#we want to see the largest integer value which is either equal to or less than the given average or minimum windspeed.
dbGetQuery(mydb, "SELECT AVG(windspeed),MIN(windspeed),FLOOR(AVG(windspeed)) AS Lower_Average FROM day" )
dbGetQuery(mydb, "SELECT AVG(windspeed),MIN(windspeed),FLOOR(MIN(windspeed)) AS Lower_Average FROM day" )

#Ceil()
#we want to see the smallest integer value which is either greater than or equal to the given  average or minimum number.
dbGetQuery(mydb, "SELECT AVG(windspeed),MIN(windspeed),CEIL(AVG(windspeed)) AS Lower_Average FROM day" )
dbGetQuery(mydb, "SELECT AVG(windspeed),MIN(windspeed),CEIL(MIN(windspeed)) AS Lower_Average FROM day" )

#Truncate(n,d) with positive d
#we want to see atemp keeps 2 decimals and hum only keeps 1 decimals 
dbGetQuery(mydb, "SELECT atemp, hum, TRUNCATE(atemp,2), TRUNCATE(hum,1) FROM day" )

#Truncate(n,d) with negative d
#we want to see atem and hum are truncated two or one digit left to the decimal points.
dbGetQuery(mydb, "SELECT atemp, hum, TRUNCATE(atemp,-2), TRUNCATE(hum,-1) FROM day" )

dbGetQuery(mydb, "SELECT * FROM hour" )
