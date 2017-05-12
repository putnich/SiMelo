calcDistances <- function(melodies, melodiesNames, authors, eigensList, docTermMatrix, method = "") {
  
  #Libraries
  library(qgraph)
  library(igraph)
  library(TraMineR)
  
  #Creating distance matrix
  len <- length(melodiesNames)
  
  distanceMatrix <- matrix(rep(0, len*len), ncol = len, nrow = len, dimnames = list(paste(melodiesNames, authors, sep=" : ") , paste(melodiesNames, authors, sep=" : ")))

  for(i in 1:len) {
    for(j in 1:len) {
      if(method == "eigen") {
        d <- distanceMatrix[i,j] <- distanceMatrix[j,i] <- dist(rbind(eigensList[[i]], eigensList[[j]]))
      }
      if(method == "levenstein") {
        d <- distanceMatrix[i,j] <- distanceMatrix[j,i] <- adist(melodies[i], melodies[j])
      }
      if(method == "cosine") {
        d <- distanceMatrix[i,j] <- distanceMatrix[j,i] <- lsa::cosine(docTermMatrix[i,], docTermMatrix[j,])
      }
      if(method == "jaccard") {
        d <- distanceMatrix[i,j] <- distanceMatrix[j,i] <- stringdist(melodies[[i]], melodies[[j]], method)
      }
      
      distanceMatrix[i,i] <- 0
      
      if(i>j || i==j) {
        next()
      }
      else {
        print(paste("Distance between melodies ", i, " and ", j, " is:", d, sep = " "))
      }
    }
  }
  
  distanceMatrix
}