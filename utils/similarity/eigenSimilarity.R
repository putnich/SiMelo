eigenSimilarity <- function(melodiesTable, type) {
  len <- length(melodiesTable$Melody.name)
  melodiesList <- list()
  durationsList <- list()
  for(i in 1:len) {
    melodiesList[i] <- strsplit(as.character(melodiesTable$Melody[[i]]), "[-]")
    durationsList[i] <- strsplit(as.character(melodiesTable$Duration[[i]]), "[-]")
  }
  matricesList <- list()
  matricesList <- makeMatrices(melodiesList, durationsList, type) #Creating adjacency matrices from musical notes sequence
  print("-----------------------------------------------------------")
  print("Adjacency matrices (A) for melodies, respectively:")
  print("-----------------------------------------------------------")
  print(matricesList)
  
  eigensList <- list()
  if(all(isMarkov(matricesList)) == T) {
    print("All directed graphs are strongly connected, switching to finite Markov chain (Perron-Frobenius theorem)")
    eigensList <- calcEigens(matricesList, "markov", melodiesTable) #Calculating eigenvalues from matrices
  }
  else eigensList <- calcEigens(matricesList, "basic", melodiesTable) #Calculating eigenvalues from matrices
  
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
  
  distanceMatrix <- calcDistances(NULL, melodiesNames, authors, eigensList, NULL) #Creating distance matrix using eigenvalues
  
  print("-----------------------------------------------------------")
  print("Cluster analysis:")
  print("-----------------------------------------------------------")
  calcClusters(melodiesTable$Melody.name, melodiesTable$Author, eigensList, "eigen", "hierarchical", type)
  # calcClusters(melodiesTable$Melody.name, melodiesTable$Author, eigensList, "eigen", "k-means")
  calcClusters(melodiesTable$Melody.name, melodiesTable$Author, eigensList, "eigen", "k-medoids")
  
  
  # makeGraphs(matricesList) #Creating graphs for each melody
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
        if(type == "duration") m[melodiesList[[i]][j], melodiesList[[i]][j+1]] = m[melodiesList[[i]][j], melodiesList[[i]][j+1]] + as.numeric(durationsList[[i]][j])
        if(type=="duration-average") {
          m[melodiesList[[i]][j], melodiesList[[i]][j+1]] = (m[melodiesList[[i]][j], melodiesList[[i]][j+1]] *  n[melodiesList[[i]][j], melodiesList[[i]][j+1]] 
                                                             + as.numeric(durationsList[[i]][j])) / (n[melodiesList[[i]][j], melodiesList[[i]][j+1]] + 1)
          n[melodiesList[[i]][j], melodiesList[[i]][j+1]] <- n[melodiesList[[i]][j], melodiesList[[i]][j+1]] + 1
        }
      } 
      
    }
    # print(n)
    matricesList[[i]] <- m
  }
  matricesList
}

isMarkov <- function(matricesList) {
  library(igraph)
  
  #Plotting melody graph for each melody
  len <- length(matricesList)
  stronglyConnected <- c()
  for(i in 1:len) {
    g <- graph_from_adjacency_matrix(matricesList[[i]], mode="directed")
    stronglyConnected[i] <- is.connected(g, mode = "strong")
  }
  
  stronglyConnected
}

calcEigens <- function(matricesList, model, melodiesTable) {
  eigensList <- list()
  if(model == "markov") {
    # d <- diag(degree(matricesList[[i]]))
    # p <- t(d)%*%matricesList[[i]] #Transition matrix - Markov matrix
    # phi <- solve(p - diag(ncol(p)), c(rep(0, ncol(p))))
    # g <-sqrt(phi) %*% (diag(ncol(p)) - p) %*% (1/sqrt(phi))
    # eigensList[i] <- eigen(g)
  }
  else {
    len <- length(matricesList)
    for(i in 1:len) {
      e <- eigen(matricesList[[i]]%*%t(matricesList[[i]])) #Calculating eigenvalues for A*A' matrix
      eigensList[[i]] <- e$values
    }
  }
  
  
  eigensList
  
}