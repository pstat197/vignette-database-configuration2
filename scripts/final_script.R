install.packages("RMariaDB")
install.packages("DBI")
library(RMariaDB)
library(DBI)
df_day <- read.csv("data/day.csv", header=TRUE)
head(df_day)
df_hour <-read.csv("data/hour.csv", header=TRUE)
head(df_hour)

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

dbReadTable(mydb, "day")

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

# Clause 
# WHERE CLAUSE 
# Over here we are trying to find the instant where the temp is at an exact value. So our output will be the instant
dbGetQuery(mydb, "SELECT instant FROM day where temp = 0.3441670" ) 
dbGetQuery(mydb, "SELECT season FROM day where weekday = 6 LIMIT 5" ) 
dbGetQuery(mydb, "SELECT temp FROM hour where atemp = 0.2879 LIMIT 5" ) 


# ORDER BY
# We are selecting the temps from the day database and ordering the outputs in ascending order of season (1-4). We can also sort the output by descending order (DESC, 4-1).
dbGetQuery(mydb, "SELECT temp FROM day ORDER BY season ASC LIMIT 3" )  
dbGetQuery(mydb, "SELECT temp FROM day ORDER BY season DESC LIMIT 3" )  

#LIMIT
# WE use the limit function to limit our output to a certain number of responses. In this case, we will get the first 5 results which meet the criteria of the query.
dbGetQuery(mydb, "SELECT dteday FROM day where temp > 0 LIMIT 5" )  
dbGetQuery(mydb, "SELECT dteday FROM day where temp > 0 LIMIT 1" )  

#OIN:
# Left Join
# Returns all records from the left table, and the matched records from the right table
dbGetQuery(mydb, 'SELECT day.windspeed, hour.casual FROM day LEFT JOIN hour ON day.season = hour.season LIMIT 5')

# Right Join
# Returns all records from the right table, and the matched records from the left table
dbGetQuery(mydb, 'SELECT day.windspeed, hour.casual FROM day RIGHT JOIN hour ON day.season = hour.season LIMIT 5')


# Inner Join 
# Returns records that have matching values in both tables
dbGetQuery(mydb, 'SELECT day.windspeed, hour.casual FROM day INNER JOIN hour ON day.season = hour.season LIMIT 5')

# Outer Join
# Returns all records when there is a match in either left or right table 
# There is no outter join in my sql, use left right join with union to emulate outer join,
#dbGetQuery(mydb, "SELECT day.windspeed, hour.casual FROM day FULL OUTER JOIN hour ON day.season = hour.season LIMIT 5")
dbGetQuery(mydb, "SELECT day.windspeed, hour.casual FROM day LEFT JOIN hour ON day.season = hour.season UNION 
           SELECT day.windspeed, hour.casual FROM day RIGHT JOIN hour ON day.season = hour.season LIMIT 5")

# UNION 
# operator is used to combine the result-set of two or more SELECT statements.
dbGetQuery(mydb, "SELECT day.cnt FROM day UNION SELECT hour.cnt FROM hour")
dbGetQuery(mydb, "SELECT day.cnt FROM day UNION SELECT temp FROM hour")

# IN 
# The IN operator allows you to specify multiple values in a WHERE clause.
# can't use for int values only string
dbGetQuery(mydb, "SELECT* FROM day WHERE season IN (SELECT season FROM day)")

# LIKE 
# We are finding all the dates which start with a 2 and outputting the season based on it
dbGetQuery(mydb, "SELECT season FROM day WHERE dteday LIKE '%2' LIMIT 4") # end in 2
dbGetQuery(mydb, "SELECT season FROM day WHERE dteday LIKE '2%' LIMIT 4") # start with 2 
dbGetQuery(mydb, "SELECT season FROM day WHERE dteday LIKE '%2%' LIMIT 4") # has 2 in it 
dbGetQuery(mydb, "SELECT season FROM day WHERE dteday LIKE 'a%o' LIMIT 4") # start with a and 1 char in length 


# Between
# The BETWEEN operator selects values within a given range. The values can be numbers, text, or dates.
dbGetQuery(mydb, "SELECT dteday FROM day where temp BETWEEN 0 AND 1 LIMIT 5" )  
dbGetQuery(mydb, "SELECT temp FROM day where atemp BETWEEN 0 AND 1 LIMIT 5" )  

# GROUP BY 
# The GROUP BY statement groups rows that have the same values into summary rows
dbGetQuery(mydb, "SELECT COUNT(season) FROM day GROUP BY dteday ORDER BY COUNT(season) DESC LIMIT 10")

# HAVING 
# The HAVING clause was added to SQL because the WHERE keyword cannot be used with aggregate functions.
dbGetQuery(mydb, "SELECT dteday FROM day GROUP BY dteday HAVING COUNT(temp) > 0.2 LIMIT 5" ) 

# CASE 
dbGetQuery(mydb, "SELECT windspeed, CASE 
            WHEN windspeed < 0.1 THEN 'LOW'
            ELSE NULL
            END AS CHECK_LOWSPEED FROM day")

# DISTINCT 
# The SELECT DISTINCT statement is used to return only distinct (different) values.
dbGetQuery(mydb, "SELECT DISTINCT(dteday) FROM day where temp = 0.3441670" ) 
dbGetQuery(mydb, "SELECT DISTINCT(windspeed) FROM day where temp = 0.1" ) 

#rand()
dbGetQuery(mydb, "SELECT RAND()" )

#round()
dbGetQuery(mydb, "SELECT temp,round(temp,3),windspeed, round(windspeed,
3) FROM day" )

#FLOOR()
dbGetQuery(mydb,"SELECT AVG(windspeed),MIN(windspeed),FLOOR(AVG(windspeed)) AS
Lower_Average FROM day" ) 
dbGetQuery(mydb, "SELECT
AVG(windspeed),MIN(windspeed),FLOOR(MIN(windspeed)) AS Lower_Average
FROM day" )

# CEIL()
dbGetQuery(mydb, "SELECT
AVG(windspeed),MIN(windspeed),CEIL(AVG(windspeed)) AS Lower_Average FROM
day" ) 
dbGetQuery(mydb, "SELECT
AVG(windspeed),MIN(windspeed),CEIL(MIN(windspeed)) AS Lower_Average FROM
day" )

# Truncate(n,d) with positive d
dbGetQuery(mydb, "SELECT atemp, hum,
TRUNCATE(atemp,2), TRUNCATE(hum,1) FROM day" )

# Truncate(n,d) with negative d we want to see atem and hum are truncated
dbGetQuery(mydb,
           "SELECT atemp, hum, TRUNCATE(atemp,-2), TRUNCATE(hum,-1) FROM day" )

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

library(dbplyr)
library(dplyr)
#CONNECT TO DATABASE
con <- dbConnect(RMariaDB::MariaDB(), 
                 user = 'root', 
                 password = 'shiatsing2',
                 host = 'localhost',
                 dbname = 'bikes')

#CONNECT TO TABLE
data_sample<- con %>% tbl("day")


# SELECT differenct columns 
# SELECT 4 cloumns together. In Sql we have to write down the four columns' name seperately. But in dbplyr, we can use : to select a range of columns.
data_sample %>% select(season:holiday)

# We can use filter to subsititude where condition in sql. Here we are showing data that has wind speed greater than 0.4
data_sample %>% filter(windspeed > 0.4)

# We can also do the same SQL group by and aggregation task by uing dbplyr group_by function

data_sample %>% group_by(weekday) %>%
  summarise(
    count_day = count(instant)
  )


