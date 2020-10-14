###### script to train SVM model and output to models folder


# import libraries 

library(SnowballC)
library(tm)
library(e1071)





# Methodology
# 1. Convert training questions into document term matrix (sparse matrix with 1s and 0s)
# 2. Match the matrix of each training question with its corresponding answer to form a training matrix
# 3. Train SVM model with the training matrix




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

# 3. train SVM model

svmfit = svm(factor(Answer) ~., data_train, kernel = "linear", cost = 100, scale = FALSE)

#save model as RDS file

saveRDS(svmfit, "models/FinbotSVM.rds")