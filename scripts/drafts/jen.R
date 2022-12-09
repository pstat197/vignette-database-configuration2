### PRELIMINARY STEPS ###

## 1. Install MySQL Server on Macbook M1/M2

## 2. Install and load the packages
install.packages("RMariaDB")
install.packages("DBI")
library(RMariaDB)
library(DBI)

## 3. Prepare the data
# Sample data downloaded from https://archive.ics.uci.edu/ml/datasets/Bike+Sharing+Dataset
# The 'data' directory contains two csv files and a Readme with the data description.
  # hour.csv : bike sharing counts aggregated on hourly basis. Records: 17379 hours
  # day.csv : bike sharing counts aggregated on daily basis. Records: 731 days

# Import csv files as data frames
df_day <- read.csv("data/day.csv", header=TRUE)
head(df_day)

df_hour <-read.csv("data/hour.csv", header=TRUE)
head(df_hour)

### BUILD THE DATABASE ###
# connect R to MySQL by creating a MySQL connection object
# select which MySQL account to use for the database
 # user - your account username. Here we use the default, 'root'.
 # password - your account password
 # host - a string identifying the host machine that is running server. Here we use the default, 'localhost'.
# Reference: https://rmariadb.r-dbi.org/reference/dbconnect-mariadbdriver-method
con <- dbConnect(RMariaDB::MariaDB(), 
                 user = 'root', 
                 password = 'password', # YOUR PASSWORD HERE
                 host = 'localhost')

# create a new database
dbSendQuery(con, "CREATE DATABASE bikes")
dbSendQuery(con, "USE bikes")

# reconnect to the database that we just created
mydb <- dbConnect(RMariaDB::MariaDB(), 
                 user = 'root', 
                 password = 'password',
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
dbListFields(mydb, "day")

# view the whole table
dbReadTable(mydb, "day")

