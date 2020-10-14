####  global.r this is where code that needs to run on start lives
####

library(readxl)


chat <- data.frame(user=character(),
                 text=character(), 
                 time=numeric() 
                ) 



intial_message <- list(user = "Chatbot",
                    text = "Hi, I am Finbot pleased to meet you.",
                    time = format(Sys.time(), "%X"))



chat <<- rbind(chat, intial_message)
conversation_state = 1

