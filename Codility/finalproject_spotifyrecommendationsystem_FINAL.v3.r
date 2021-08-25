#Spotify Recommendation System

#The Goal is to use the recommender system to offer a top recommended tracks/songs from over 3 million playlists.

#(A) Build three recommended models - POPULAR, IBCF ('jaccard'), and UBCF ('jaccard'). 
#    Two types used for these three recommended models: (i) 'topNList' to get top 10 recommended tracks(songs) for each playlist using train dataset  
#                                                       (ii) 'ratings' to get predicted ratings for tracks not rated by playlist using test dataset
#(B) Evaluation scheme on data_matrix dataset: (i) generate and calculate prediction accuracy for UBCF and IBCF - topNList
#                                             (ii) k-fold cross validation and ROC curve to find the best recommendation method - ibcf_jaccard_25 was the best recommendation method. 


#1. Read Data
#There are 3,323,224 observations with 26 variables
getwd()
library(tidyverse)
library(dplyr)
library(stringr)
library(recommenderlab) #recommendation (top list or prediction of rating not rated by certain customer)
library(ggplot2)
options(scipen=999)
spotify = read.csv('C:/Users/Connie/Documents/APAN5205/Project/CLEANED DATASET_02 cleaned_spotify_playlist_with_tracks_audio_features (output from R).csv')
head(spotify)[1:5]  
str(spotify)

#2. Extract data
dat = as.data.frame(spotify[,c('playlist_name', 'track_name')])
dat = dat[1:20000,] #reduced spotify dataset from 3,323,224 to 20,000 because my R file crashed.

#3. Restructure Data - Recast the dataset as a 'binaryRatingMatrix'
library(recommenderlab)
data_matrix = as(dat, Class = 'binaryRatingMatrix')
as(data_matrix, 'matrix')

#4. Explore Data
str(data_matrix) # can verify that the data_matrix is stored as binaryRatingMatrix
colMeans(data_matrix)
rowMeans(data_matrix)

#5. SPLIT
set.seed(617)
split = sample(x = nrow(data_matrix),size = 0.8*nrow(data_matrix))
train = data_matrix[split,]
test = data_matrix[-split,]
nrow(train)
nrow(test)
nrow(data_matrix)

#6. Build Recommender - POPULAR method (center normalization is default*)
recommenderRegistry$get_entries(dataType='binaryRatingMatrix')$POPULAR_binaryRatingMatrix # See parameters for POPULAR
recom_popular = Recommender(train, method = 'POPULAR', parameter = list(normalize='center'))

#7. TOP N RECOMMENDATIONS (use type, 'topNList' which is default type) 
#Use the Recommender object to generate TOP 10 predictions(tracks/songs) for the test sample.
pred_popular_topN = predict(recom_popular, newdata = train, type = 'topNList', n=10)
#Top 10 recommended songs for the first 50 playlists in the test sample
getList(pred_popular_topN)[1:50] 

#8. RATINGS (Use the type, 'ratings')
pred_popular = predict(recom_popular, newdata= test, type='ratings')
#Ratings for tracks(songs) 10-50 by Playlists 10-50 in the test  - False vs True
as(test, 'matrix')[10:50, 10:50]
#Predicted ratings for tracks(songs) 10-50 NOT RATED by Playlists 10-50 
as(pred_popular,'matrix')[10:50,10:50]

#10. Build Recommender -  UBCF method to see similarity between playlists
recommenderRegistry$get_entries(data='binaryRatingMatrix')$UBCF_binaryRatingMatrix # See parameters for UBCF
recom_ubcf = Recommender(train, 
                         method='UBCF', 
                         parameter=list(method='jaccard',nn=25))

#11. Top n recommendations (use, type, 'topNList')
#TOP 10 predictions of tracks/songs - Used type, 'topNList' 
pred_ubcf_topN = predict(recom_ubcf,newdata=test,method='topNist',n=10)
#Top 10 recommended tracks(songs) for the first 50 playlists in the test sample
getList(pred_ubcf_topN)[1:50]

