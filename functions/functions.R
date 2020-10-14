# import libraries 
library(config)
library(yaml)
library(odbc)
library(DBI)


#set table
table_fb <- "FinancialReturns.FR006_Finance_Feedback"


savetosql <- function(table){
  
  
  conn <-dbConnect(odbc::odbc(),
  Driver = conf$driver,
  Server = conf$server,
  Database = conf$database,
  UID = conf$uid,
  PWD = conf$pwd,
  Trusted_Connection = conf$trusted)
  
  
  #set table
  table_fb <- "FinancialReturns.FR006_Finance_Feedback"
  
  #append feedback to sql table 
  dbWriteTable(conn, SQL(table_fb), feedback, overwrite = FALSE, append = TRUE, field.types = c(User_question = "varchar(1000)", Returned_answer = "varchar(1000)", time_stamp="datetime"))
  
  #close sql connection
  dbDisconnect(conn)
  
  
}

#conn <-dbConnect(odbc::odbc(),
#Driver = conf$driver,
#Server = conf$server,
#Database = conf$database,
#UID = conf$uid,
#PWD = conf$pwd,
#Trusted_Connection = conf$trusted)



#set table
#table_fb <- "FinancialReturns.FR006_Finance_Feedback_2"

#append feedback to sql table 
#dbWriteTable(conn, SQL(table_fb), a_feedback, overwrite = FALSE, append = TRUE, field.types = c(User_question = "varchar(1000)", Returned_answer = "varchar(1000)", Answer_feedback="varchar(50)"))

#close sqlcconnection
#dbDisconnect(conn)



#conn <-dbConnect(odbc::odbc(),
#Driver = conf$driver,
#Server = conf$server,
#Database = conf$database,
#UID = conf$uid,
#PWD = conf$pwd,
#Trusted_Connection = conf$trusted)



#set table
#table_fb <- "FinancialReturns.FR006_Finance_Feedback"

#append feedback to sql table 
#dbWriteTable(conn, SQL(table_fb), feedback, overwrite = FALSE, append = TRUE, field.types = c(User_question = "varchar(1000)", Returned_answer = "varchar(1000)", time_stamp="datetime"))

#close sqlcconnection
#dbDisconnect(conn)

