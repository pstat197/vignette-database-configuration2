
library(RMariaDB)
library(DBI)
df_day <- read.csv("data/day.csv", header=TRUE)
head(df_day)

df_hour <-read.csv("data/hour.csv", header=TRUE)
head(df_hour)



# list the tables available in bikes
dbListTables(mydb)


dbReadTable(mydb, 'hour')
dbReadTable(mydb, 'day')

# Count ALL: How many row we have

dbGetQuery(mydb, "SELECT COUNT(*) FROM day" )

# Count Distinct weekday 

dbGetQuery(mydb, "SELECT COUNT(DISTINCT (weekday)) FROM day" )

# we want to see the average windspeed among all data

dbGetQuery(mydb, "SELECT AVG(windspeed) AS AVERAGE_SPEED FROM day" )

# we want to see the sum of casual users
dbGetQuery(mydb, "SELECT SUM(casual) AS TOTAL_NUM_CASUAL_USER FROM day")

# we want to see the max speed of wind
dbGetQuery(mydb, "SELECT MAX(windspeed) AS MAX_WINDSPEED FROM day")

# we want to see the min speed of wind
dbGetQuery(mydb, "SELECT MIN(windspeed) AS MIN_WINDSPEED FROM day")

# We want to concat days and hours as one column

dbGetQuery(mydb, "SELECT CONCAT(dteday,' Hour: ',hr) FROM hour")

# We want to see how many characters composes the date
dbGetQuery(mydb, "SELECT DISTINCT(LENGTH(dteday)) AS length_of_char_date FROM hour")

#WE want to firstly create windspeed breakdown to two part low and high. Then we want to 
# show how to use lower function to make all spring be lower case
dbGetQuery(mydb, "SELECT LOWER(SPEED_BREAKDOWN) FROM (SELECT windspeed, CASE 
            WHEN windspeed < 0.1 THEN 'LOW'
            ELSE 'HIGH'
            END AS SPEED_BREAKDOWN FROM day) AS tmp")

#  We want to show how to use upper function to make all spring be upper case
dbGetQuery(mydb, "SELECT UPPER(SPEED_BREAKDOWN) FROM (SELECT windspeed, CASE 
            WHEN windspeed < 0.1 THEN 'low'
            ELSE 'high'
            END AS SPEED_BREAKDOWN FROM day) AS tmp")

# average wind speed for each week day
