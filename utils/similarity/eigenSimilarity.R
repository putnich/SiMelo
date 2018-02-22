eigenSimilarity <- function(melodiesTable, type) {
  
  len <- length(melodiesTable$Melody.name)
  matricesList <- list()
  #if reading melodies from csv or reading from actual music files
  if(typeof(melodiesTable)!="list") {
    melodiesList <- list()
    durationsList <- list()
    
    for(i in 1:len) {
      melodiesList[i] <- strsplit(as.character(melodiesTable$Melody[[i]]), "[-]")
      durationsList[i] <- strsplit(as.character(melodiesTable$Duration[[i]]), "[-]")
    }
    
    matricesList <- makeMatrices(melodiesList, durationsList, type) #Creating adjacency matrices from musical notes sequence
    
  }
  else {
    melodiesList <- melodiesTable$Melody
    matricesList <- makeMatrices(melodiesList, NULL, type)
  }
  
  
  
  print("-----------------------------------------------------------")
  print("Adjacency matrices (A) for melodies, respectively:")
  print("-----------------------------------------------------------")
  print(matricesList)
  
  eigensList <- list()
  eigensList <- calcEigens(matricesList, melodiesTable) #Calculating eigenvalues from matrices
  
  print("-----------------------------------------------------------")
  print("Matrices spectra, respectively")
  print("-----------------------------------------------------------")
  print(eigensList)
  
  print("-----------------------------------------------------------")
  print("Euclidean distances, respectively:")
  print("-----------------------------------------------------------")
  
  melodies <- melodiesTable$Melody
  melodiesNames <- melodiesTable$Melody.name
  authors <- melodiesTable$Author
  
  distanceMatrix <- calcDistances(NULL, melodiesNames, authors, eigensList, NULL, "eigen") #Creating distance matrix using eigenvalues
  
  print("-----------------------------------------------------------")
  print("Cluster analysis:")
  print("-----------------------------------------------------------")
  
  #Hierarchical clustering
  calcClusters(melodiesNames, authors, distanceMatrix, paste("eigen", type, sep="-"), "hierarchical")
  
  #K-means clustering
  calcClusters(melodiesNames, authors, distanceMatrix, "eigen", "k-means")
  
  #K-medoids clustering
  calcClusters(melodiesNames, authors, distanceMatrix, "eigen", "k-medoids")
  
  #Generating graph for melodies
  # makeGraphs(melodiesNames, matricesList, type) #Creating graphs for each melody
}

makeMatrices <- function(melodiesList, durationsList, type) {
  matricesList <- list()
  len <- length(melodiesList)
  for(i in 1:len) {
    m <- matrix(rep(0, 144), ncol = 12, nrow = 12, 
                dimnames = list(c("c", "c#", "d", "d#", "e", "f", "f#", "g", "g#", "a", "a#", "h"), 
                                c("c", "c#", "d", "d#", "e", "f", "f#", "g", "g#", "a", "a#", "h")))
    n <- matrix(rep(0, 144), ncol = 12, nrow = 12, 
                dimnames = list(c("c", "c#", "d", "d#", "e", "f", "f#", "g", "g#", "a", "a#", "h"), 
                                c("c", "c#", "d", "d#", "e", "f", "f#", "g", "g#", "a", "a#", "h")))
    vLen <- length(melodiesList[[i]])
    
    for(j in 1:vLen) {
      if(j == vLen) next() 
      else {
        if(type == "simple") {
          if(m[melodiesList[[i]][j], melodiesList[[i]][j+1]] != 1) m[melodiesList[[i]][j], melodiesList[[i]][j+1]] = 1
          else next()
        }
        if(type == "multi") m[melodiesList[[i]][j], melodiesList[[i]][j+1]] = m[melodiesList[[i]][j], melodiesList[[i]][j+1]] + 1
        if(type == "duration") m[melodiesList[[i]][j], melodiesList[[i]][j+1]] = m[melodiesList[[i]][j], melodiesList[[i]][j+1]] + 
            as.numeric(durationsList[[i]][j])
        if(type=="duration-average") {
          m[melodiesList[[i]][j], melodiesList[[i]][j+1]] = (m[melodiesList[[i]][j], melodiesList[[i]][j+1]] *  n[melodiesList[[i]][j], melodiesList[[i]][j+1]] 
                                                             + as.numeric(durationsList[[i]][j])) / (n[melodiesList[[i]][j], melodiesList[[i]][j+1]] + 1)
          n[melodiesList[[i]][j], melodiesList[[i]][j+1]] <- n[melodiesList[[i]][j], melodiesList[[i]][j+1]] + 1
        }
      } 
      
    }
    
    matricesList[[i]] <- m
  }
  
  matricesList
}

calcEigens <- function(matricesList, melodiesTable) {
  
  eigensList <- list()
  
  len <- length(matricesList)
  
  for(i in 1:len) {
    e <- eigen(matricesList[[i]]%*%t(matricesList[[i]])) #Calculating eigenvalues for A*A' matrix
    eigensList[[i]] <- e$values
  }
  
  eigensList
}