#12. Ratings (use type, 'ratings')
pred_ubcf = predict(recom_ubcf, newdata=test, type='ratings')
# Ratings for tracks(songs) 10-50 by Playlists 10-50 in the test
as(test, 'matrix')[10:50, 10:50]
# Predicted ratings for tracks(songs) 10-50 NOT RATED by Playlists 10-50 
as(pred_ubcf,'matrix')[10:50,10:50]

#13. Build recommender - IBCF method - to see similarity between items(tracks/songs)
# See parameters for IBCF
recommenderRegistry$get_entries(data='binaryRatingMatrix')$IBCF_binaryRatingMatrix 

recom_ibcf = Recommender(train, method='IBCF', 
                         parameter=list(k=30, method = 'jaccard', normalize_sim_matrix = 'FALSE', alpha = 0.5))
recom_ibcf

#14. Top n recommendations 
#TOP 10 predictions of tracks/songs (use, type, 'topNList')
pred_ibcf_topN = predict(recom_ibcf,newdata=test,method='topNist',n=10)
#Top 10 recommended tracks(songs) for the first 50 playlists in the test sample
getList(pred_ibcf_topN)[1:50]

#15. Ratings (use type, 'ratings')
pred_ibcf = predict(recom_ibcf, newdata=test, type='ratings')
# Ratings for tracks(songs) 10-50 by Playlists 10-50 in the test
as(test, 'matrix')[10:50, 10:50]
# Predicted ratings for tracks(songs) 10-50 NOT RATED by Playlists 10-50 
as(pred_ibcf,'matrix')[10:50,10:50]

#16.Evaluation Scheme 
#Split: Train - Test 

#To evaluate the recommender models, create an evaluation scheme from data_matrix, not the train dataset
#Number of items(tracks/songs), 'given' must be less than minimum items (tracks/songs) by any Playlist.

#See number of minimum items(tracks/songs) rated by any Playlist is 6.
min(rowCounts(data_matrix))

#EvaluationScheme to handle splits, k-fold cross validation. make sure 'given' is less than the minimum items which is 6
es = evaluationScheme(data_matrix, method='split', train = 0.8, given = 5)

#Train set - 214 x 12748 rating matrix of class 'binaryRatingMatrix' with 15688 ratings.
getData(es, 'train')

#Test set with the items used to *build* the recommendations - 54 x 12748 rating matrix of class 'binaryRatingMatrix' with 270 ratings.
getData(es, 'known')

#Test set with the items used to *evaluate* the recommendations for computing error - 54 x 12748 rating matrix of class 'binaryRatingMatrix' with 3648 ratings.
getData(es, 'unknown')[1]


#Total number of ratings = train + Known + unknown
nratings(data_matrix) == 
  nratings(getData(es,'train')) + 
  nratings(getData(es,'known')) + 
  nratings(getData(es,'unknown')) 

#Number of items used to generate recommendations; value of 'given' - See first 20 playlists
rowCounts(getData(es,'known'))[1:20]

#Remaining items being held out for computing error - See first 20 playlists
rowCounts(getData(es,'unknown'))[1:20]

#17. Calculate prediction accuracy for an UBCF - topNList
recom_ubcf_evaluation = Recommender(data = getData(es, 'train'),
                                    method='UBCF', 
                                    parameter=list(method='jaccard',nn=25))
#Generate Predictions for topNList
pred_ubcf_evaluation = predict(recom_ubcf_evaluation, newdata=getData(es,'known'), type = 'topNList')
#Evaluate Predictions for topNList
calcPredictionAccuracy(pred_ubcf_evaluation, data = getData(es, 'unknown'), given=5)

#18. Calculate prediction accuracy for an IBCF - topNList
recom_ibcf_evaluation = Recommender(data = getData(es,'train'),
                                    method='IBCF', 
                                    parameter=list(k=30, method = 'jaccard', normalize_sim_matrix = 'FALSE', alpha = 0.5))
