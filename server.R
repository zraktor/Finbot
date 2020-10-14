#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(SnowballC)
library(tm)
library(shinyjs)
source("functions/functions.R")




# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
  
  
  
  
  
  shinyjs::hide(id = "feedback")
  shinyjs::hide(id = "Thanks_yes")
  shinyjs::hide(id = "Thanks_no")
  shinyjs::hide(id = "Answer_feedback")
  
  
  
  
  
  # create action button process
  printResults <- eventReactive(input$button, { 
    
    #make input question global variable  
    Input_question <<- input$question
    
    
    
    # 5. Convert the testing question into document term matrix (sparse matrix with 1s and 0s)
    #clean the text
    corpus = VCorpus(VectorSource(Input_question))
    corpus = tm_map(corpus, content_transformer(tolower))
    corpus = tm_map(corpus, removeNumbers)
    corpus = tm_map(corpus, removePunctuation)
    #corpus = tm_map(corpus, removeWords, stopwords())
    corpus = tm_map(corpus, stemDocument)
    corpus = tm_map(corpus, stripWhitespace)
    # convert to DTM
    dtm = DocumentTermMatrix(corpus)
    #convert to dataframe
    data_test = as.data.frame(as.matrix(dtm))
    
    # 6. Merge the testing DTM with training DTM, with testing DTM 1s for all terms and training DTM 0s for all terms
    add_data = dataset[1,]
    add_data[add_data == 1] = 0
    data_pred = cbind(data_test,add_data)
    
    # 7. Predict the answer with the trained SVM model
    p = predict(svmfit, data_pred)
    answer = as.character(p)
    
    
    #create reactive plot of historic questions and answer
    Output_answer <- answer
    new_Q_A <- data.frame(Input_answer= Input_question, Output_answer = Output_answer)
    Q_A <<- rbind(Q_A, new_Q_A)
    output$Q_A <- DT::renderDataTable(Q_A, colnames= c("Question", "Answer"), rownames = FALSE)
    
    #show/hide relevant ui elements  
    shinyjs::show(id = "feedback")
    shinyjs::hide(id = "Thanks_yes")
    shinyjs::hide(id = "Thanks_no")
    shinyjs::hide(id = "Answer_feedback")
    
    #make output answer a global variable
    Output_answer <<- answer
    
    return(answer)
  })
  
  #saves result on input question and output answer if user press no button in repsonses to "was the answer useful?"
  feedback_No <- observeEvent(input$btn_No, {
    
    #clears exsisting dataframe
    feedback <- data.frame()
    
    #captures current time and date
    now <- as.POSIXct(Sys.time())
    
    #pulls in data to updated in sql
    feedback <- data.frame(User_question= Input_question, Returned_answer = Output_answer, time_stamp = now, Useful_answer = "FALSE")
    
    
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
    
    #show/hide relevant ui elements 
    shinyjs::hide(id = "feedback")
    shinyjs::show(id = "Answer_feedback")
    
  })
  
  #saves result on input question and output answer if user press yes button in repsonses to "was the answer useful?"
  feedback_yes <- observeEvent(input$btn_Yes, {
    
    #clears exsisting dataframe
    feedback <- data.frame()
    
    #captures current time and date
    now <- as.POSIXct(Sys.time())
    
    #pulls in data to updated in sql
    feedback <- data.frame(User_question= Input_question, Returned_answer = Output_answer, time_stamp = now, Useful_answer = "TRUE")
    
    
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
    # sqlSave(conn, feedback, tablename = table, append = TRUE, verbose = TRUE, varTypes = c(User_question = "varchar(1000)", Returned_answer = "varchar(1000)", time_stamp="datetime"))
    #dbWriteTable(conn, SQL(table_fb), feedback, overwrite = FALSE, append = TRUE, field.types = c(User_question = "varchar(1000)", Returned_answer = "varchar(1000)", time_stamp="datetime"))
    
    #close sqlcconnection
    #dbDisconnect(conn)
    
    #show/hide relevant ui elements 
    shinyjs::hide(id = "feedback")
    shinyjs::show(id = "Thanks_yes")
    
    
  })
  
  
  #saves result on input question and output answer if user press no button in repsonses to "was the answer useful?"
  answer_feedback_Send <- observeEvent(input$btn_send, {
    
    
    x <<- input$select
    
    #clears exsisting dataframe
    a_feedback <- data.frame()
    
    
    
    #pulls in data to updated in sql
    a_feedback <- data.frame(User_question= Input_question, Returned_answer = Output_answer,  Answer_feedback = x)
    
    
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
    
    #show/hide relevant ui elements 
    shinyjs::hide(id = "Answer_feedback")
    shinyjs::show(id = "Thanks_no")
    
    
  })
  
  
  # render answer text in answer field
  output$answer <- renderText({
    printResults()
  })
  
  
  # render answer text in answer field
  output$svm <- renderText({
    toString(svmfit[1])
  })
  
})


