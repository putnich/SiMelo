stringSequenceSimilarity <- function(melodiesTable, method, q=1) {
  table <- melodiesTable
  if(method == "LCS") LCSSimilarity(table)
  
  if(method == "OM")   OMSimilarity(melodiesTable)
  
  if(method == "levenstein") levensteinSimilarity(melodiesTable)
  
  if(method == "cosine") cosineSimilarity(melodiesTable)
  
  if(method == "qgrams") qgramsSimilarity(melodiesTable, q)
  
}

levensteinSimilarity <- function(melodiesTableStrings) {
  len <- length(melodiesTableStrings$Melody)
  
  melodies <- melodiesTableStrings$Melody
  melodiesNames <- melodiesTableStrings$Melody.name
  authors <- melodiesTableStrings$Author
  
  distanceMatrix <- calcDistances(melodies, melodiesNames, authors, NULL, NULL)
  
  calcClusters(melodiesNames, authors, distanceMatrix, "string", "hierarchical")
  # calcClusters(melodiesNames, authors, distanceMatrix, "string", "k-means")
  calcClusters(melodiesNames, authors, distanceMatrix, "string", "k-medoids")
  
}

cosineSimilarity <- function(melodiesTable) {
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
  calcClusters(melodiesNames, authors, docTermMatrix, "cosine", "hierarchical")
  
  #K-means clustering
  # calcClusters(melodiesNames, authors, docTermMatrix, "cosine", "k-means")
  
  #K-medoids clustering
  calcClusters(melodiesNames, authors, docTermMatrix, "cosine", "k-medoids")
  
}

LCSSimilarity <- function(melodiesTable) {
  melodies <- melodiesTable$Melody
  melodiesNames <- melodiesTable$Melody.name
  authors <- melodiesTable$Author
  distanceMatrix <- calcDistances(melodies, melodiesNames, authors, NULL, NULL, method = "LCS")
  calcClusters(melodiesNames, authors, distanceMatrix, "string", "hierarchical")
  calcClusters(melodiesNames, authors, distanceMatrix, "string", "k-means")
  calcClusters(melodiesNames, authors, distanceMatrix, "string", "k-medoids")
}

OMSimilarity <- function(melodiesTable) {
  melodies <- melodiesTable$Melody
  melodiesNames <- melodiesTable$Melody.name
  authors <- melodiesTable$Author
  distanceMatrix <- calcDistances(melodies, melodiesNames, authors, NULL, NULL, method = "OM")
  
  calcClusters(melodiesNames, authors, distanceMatrix, "string", "hierarchical")
  calcClusters(melodiesNames, authors, distanceMatrix, "string", "k-means")
  calcClusters(melodiesNames, authors, distanceMatrix, "string", "k-medoids")
}

qgramsSimilarity <- function(melodiesTable, a) {
  melodies <- melodiesTable$Melody
  melodiesNames <- melodiesTable$Melody.name
  authors <- melodiesTable$Author
  melodies <- lapply(melodiesTable$Melody, str_replace_all, pattern="-", replacement = "")
  clusterData <- qgrams(melodies[[1]], melodies[[2]], melodies[[3]], melodies[[4]], melodies[[5]], melodies[[6]], melodies[[7]], 
                        melodies[[8]], melodies[[9]], melodies[[10]], melodies[[11]], melodies[[12]], melodies[[13]], melodies[[14]], 
                        melodies[[15]], melodies[[16]], melodies[[17]], melodies[[18]], q=a)
  rownames(clusterData) <- melodiesNames
  calcClusters(melodiesNames, authors, clusterData, "qgramsMatrix", "hierarchical")
  calcClusters(melodiesNames, authors, clusterData, "qgramsMatrix", "k-means")
  calcClusters(melodiesNames, authors, clusterData, "qgramsMatrix", "k-medoids")
}