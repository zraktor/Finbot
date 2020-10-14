
# import libraries 
library(odbc)
library(DBI)
library(SnowballC)
library(tm)
library(e1071)
#library(config)
#library(yaml)

# Chatbot for answering Finance FAQs


# Methdology
# 1. Convert training questions into document term matrix (sparse matrix with 1s and 0s)
# 2. Match the matrix of each training question with its corresponding answer to form a training matrix
# 3. Train SVM model with the training matrix
# 4. Propose a testing quesiton
# 5. Convert the testing question into document term matrix (sparse matrix with 1s and 0s)
# 6. Merge the testing DTM with training DTM, with testing DTM 1s for all terms and training DTM 0s for all terms
# 7. Predict the answer with the trained SVM model



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



data <- read.csv(file = 'data/faq.csv')


#read in FAQ data

data <- read.csv(file = 'data/faq.csv')

# 1. Convert training questions into document term matrix (sparse matrix with 1s and 0s)
#clean the text

corpus = VCorpus(VectorSource(data$Question))
corpus = tm_map(corpus, content_transformer(tolower))
corpus = tm_map(corpus, removeNumbers)
corpus = tm_map(corpus, removePunctuation)

# unused line below
# corpus = tm_map(corpus, removeWords, stopwords())

corpus = tm_map(corpus, stemDocument)
corpus = tm_map(corpus, stripWhitespace)

# convert to DTM

dtm = DocumentTermMatrix(corpus)

# convert to dataframe

dataset = as.data.frame(as.matrix(dtm))

# 2. Match the matrix of each training question with its corresponding answer to form a training matrix

data_train = cbind(data['Answer'], dataset)



# 3. Train SVM model with the training matrix

svmfit <- readRDS(file = "models/FinbotSVM.rds")



mylist <- c("Answer is unclear", "Answer is not relevant", "Answer has broken a URL", "Answer is not displayed", "Other")

#intialse dataframe
Q_A <- data.frame(Input_question=character(),
                  Output_answer=character())


