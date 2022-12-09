# vignette-database-configuration
Vignette on configuring a database and writing queries in R; created as a class project for PSTAT197A in Fall 2022.
    
## Contributors
Jennifer Park, Russell(Senyuan) Liu, Haotian Xia, Haoming Deng, Ankur Malik.

## Abstract
In this report, we explore how to configure a dataset and write queries in R. Specifically, we first configure the database, build the database, including steps such as Import Libraries, Connect R/Python to MySQL, Create a new database in R/Python, Connect to the Database,Create table and Insert data/table into database. We then write queries by introducing some common functions, tables, syntax and filtering clause. Besides, we created a document which explains how to setup MySQL and the corresponding environment steps by steps.

## Repository contents
1root directory

1.1 data

1.1.1 raw

1.1.2 processed

1.2 scripts

1.2.1 final_script.R

1.2.2 drafts : with different draft made by different people

1.3 img

1.3.1 fig1.png
 
1.3.2 fig2.png

1.4 vignette.qmd

1.5 vignette.html
|-- README.md

## Reference list
1.MySQL Installation Guide: https://dev.mysql.com/doc/mysql-installation-excerpt/5.7/en/

2.MySQL Server Configuration Guide: https://www.youtube.com/watch?v=nj3nBCwZaqI

3.MySQL Workbench Installation Guide: https://www.youtube.com/watch?v=6FvvWhiZyDY

4.Colburn, Rafe. Special Edition Using SQL. Que, 2000.

5.Röhm, Uwe, et al. "SQL for Data Scientists: Designing SQL Tutorials for Scalable Online Teaching." Proceedings of the VLDB Endowment, vol. 13, no. 12, 2020, pp. 2989–92, https://doi.org/10.14778/3415478.3415526.

6.Guo, Aibo, et al. "ER-SQL: Learning Enhanced Representation for Text-to-SQL Using Table Contents." Neurocomputing (Amsterdam), vol. 465, 2021, pp. 359–70, https://doi.org/10.1016/j.neucom.2021.08.134.

7.Guo, Aibo, et al. "ER-SQL: Learning Enhanced Representation for Text-to-SQL Using Table Contents." Neurocomputing (Amsterdam), vol. 465, 2021, pp. 359–70, https://doi.org/10.1016/j.neucom.2021.08.134.

8.Reese, George., et al. Managing and Using MySQL. 2nd ed., O'Reilly, 2002.

9.https://rmariadb.r-dbi.org/reference/dbconnect-mariadbdriver-method

10.https://archive.ics.uci.edu/ml/datasets/Bike+Sharing+Dataset

