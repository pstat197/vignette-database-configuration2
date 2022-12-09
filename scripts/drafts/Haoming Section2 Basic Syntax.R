# Haoming
# Install and load the package
#install.packages("DBI")
#install.packages("RMySQL")
library(RMariaDB)
library(DBI)


## Prepare the CSV file

# sample data downloaded from https://archive.ics.uci.edu/ml/datasets/Bike+Sharing+Dataset
# two files:
# hour.csv : bike sharing counts aggregated on hourly basis. Records: 17379 hours
# day.csv : bike sharing counts aggregated on daily basis. Records: 731 days
# stored under 'data' folder, along with a Readme with the data description.

## Import csv files as data frames
df_day <- read.csv("data/day.csv", header=TRUE)
head(df_day)


## Create a database
# connect R to MySQL by creating a MySQL connection object
con <- dbConnect(RMariaDB::MariaDB(), 
                 user = 'root', 
                 password = '200255200255',
                 host = 'localhost')

# create a new database
dbSendQuery(con, "CREATE DATABASE bikes")
dbSendQuery(con, "USE bikes")

# reconnect to the database that we just created
mydb <- dbConnect(RMariaDB::MariaDB(), 
                  user = 'root', 
                  password = '200255200255',
                  host = 'localhost',
                  dbname = 'bikes')

# Write the data frames to database tables
dbWriteTable(conn = mydb,
             name = "day",
             value = df_day)

dbWriteTable(conn = mydb,
             name = "hour",
             value = df_hour)

# list the tables available in bikes
dbListTables(mydb)

# list the fields in a table
dbListFields(con, "day")
dbListFields(con, 'hour')

# view the whole table
dbReadTable(con, "day")
dbReadTable(con, 'hour')

# Basic Syntax
# SELECT
# we want to select day.season and day.yr from day. we can also select other columns from the table.
dbGetQuery(mydb, 'SELECT day.season, day.yr FROM day')

# INSERT
# we want to insert new values 1 and 0 into day.season and day.yr
dbGetQuery(mydb, 'INSERT INTO day(day.season, day.yr)
                  VALUES (1,0)')


# UPDATE 
# we want to update weekday to 9 where workingday equals to 0 in day. we can also use multiple conditions in the WHERE clause.
dbGetQuery(mydb, 'UPDATE day
                  SET weekday=8
                  WHERE workingday=0')

# DELETE
# we want to delete values from day where workingday equals to 0. we can also set other conditions when we want to delete values from the table.
dbGetQuery(mydb, 'DELETE FROM day
                  WHERE workingday=0')