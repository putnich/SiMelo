calcDistances <- function(melodies, melodiesNames, authors, eigensList, docTermMatrix, method = "") {
  
  #Libraries
  library(qgraph)
  library(igraph)
  library(TraMineR)
  
  #Creating distance matrix
  len <- length(melodiesNames)
  
  distanceMatrix <- matrix(rep(0, len*len), ncol = len, nrow = len, dimnames = list(paste(melodiesNames, authors, sep=" : ") , paste(melodiesNames, authors, sep=" : ")))
  
  if(method == "LCS") {
    #Defining melodies as sequences
    sequences <- seqdef(melodies)
    
    #Creating substitution cost matrix
    ccost <- seqsubm(sequences, method = "CONSTANT")
    
    #Creating distance matrix by using sequences and tranformation costs
    m <- seqdist(sequences, method, sm=ccost, norm=T)
    distanceMatrix <- matrix(m, ncol=ncol(m), nrow=nrow(m), dimnames=list(paste(melodiesNames, authors, sep=" : "), paste(melodiesNames, authors, sep=" : ")))
  }
  
  else {
    if(method == "OM") {
      
      #Defining melodies as sequences
      sequences <- seqdef(melodies)
      
      #Creating substitution cost matrix
      ccost <- seqsubm(sequences, method = "CONSTANT")
      
      #Creating distance matrix by using sequences and tranformation costs
      m <- seqdist(sequences, method, sm=ccost, norm=T)
      distanceMatrix <- matrix(m, ncol=ncol(m), nrow=nrow(m), dimnames=list(paste(melodiesNames, authors, sep=" : "), paste(melodiesNames, authors, sep=" : ")))
    }
    else {
      for(i in 1:len) {
        for(j in 1:len) {
          if(is.null(docTermMatrix)) {
            if(is.null(eigensList)) {
              if(method == "jaccard") d <- distanceMatrix[i,j] <- distanceMatrix[j,i] <- stringdist(melodies[[i]], melodies[[j]], method)
              else d <- distanceMatrix[i,j] <- distanceMatrix[j,i] <- adist(melodies[i], melodies[j]) #Levenstein edit distance
            }
            #If eigen vectors list exists, then the Euclidean distance between eigen vectors in calculated
            else d <- distanceMatrix[i,j] <- distanceMatrix[j,i] <- dist(rbind(eigensList[[i]], eigensList[[j]]))
          }
          #If document-term matrix exists, then the cosine distance is used
          else  d <- distanceMatrix[i,j] <- distanceMatrix[j,i] <- lsa::cosine(docTermMatrix[i,], docTermMatrix[j,]) #cosine distance
          
          distanceMatrix[i,i] <- 0
          if(i>j || i==j) {
            next()
          }
          else {
            print(paste("Distance between melodies ", i, " and ", j, " is:", d, sep = " "))
          }
        }
      }
      
    }
  }
  
  distanceMatrix
}