

# import libraries 
library(SnowballC)
library(tm)
library(e1071)

# Methodology
# 4. Propose a testing question
# 5. Convert the testing question into document term matrix (sparse matrix with 1s and 0s)
# 6. Merge the testing DTM with training DTM, with testing DTM 1s for all terms and training DTM 0s for all terms
# 7. Predict the answer with the trained SVM model




find_answer <- function(Input_question, SVM_model, data_train){
  
  
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
  add_data = data_train[1,]
  add_data[add_data == 1] = 0
  data_pred = cbind(data_test,add_data)

  # 7. Predict the answer with the trained SVM model
  p = predict(svmfit, data_pred)
  answer = as.character(p)


  #create reactive plot of historic questions and answer
  Output_answer <- answer
  
  
  return(Output_answer)


  
  
}


