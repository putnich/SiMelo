calcDistances <- function(eigensList) {
  len<-length(eigensList)
  triangDistanceMatrix <- matrix(ncol = len, nrow = len)
  distanceMatrix <- matrix(ncol = len, nrow = len)
  for(i in 1:len) {
    for(j in 1:len) {
      distanceMatrix[i,j] <- dist(rbind(eigensList[[i]], eigensList[[j]])) 
      distanceMatrix[j,i] <- dist(rbind(eigensList[[i]], eigensList[[j]]))
      distanceMatrix[i,i] <- 0
      if(i>j || i==j) {
        triangDistanceMatrix[i,j] <- ''
        next()
      }
      else {
        d <- dist(rbind(eigensList[[i]], eigensList[[j]]))
        print(paste("Distance between melodies ", i, " and ", j, " is:", d, sep = " "))
        triangDistanceMatrix[i,j] <- round(d)
      }
    }
    i <- i + 1
  }
  print("-----------------------------------------------------------")
  print("Triangular distance matrix (triang(D)):")
  print("-----------------------------------------------------------")
  print(triangDistanceMatrix)
  distanceMatrix
}