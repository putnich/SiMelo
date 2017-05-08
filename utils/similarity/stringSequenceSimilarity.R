stringSequenceSimilarity <- function(melodiesTable, method, q=2) {

  #Libraries
  library(stringr)
  library(stringdist)
  
  #LCS - longest common subsequence method - finding length of LCS for each pair of melodies
  if(method == "LCS") LCSSimilarity(melodiesTable, method)
  
  #OM - optimal matching - used with sequences that contain discrete states - one melody is 
  #tranformed into another by insertion, deletion and substitiution operations
  #while the cost of each transformation is calculated
  if(method == "OM")   OMSimilarity(melodiesTable, method)
  
  #Levenstein distance, or edit distance - measures how many character(insert, delete, sibstitute)
  #edits are necessary to trasform one melody into another
  if(method == "levenstein") levensteinSimilarity(melodiesTable, method)
  
  #The document-term matrix is created, and it contains number of musical note occurences in the melody
  #vector of occurences is then used to calculate cosine distance between them
  #Term length is one
  if(method == "cosine") cosineSimilarity(melodiesTable, method)
  
  #The document-term matrix is created for different term lengths (melody sequence)
  #The data is then used for clustering, with Euclidean distance based matrix
  if(method == "qgrams") qgramsSimilarity(melodiesTable, q, method)
  
  #The Jaccard coefficient is calculated for each pair of melodies
  if(method == "jaccard") jaccardSimilarity(melodiesTable, method)
  
}

LCSSimilarity <- function(melodiesTable, method) {
  
  melodies <- melodiesTable$Melody
  melodiesNames <- melodiesTable$Melody.name
  authors <- melodiesTable$Author
  
  #Creating distance matrix
  distanceMatrix <- calcDistances(melodies, melodiesNames, authors, NULL, NULL, method = "LCS")
  
  #Hierarchical clustering
  calcClusters(melodiesNames, authors, distanceMatrix, paste("string", method, sep="-"), "hierarchical")
  
  #K-means clustering
  calcClusters(melodiesNames, authors, distanceMatrix, "string", "k-means")
  
  #K-medoids clustering
  calcClusters(melodiesNames, authors, distanceMatrix, "string", "k-medoids")
}

OMSimilarity <- function(melodiesTable, method) {
  
  melodies <- melodiesTable$Melody
  melodiesNames <- melodiesTable$Melody.name
  authors <- melodiesTable$Author
  
  #Creating distance matrix
  distanceMatrix <- calcDistances(melodies, melodiesNames, authors, NULL, NULL, method = "OM")
  
  #Hierarchical clustering
  calcClusters(melodiesNames, authors, distanceMatrix, paste("string", method, sep="-"), "hierarchical")
  
  #K-means clustering
  calcClusters(melodiesNames, authors, distanceMatrix, "string", "k-means")
  
  #K-medoids clustering
  calcClusters(melodiesNames, authors, distanceMatrix, "string", "k-medoids")
}

levensteinSimilarity <- function(melodiesTableStrings, method) {
  
  melodies <- melodiesTableStrings$Melody
  melodiesNames <- melodiesTableStrings$Melody.name
  authors <- melodiesTableStrings$Author
  
  #Creating distance matrix
  distanceMatrix <- calcDistances(melodies, melodiesNames, authors, NULL, NULL)
  
  #Hierarchical clustering
  calcClusters(melodiesNames, authors, distanceMatrix, paste("string", method, sep="-"), "hierarchical")
  
  #K-means clustering
  calcClusters(melodiesNames, authors, distanceMatrix, "string", "k-means")
  
  #K-medoids clustering
  calcClusters(melodiesNames, authors, distanceMatrix, "string", "k-medoids")
  
}

cosineSimilarity <- function(melodiesTable, method) {
  
  #Libraries
  library('lsa')
  
  #Splitting melodies into notes
  melodiesList <- list()
  len <- length(melodiesTable$Melody)
  for(i in 1:len) {
    melodiesList[i] <- strsplit(as.character(melodiesTable$Melody[[i]]), "[-]")
  }
  
  melodies <- melodiesTable$Melody
  melodiesNames <- melodiesTable$Melody.name
  authors <- melodiesTable$Author
  
  #Creating documents
  directory = paste(getwd(),"data/docTerms", sep="/")
  dir.create(directory)
  
  #Writing terms (notes) to files
  for(i in 1:len) {
    write(melodiesList[[i]], file = paste(directory, melodiesNames[[i]], sep="/"))
  }
  
  #Creating document-term matrix
  docTermMatrix <- t(textmatrix(directory, minWordLength = 1))
  
  #Creating distance matrix with cosine distance
  distanceMatrix <- calcDistances(NULL, melodiesNames, authors, NULL, docTermMatrix)
  
  #Hierarchical clustering
  calcClusters(melodiesNames, authors, distanceMatrix, paste("string", method, sep="-"), "hierarchical")
  
  #K-means clustering
  calcClusters(melodiesNames, authors, distanceMatrix, "string", "k-means")
  
  #K-medoids clustering
  calcClusters(melodiesNames, authors, distanceMatrix, "string", "k-medoids")
  
}

qgramsSimilarity <- function(melodiesTable, a, method) {
  
  melodies <- melodiesTable$Melody
  melodiesNames <- melodiesTable$Melody.name
  authors <- melodiesTable$Author
  melodies <- lapply(melodiesTable$Melody, str_replace_all, pattern="-", replacement = "")
  
  #Matrix of occurences of the note sequences in melodies, for different length of sequences
  clusterData <- qgrams(melodies[[1]], melodies[[2]], melodies[[3]], melodies[[4]], melodies[[5]], melodies[[6]], melodies[[7]], 
                        melodies[[8]], melodies[[9]], melodies[[10]], melodies[[11]], melodies[[12]], melodies[[13]], melodies[[14]], 
                        melodies[[15]], melodies[[16]], melodies[[17]], q=a)
  
  rownames(clusterData) <- melodiesNames
  
  #Hierarchical clustering
  calcClusters(melodiesNames, authors, clusterData, paste("qgramsMatrix", method, sep="-"), "hierarchical")
  
  #K-means clustering
  calcClusters(melodiesNames, authors, clusterData, "qgramsMatrix", "k-means")
  
  #K-medoids clustering
  calcClusters(melodiesNames, authors, clusterData, "qgramsMatrix", "k-medoids")
}

jaccardSimilarity <- function(melodiesTable, method) {
  
  melodies <- melodiesTable$Melody
  melodiesNames <- melodiesTable$Melody.name
  authors <- melodiesTable$Author
  
  melodiesRepl <- lapply(melodiesTable$Melody, str_replace_all, pattern="-", replacement = "")
  
  distanceMatrix <- calcDistances(melodiesRepl, melodiesNames, authors, NULL, NULL, method = "jaccard")
  
  #Hierarchical clustering
  calcClusters(melodiesNames, authors, distanceMatrix, paste("string", method, sep="-"), "hierarchical")
  
  #K-means clustering
  calcClusters(melodiesNames, authors, distanceMatrix, "string", "k-means")
  
  #K-medoids clustering
  calcClusters(melodiesNames, authors, distanceMatrix, "string", "k-medoids")
}