pred_ibcf_evaluation = predict(recom_ibcf_evaluation,newdata=getData(es,'known'), type='topNList')
calcPredictionAccuracy(pred_ibcf_evaluation, data = getData(es, 'unknown'), given=5)


#19. k-fold cross-validation for data_matrix - Evaluation of a top-N recommender algorithm

#Evaluate scheme with 10-fold cross validation with 5 items given
set.seed(1031)
es = evaluationScheme(data_matrix,method='cross',k=3,given=5)

#Next, use the "evaluate" function to see how accurate are Random, Popular, UBCF, IBCF models for 6 confusion matrices, top-1, top-3, top-5, top-10, top-15 and top-20 recommendation lists
recommender_algorithms = list(random = list(name='RANDOM'),
                              popular = list(name='POPULAR'),
                              ubcf_default = list(name='UBCF'),
                              ubcf_jaccard_25 = list(name='UBCF',  param=list(method='jaccard',nn=25)),
                              ubcf_cosine_20 = list(name  = "UBCF", param = list(method = "Cosine", nn = 20)),
                              ubcf_cosine_35 = list(name  = "UBCF", param = list(method = "Cosine", nn = 35)),
                              ibcf_default = list(name='IBCF'),
                              ibcf_5 = list(name  = "IBCF", param = list(k = 5)),
                              ibcf_jaccard_25 =  list(name='IBCF', param=list(k=30, method = 'jaccard', normalize_sim_matrix = 'FALSE', alpha = 0.5)))
ev = evaluate(x = es,method=recommender_algorithms, type = "topNList",n=c(1, 3, 5, 10, 15, 20))

#Use the "avg" function to see how are models did for generating topNList. 
#As you can see, 6 confusion matrices represented by rows. n is the number of recommendations per list.
#TP, FP, FN and TN are the entries for true positives, false positives, false negatives and true negatives in the confusion matrix. 
#Precision, recall, TPR, FPR contain precomputed performance measures. 
avg(ev)

#20. Comparison of ROC curves for these recommender models for the given-5 evaluation scheme
#The default plot is the ROC curve which plots the true positive rate (TPR) against the false positive rate (FPR)
#As you can see, ibcf_jaccard_25 model dominates (almost completely) the other method since for each length of top-N list they provide a better combination of TPR and FPR.

#Plotting 
avg_conf_matr <- function(results) {
  tmp <- results %>%
    getConfusionMatrix()  %>%  
    as.list() 
  as.data.frame(Reduce("+",tmp) / length(tmp)) %>% 
    mutate(n = c(1, 3, 5, 10, 15, 20)) %>%
    select('n', 'precision', 'recall', 'TPR', 'FPR') 
}

results_tbl <- ev %>%
  map(avg_conf_matr) %>% 
  # Turning into an unnested tibble
  enframe() %>%
  # Unnesting to have all variables on same level
  unnest(value)
results_tbl

results_tbl %>%
  ggplot(aes(FPR, TPR, 
             colour = fct_reorder2(as.factor(name), 
                                   FPR, TPR))) +
  geom_line() +
  geom_label(aes(label = n))  +
  labs(title = "ROC curves", colour = "Model") +
  theme_grey(base_size = 14)

recomm <- Recommender(getData(es, 'train'), 
                      method = "IBCF",  
                      param=list(k=30, method = 'jaccard', normalize_sim_matrix = 'FALSE', alpha = 0.5))
pred <- predict(recomm, 
                getData(es, 'unknown'), 
                method = 'topNList', 
                n = 5)

# Look at 1 playlist recommendation
spotify_dat = as.data.table(spotify)
unique(spotify_dat[track_name %in% unlist(as(pred, 'list')[72]), c('playlist_name', 'track_uri', 'track_name', 'artist_name')], by = 'track_name')

# Look at the existing playlist
head(spotify_dat[playlist_name == "run", c('playlist_name', 'track_uri', 'track_name', 'artist_name')])

