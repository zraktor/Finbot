# import libraries 
library(config)
library(yaml)
library(odbc)
library(DBI)


#set table
table_fb <- "FinancialReturns.FR006_Finance_Feedback"

#fields
fields <- c(User_question = "varchar(1000)", Returned_answer = "varchar(1000)", time_stamp="datetime")


savetosql <- function(table, input_dataframe, fields){
  
  
  conn <-dbConnect(odbc::odbc(),
  Driver = conf$driver,
  Server = conf$server,
  Database = conf$database,
  UID = conf$uid,
  PWD = conf$pwd,
  Trusted_Connection = conf$trusted)
  
  

  
  #append feedback to sql table 
  dbWriteTable(conn, SQL(table), input_dataframe, overwrite = FALSE, append = TRUE, field.types = fields)
  
  #close sql connection
  dbDisconnect(conn)
  
  
}


# unused sql save format 
#savetosql(table = table, input_dataframe = feedback, fields = c(User_question = "varchar(1000)", Returned_answer = "varchar(1000)", time_stamp="datetime"))



