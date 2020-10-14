# import libraries 

library(SnowballC)
library(tm)
library(e1071)



# Chat bot for answering Finance FAQs

#read in FAQ data
data <- read.csv(file = 'data/faq.csv')

#Convert training questions into document term matrix (sparse matrix with 1s and 0s)

#clean the text
corpus = VCorpus(VectorSource(data$Question))
corpus = tm_map(corpus, content_transformer(tolower))
corpus = tm_map(corpus, removeNumbers)
corpus = tm_map(corpus, removePunctuation)
corpus = tm_map(corpus, stemDocument)
corpus = tm_map(corpus, stripWhitespace)

# convert to DTM
dtm = DocumentTermMatrix(corpus)

# convert to data frame
dataset = as.data.frame(as.matrix(dtm))



# Train SVM model with the training matrix

svmfit <- readRDS(file = "models/FinbotSVM.rds")


#list of feedback responses
feedback_choices <- c("Answer is unclear", "Answer is not relevant", "Answer has broken a URL", "Answer is not displayed", "Other")















#################
#### currently unused code 
##################
#library(odbc)
#library(DBI)
#library(config)
#library(yaml)

#read config file and start sql connection
#conf <- config::get("FINBOT_DB")



#conn <-dbConnect(odbc::odbc(),
#Driver = conf$driver,
#Server = conf$server,
#Database = conf$database,
#UID = conf$uid,
#PWD = conf$pwd,
#Trusted_Connection = conf$trusted)
#set table
#table <- "FinancialReturns.FR006_Finance_FAQ"

#fetch data from sql
#data<-dbReadTable(conn, SQL(table))


#close sqlcconnection
#dbDisconnect(conn)

