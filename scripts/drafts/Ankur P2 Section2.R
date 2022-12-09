# Ankur 
install.packages("RMariaDB")
install.packages("DBI")
library(RMariaDB)
library(DBI)

df_day <- read.csv("data/day.csv", header=TRUE)
head(df_day)

df_hour <-read.csv("data/hour.csv", header=TRUE)
head(df_hour)

install.packages("RMySQL")
## Create a database
# connect R to MySQL by creating a MySQL connection object
con <- dbConnect(RMariaDB::MariaDB(), 
                 user = 'root', 
                 password = 'password',
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
dbListFields(con, "day")
dbListFields(con, 'hour')

# view the whole table
dbReadTable(con, "day")
dbReadTable(mydb, 'hour')
dbReadTable(mydb, 'day')
------------------------------------------------
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
dbGetQuery(mydb, "SELECT DISTINCT(windspeed) FROM day where temp = 0.1" ) # DNE