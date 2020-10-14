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
#source("functions/sqlfunctions.R")
source("functions/svmfunctions.R")




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
    
    
    Output_answer <<- find_answer(Input_question, svmfit, dataset)
    
    #show/hide relevant ui elements  
    shinyjs::show(id = "feedback")
    shinyjs::hide(id = "Thanks_yes")
    shinyjs::hide(id = "Thanks_no")
    shinyjs::hide(id = "Answer_feedback")
    

    
    return(Output_answer)
  })
  
  #saves result on input question and output answer if user press no button in repsonses to "was the answer useful?"
  feedback_No <- observeEvent(input$btn_No, {
    
    #clears exsisting dataframe
    feedback <- data.frame()
    
    #captures current time and date
    now <- as.POSIXct(Sys.time())
    
    table <- "FinancialReturns.FR006_Finance_Feedback"
    
    #pulls in data to updated in sql
    feedback <- data.frame(User_question= Input_question, Returned_answer = Output_answer, time_stamp = now, Useful_answer = "FALSE")
    
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
    
    #set table
    table <- "FinancialReturns.FR006_Finance_Feedback"
    
    #pulls in data to updated in sql
    feedback <- data.frame(User_question= Input_question, Returned_answer = Output_answer, time_stamp = now, Useful_answer = "TRUE")
    
    #show/hide relevant ui elements 
    shinyjs::hide(id = "feedback")
    shinyjs::show(id = "Thanks_yes")
    
    
  })
  
  #saves result on input question and output answer if user press no button in repsonses to "was the answer useful?"
  answer_feedback_Send <- observeEvent(input$btn_send, {
    
    selected_feedback <- input$select
    
    #clears existing dataframe
    a_feedback <- data.frame()
    
    #set table
    table <- "FinancialReturns.FR006_Finance_Feedback_2"
    
    #pulls in data to updated in sql
    a_feedback <- data.frame(User_question= Input_question, Returned_answer = Output_answer,  Answer_feedback = selected_feedback)
    
    #show/hide relevant ui elements 
    shinyjs::hide(id = "Answer_feedback")
    shinyjs::show(id = "Thanks_no")
    
    
  })
  
  
  # render answer text in answer field
  output$answer <- renderText({
    printResults()
  })
  
  
})


