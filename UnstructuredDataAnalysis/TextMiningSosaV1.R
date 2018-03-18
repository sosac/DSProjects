##################################
### DS 745: Week 15: Project 3:  
### Text Mining: Topic Modeling
###
### Connie Sosa 
### April 27, 2017
###
##################################

cname <- "c:/Users/connie/UW/DS745/week15/project3"
setwd(cname)
library(XML)

### Read the movies dataset (in csv format)
movieSet = read.csv("movies10000.csv", header = TRUE, sep = ",", quote = "\"")
movieSet.m  <- as.matrix(movieSet)
dim(movieSet.m)
colnames(movieSet.m) <- c("id", "title", "release_date", "box_office_revenue", 
                          "runtime", "genres", "summary")

###########################
### process genres
allGenres <- movieSet.m[, "genres"]
allGenres <- gsub("\\[", "", allGenres)
allGenres <- gsub("\\]", "", allGenres)
allGenres.l <- strsplit(allGenres, split=',') ### split by comma
allGenres.unlist <- unlist(allGenres.l)
allGenres.unlist2 <- gsub("\\\"", "", allGenres.unlist) ### remove quote
allGenres.unlist3 <- gsub("^ ", "", allGenres.unlist2) ### remove leading space

head(allGenres.unlist3)
# [1] "Space western"   "Horror"          "Supernatural"    "Thriller"       
# [5] "Science Fiction" "Action"  

###########################
### create contingency table: count each genres
allGenres.freqs.t <- table(allGenres.unlist3) 
### sort it in descending order
allGenres.freqs2.t <- allGenres.freqs.t[order(allGenres.freqs.t, decreasing = TRUE)] 
### get the top 10 genres
popular.genres <- allGenres.freqs2.t[1:10] 
popular.genres
# allGenres.unlist3
#        Drama          Comedy    Romance Film        Thriller          Action 
#         4592            2467            1624            1580            1345 
# World cinema   Crime Fiction          Horror           Indie Black-and-white 
#         1214            1049             963             906             896 

### Produce Figure 4A ###########
plot(popular.genres, ylab="frequeny count", xlab="genres", main="Top Movie Genres")

### plot all genres, it exhibits zipf's law
### Produce Figure 4B ###########
plot(allGenres.freqs2.t) 

########################### 
### Get the most popular genres
popular.genres.df <- as.data.frame(popular.genres, stringsAsFactors=FALSE)
colnames(popular.genres.df) <- c("genres", "freq")

### Produce Figure 3 ###########
popular.genres.df
#             genres freq
# 1            Drama 4592
# 2           Comedy 2467
# 3     Romance Film 1624
# 4         Thriller 1580
# 5           Action 1345
# 6     World cinema 1214
# 7    Crime Fiction 1049
# 8           Horror  963
# 9            Indie  906
# 10 Black-and-white  896

popular1gen <- popular.genres.df$genres[1]
popular2gen <- popular.genres.df$genres[2]
popular3gen <- popular.genres.df$genres[3]
popular1gen; popular2gen; popular3gen

### Ddentify top genres positions in the vector using grep:
### get the index positions of the most popular genre:
index.popular1.v <- grep(popular1gen, movieSet.m[, "genres"])
index.popular1.v
# > index.popular1.v
#  [1]    3    5    6    9   13   16   17   19   24   26   28   31   36   39   43   44
# [17]   45   46   48   49   50   51   53   61   62   63   64   66   67   69   71   72
# [33]   73   77   78   79   82   83   84   85   86   89   90   94   95   96   97  100
# ...

### get the movie summary description for the most popular genre: 
popular1summary <- movieSet.m[index.popular1.v, "summary"]

### Produce Figure 2C ###########
popular1summary[2]

############
### Topic modeling for the top genre:
### Load library
library(tm) ### text mining library
library(topicmodels) ### topic models library
library(RWeka) ### collection of machine learning algorithms
library(SnowballC) ### R interface to the C libstemmer library that implements Porter's word stemming
### algorithm for collapsing words to a common root to aid comparison of vocabulary.

#########################
### Create text corpus
docs1 <- Corpus(VectorSource(popular1summary))
summary(docs1)
inspect(docs1[2]) ### inspect the 2nd movie in the most popular genres

