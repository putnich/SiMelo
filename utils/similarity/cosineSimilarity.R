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
  calcClusters(melodiesNames, authors, docTermMatrix, "cosine", "hierarchical", "cosine")

  #K-means clustering
  # calcClusters(melodiesNames, authors, docTermMatrix, "cosine", "k-means")

  #K-medoids clustering
  calcClusters(melodiesNames, authors, docTermMatrix, "cosine", "k-medoids")

}




