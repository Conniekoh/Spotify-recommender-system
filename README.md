# Spotify-recommender-system

![](https://images.unsplash.com/photo-1611339555312-e607c8352fd7?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=667&q=80)

___
# Description
Spotify has a community of more than 345 million users, including 158 million premium subscribers, across 178 markets. As of March 31, 2021, Spotify had over 70 million songs, over 4 billion playlists, 190 million active users and a collection of over 40 million tracks. Given the overwhelming amount of data, it raises the question of how this streaming service can offer new ways to consume and discover new music. 

Using the Recommender System for Song Prediction, I explored different recommender system methods on Spotify user data to determine which is the most successful at personalized song selection. Of all machine learning systems, I selected recommender systems because it is the most successful at searching through large volumes of data to provide more personalized content to users. I used three recommender system methods. The popular method, one of the simplest of the recommender systems, is not customized to the user but rather recommends items based on average of all consumer choices. User-based collaborative filtering (UBCF) and item-based collaborative filtering (IBCF) are memory-based collaborative filtering methods. UBCF looks at the similarity between playlists and IBCF looks at the similarities between songs. Although recommender system methods are most commonly used above all other systems due to their effectiveness, they are limited in situations when songs have not been added to many playlists or not added to any playlists at all.


___
# Project Data & Data Preparation 
# Project Data 
The project data consists of two parts. The first is a Spotify dataset directly obtained from AICrowd. The dataset contains one million playlists created by Spotify users from January 2010 to October 2017. It holds over three million observations and twenty six variables. The second part is a dataset obtained from calling the Spotify API (Application Programming Interface), specifically the audio features API. 

# Data Preparation 
As the last step in the Python environment, I checked for null values and exported the data to be analyzed further in R. I found that there were 6 tracks that did not have audio features via the Spotify API. Since this is relatively small, we decided to drop them in R.

___
# Goal
The Goal is to use the recommender system to find the best unsupervised machine learning models to offer a top recommended tracks/songs from over 3 million playlists.

Built three recommended models - POPULAR, IBCF, and UBCF. 
Two types used for these three recommended models:
(i) 'topNList' to get top 10 recommended tracks(songs) for each playlist using train dataset  
(ii) 'ratings' to get predicted ratings for tracks not rated by playlist using test dataset
___
# Metric
Evaluation scheme on data_matrix dataset:
(i) Comparison of ROC curves for these recommender models for the given-5 evaluation scheme
(ii) Plotting ROC curve to find the best reocmmendation model - This plots the true positive rate (TPR) against the false positive rate (FPR)
# ibcf_jaccard_25 model dominates (almost completely) the other method since for each length of top-N list they provide a better combination of TPR and FPR.

___
# Steps
1. Read Data
2. Extract Data
3. Restructure data - recast the dataset as a 'binaryRatingMatrix'
4. Split data into train and test dataset
5. Build recommenders using three methods 
(i) POPULAR method to generate top 10 predictions (tracks/songs) for the test sample
(ii) UBCF method to see similarity between playlists and generate top 10 predictions (tracks/songs) for the playlists in the test sample.
(iii) IBCF method to see similarity between items (tracks/songs) and generate top 10 predictiosn of tracks/songs for the playlists in the test sample. 
6. K-fold cross-validation for data_matrix - Evaluation of a top-N recommender algorithm
7. Plot ROC curves to find the best recommender model
# ibcf_jaccard_25 model dominates (almost completely) the other method which provides the best combination of TPR and FPR.

:file_folder: [See my module](https://github.com/Conniekoh/Spotify-recommender-system/blob/main/Codility/finalproject_spotifyrecommendationsystem_FINAL.v3.r)
___
## Before Release
- [x] Finish my changes
- [x] this is a complete item
- [ ] this is an incomplete item