#########################
### pre-processing:
docs1 <- tm_map(docs1, removePunctuation)
docs1 <- tm_map(docs1, content_transformer(tolower))
docs1 <- tm_map(docs1, removeNumbers)
docs1 <- tm_map(docs1, removeWords, c(stopwords("english"), stopwords("SMART"), "film")) 
docs1 <- tm_map(docs1, stripWhitespace)
docs1 <- tm_map(docs1, stemDocument) ### stem the document
docs1
# <<SimpleCorpus>>
# Metadata:  corpus specific: 1, document level (indexed): 0
# Content:  documents: 4622

#########################
### Create Document Term Matrix
dtm1 <- DocumentTermMatrix(docs1)
dtm1
# <<DocumentTermMatrix (documents: 4622, terms: 35946)>>
#   Non-/sparse entries: 448125/165694287
# Sparsity           : 100%
# Maximal term length: 139
# Weighting          : term frequency (tf)

inspect(dtm1)[1:10, 1:10]

### collapse matrix by summing over columns
freq1 <- colSums(as.matrix(dtm1)) 

### length should be the total number of terms
length(freq1) 
# [1] 35685

### create sort order (descending)
ord1 <- order(freq1, decreasing=TRUE) 

### List all terms in decreasing order of freq and write to file
write.csv(freq1[ord1], "word_freq1.csv") 

#########################
### Set parameters for Gibbs sampling
burnin <- 1000
iter <- 1000
thin <- 100
seed <- list(1,1,1,1,1)
nstart <- 5
best <- TRUE
k <- 3 ### Number of topics

#########################
### Run the topic modeling algorithm on our corpus 
### Run LDA using Gibbs sampling
ldaOut1 <- LDA(dtm1, k, method="Gibbs", control=list(nstart = nstart, 
                                                     seed = seed,
                                                     best = best, 
                                                     burnin = burnin,
                                                     iter = iter, 
                                                     thin = thin))

ldaOut1 ### took few minutes to runs 

### top 3 topics found from LDA
ldaOut1.topics <- as.matrix(topics(ldaOut1)) 
write.csv(ldaOut1.topics, file=paste("LDAGibbs", k, "DocsToTopics1.csv", sep=""))

### top 10 terms in each topic
ldaOut1.terms <- as.matrix(terms(ldaOut1, 10)) 
write.csv(ldaOut1.topics, file=paste("LDAGibbs", k, "DocsToTopics1.csv", sep=""))

### top ten words for each topic
### Produce Figure 5A ###########
ldaOut1.terms 
#      Topic 1 Topic 2    Topic 3 
# [1,] "tell"  "love"     "kill"  
# [2,] "leav"  "father"   "order" 
# [3,] "find"  "famili"   "forc"  
# [4,] "polic" "life"     "war"   
# [5,] "back"  "mother"   "group" 
# [6,] "kill"  "marri"    "return"
# [7,] "home"  "live"     "men"   
# [8,] "night" "friend"   "escap" 
# [9,] "call"  "son"      "world" 
# [10,] "money" "daughter" "discov"

topicProbabilities1 <- as.data.frame(ldaOut1@gamma) ### probabilities associated with each topic assignment
write.csv(topicProbabilities1, file=paste("LDAGibbs",k,"DocsToTopics1.csv", sep="")) 

######################
### function:
######################
topicmodels_json_ldavis <- function(fitted, corpus, doc_term) {
  ### Required packages
  library(topicmodels)
  library(dplyr)
  library(stringi)
  library(tm)
  library(LDAvis)
  
  ### Find required quantities
  phi <- posterior(fitted)$terms %>% as.matrix
  theta <- posterior(fitted)$topics %>% as.matrix
  vocab <- colnames(phi)
  doc_length <- vector()
  
  for (i in 1:length(corpus)) {
    temp <- paste(corpus[[i]]$content, collapse = ' ')
    doc_length <- c(doc_length, stri_count(temp, regex = '\\S+'))
  }
  
  temp_frequency <- as.matrix(doc_term) 
  freq_matrix <- data.frame(ST = colnames(temp_frequency),
                            Freq = colSums(temp_frequency))
  rm(temp_frequency)
  # Convert to json
  json_lda <- LDAvis::createJSON(phi = phi, theta=theta, vocab = vocab,
                                 doc.length = doc_length, term.frequency = freq_matrix$Freq)
  #freq_matrix$Freq
  return(json_lda)
} ### END of function

######################
### Visualize topics found in LDA
#######################
library(dplyr)
library(httpuv)
json1 <- topicmodels_json_ldavis(ldaOut1, docs1, dtm1)
serVis(json1, out.dir = 'vis1', open.browser = TRUE) 
### use browser firefox, not chrome, IE, nor edge

#### END.

