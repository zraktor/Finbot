library(tidyverse)


server <- shinyServer( function(input, output, session) {
  
  
  output$chatbox <- renderText({
    df_text <<- c()
    for (row in 1:nrow(chat)) {
      name <- chat[row, "user"]
      message  <- chat[row, "text"]
      time  <- chat[row, "time"]
      df_text[row] <- paste("<b>", time, " : ",name, " : ", message, "<br>")
    }  
    df_text
  })
  
  observeEvent(input$send, {
    new_message <- list(user = "You",
                        text = input$message_field,
                        time = toString(format(Sys.time(), "%X")))
    chat <<- rbind(chat, new_message)
    
    chatbot(input$message_field)
    
    
    
    updateTextInput(session, "message_field", value = "")
    update_chat()
  })
  
  update_chat <-function(){
    output$chatbox <- renderText({
      df_text <<- c()
      for (row in 1:nrow(chat)) {
        name <- chat[row, "user"]
        message  <- chat[row, "text"]
        time  <- chat[row, "time"]
        df_text[row] <- paste("<b>", time, " : ",name, " : ", message, "<br>")
      }  
      df_text
    })
  }
  
  chatbot <- function(input_message){
    chatbot_check_restart(input_message)
    
    
    if (conversation_state == 1) {
      
      chatbot_greeting(input_message)
    }
    
    else if (conversation_state == 2) {
      
      chatbot_answer_type(input_message)
      
    }
    
    else if (conversation_state == 3) {
      
      chatbot_finbot_answer(input_message)
    }
    
    
    else if (conversation_state == 4) {
      
      chatbot_finbot_answer_feedback(input_message)
    }
    else if (conversation_state == 5) {
      
      chatbot_ask_another_question(input_message)
    }
    
    
    else {
      response <- "I have encountered an issue and will restart the conversation"
      chatbot_response(response)
      conversation_state <- 1
    }
  }
  
  
  chatbot_greeting <- function(input_message){
    
    restart <- c("restart", "Restart")
    
    Greetings <- c('Hi','Hello','Good morning','Good afternoon')
    
    if (input_message %in% Greetings){
      
      response <- "Please can I start by asking if you're questions relate to ESFA or DFE" 
      conversation_state <<- 2
      chatbot_response(response)
    }
    else if (input_message %in% restart){
      
      
      
    }
    else {
      response <- "I don't understand" 
      chatbot_response(response)
    }
    
  }
  
  chatbot_answer_type <- function(input_message){
    
    
    
    Esfa <- c('Esfa','ESFA')
    dfe <- c("dfe", "DFE")
    
    
    if (input_message %in% Esfa){
      
      response <- "You have selected ESFA, if this is incorrect or you have changed your mind please type of message says simple restart" 
      conversation_state <<- 3
      answer_type <<- "esfa"
      chatbot_response(response)
      chatbot_ask_question()
      
      
    }
    else if (input_message %in% dfe){
      
      
      response <- "You have selected DFE, if this is incorrect or you have changed your mind please type of message says simple restart" 
      conversation_state <<- 3
      answer_type <<- "dfe"
      chatbot_response(response)
      chatbot_ask_question()
      
    }
    
    else {
      
      response <- "I don't understand" 
      chatbot_response(response)
      
      }
  }
  
  
  
  chatbot_finbot_answer_feedback <- function(input_message){
    
    
    
    yes <- c('yes','y', "YES", "Yes")
    no <- c("N", "No", "no", "NO")
    
    
    if (input_message %in% yes){
      
      response <- "Thank you for your positive feedback" 
      chatbot_response(response)
      response <- "Do you want to ask another question?" 
      chatbot_response(response)
      conversation_state <<- 5
      
    }
    
    else if (input_message %in% no){
      
      response <- "I'am sorry I was not helpful." 
      chatbot_response(response)
      response <- "Do you want to ask another question?" 
      chatbot_response(response)
      conversation_state <<- 5
      
    }
    
    else {
      
      response <- "I don't understand" 
      chatbot_response(response)
    }
    
  }
  
  
  
  chatbot_ask_another_question <- function(input_message){
    
    yes <- c('yes','y', "YES", "Yes")
    no <- c("N", "No", "no", "NO")
    
    
    if (input_message %in% yes){
      
      chatbot_ask_question()
      conversation_state <<- 3
      
    }
    else if (input_message %in% no){
      
      response <- "Good Bye" 
      chatbot_response(response)
      
    }
    
    else {
      
      response <- "I don't understand" 
      chatbot_response(response)
    }
  }
  
  chatbot_finbot_answer <- function(input_message){
    
    
    response <- "I have just run the finbot code and here is your answer" 
    chatbot_response(response)
    response <- "Was this answer useful?" 
    chatbot_response(response)
    conversation_state <<- 4
    
  }
  
  chatbot_ask_question <- function(){
    
      
    response <- "What is your question?" 
    chatbot_response(response)
    
}
  
  chatbot_response <- function(message){
    
    new_message <- list(user = "Chatbot",
                        text = message,
                        time = (toString(format(Sys.time(), "%X"))))
    
    chat <<- rbind(chat, new_message)
    
  }
  
  
  chatbot_check_restart <- function(input_message){
    
    restart <- c("restart", "Restart")
    
    if (input_message %in% restart){
    conversation_state <<- 1
    response <- "restarting coverstation"
    chatbot_response(response)
    }
    
    
  }
  
})
