# Spotify-recommender-system

![](https://images.unsplash.com/photo-1611339555312-e607c8352fd7?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=667&q=80)

___
# Description
This project was completed by Connie Koh in partial fulfillment of APANPS5205: Applied Analytics Frameworksand Methods II, Summer 2021. This project is a listing of over 3 million Spotify playlists.
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
