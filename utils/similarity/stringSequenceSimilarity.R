stringSequenceSimilarity <- function(melodiesTable, method, q=1) {

  library(stringr)
  library(stringdist)
  
  if(method == "LCS") LCSSimilarity(melodiesTable, method)
  
  if(method == "OM")   OMSimilarity(melodiesTable, method)
  
  if(method == "levenstein") levensteinSimilarity(melodiesTable, method)
  
  if(method == "cosine") cosineSimilarity(melodiesTable, method)
  
  if(method == "qgrams") qgramsSimilarity(melodiesTable, q, method)
  
  if(method == "jaccard") jaccardSimilarity(melodiesTable, method)
  
}

levensteinSimilarity <- function(melodiesTableStrings, method) {
  len <- length(melodiesTableStrings$Melody)
  
  melodies <- melodiesTableStrings$Melody
  melodiesNames <- melodiesTableStrings$Melody.name
  authors <- melodiesTableStrings$Author
  
  distanceMatrix <- calcDistances(melodies, melodiesNames, authors, NULL, NULL)
  
  calcClusters(melodiesNames, authors, distanceMatrix, paste("string", method, sep="-"), "hierarchical")
  calcClusters(melodiesNames, authors, distanceMatrix, "string", "k-means")
  calcClusters(melodiesNames, authors, distanceMatrix, "string", "k-medoids")
  
}

cosineSimilarity <- function(melodiesTable, method) {
  library('lsa')
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
  
  for(i in 1:len) {
    write(melodiesList[[i]], file = paste(directory, melodiesNames[[i]], sep="/"))
  }
  
  docTermMatrix <- textmatrix(directory, minWordLength = 1)
  
  calcDistances(NULL, melodiesNames, authors,NULL,t(docTermMatrix))
  
  #Hierarchical clustering
  calcClusters(melodiesNames, authors, docTermMatrix, paste("cosine", method, sep="-"), "hierarchical")
  
  #K-means clustering
  calcClusters(melodiesNames, authors, docTermMatrix, "cosine", "k-means")
  
  #K-medoids clustering
  calcClusters(melodiesNames, authors, docTermMatrix, "cosine", "k-medoids")
  
}

LCSSimilarity <- function(melodiesTable, method) {
  melodies <- melodiesTable$Melody
  melodiesNames <- melodiesTable$Melody.name
  authors <- melodiesTable$Author
  distanceMatrix <- calcDistances(melodies, melodiesNames, authors, NULL, NULL, method = "LCS")
  calcClusters(melodiesNames, authors, distanceMatrix, paste("string", method, sep="-"), "hierarchical")
  calcClusters(melodiesNames, authors, distanceMatrix, "string", "k-means")
  calcClusters(melodiesNames, authors, distanceMatrix, "string", "k-medoids")
}

OMSimilarity <- function(melodiesTable, method) {
  melodies <- melodiesTable$Melody
  melodiesNames <- melodiesTable$Melody.name
  authors <- melodiesTable$Author
  distanceMatrix <- calcDistances(melodies, melodiesNames, authors, NULL, NULL, method = "OM")
  
  calcClusters(melodiesNames, authors, distanceMatrix, paste("string", method, sep="-"), "hierarchical")
  calcClusters(melodiesNames, authors, distanceMatrix, "string", "k-means")
  calcClusters(melodiesNames, authors, distanceMatrix, "string", "k-medoids")
}

qgramsSimilarity <- function(melodiesTable, a, method) {
  melodies <- melodiesTable$Melody
  melodiesNames <- melodiesTable$Melody.name
  authors <- melodiesTable$Author
  melodies <- lapply(melodiesTable$Melody, str_replace_all, pattern="-", replacement = "")
  clusterData <- qgrams(melodies[[1]], melodies[[2]], melodies[[3]], melodies[[4]], melodies[[5]], melodies[[6]], melodies[[7]], 
                        melodies[[8]], melodies[[9]], melodies[[10]], melodies[[11]], melodies[[12]], melodies[[13]], melodies[[14]], 
                        melodies[[15]], melodies[[16]], melodies[[17]], melodies[[18]], q=a)
  rownames(clusterData) <- melodiesNames
  calcClusters(melodiesNames, authors, clusterData, paste("qgramsMatrix", method, sep="-"), "hierarchical")
  calcClusters(melodiesNames, authors, clusterData, "qgramsMatrix", "k-means")
  calcClusters(melodiesNames, authors, clusterData, "qgramsMatrix", "k-medoids")
}

jaccardSimilarity <- function(melodiesTable, method) {
  melodies <- melodiesTable$Melody
  melodiesNames <- melodiesTable$Melody.name
  authors <- melodiesTable$Author
  melodiesRepl <- lapply(melodiesTable$Melody, str_replace_all, pattern="-", replacement = "")
  print(melodies)
  distanceMatrix <- calcDistances(melodiesRepl, melodiesNames, authors, NULL, NULL, method = "jaccard")
  calcClusters(melodiesNames, authors, distanceMatrix, paste("string", method, sep="-"), "hierarchical")
  calcClusters(melodiesNames, authors, distanceMatrix, "string", "k-means")
  calcClusters(melodiesNames, authors, distanceMatrix, "string", "k-medoids")
}