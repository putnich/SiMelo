calcDistances <- function(eigensList) {
  len<-length(eigensList)
  triangDistanceMatrix <- matrix(ncol = len, nrow = len)
  distanceMatrix <- matrix(ncol = len, nrow = len)
  for(i in 1:len) {
    for(j in 1:len) {
      distanceMatrix[i,j] <- dist(rbind(eigensList[[i]], eigensList[[j]])) 
      distanceMatrix[j,i] <- dist(rbind(eigensList[[i]], eigensList[[j]]))
      distanceMatrix[i,i] <- 0
      if(i>j) {
        triangDistanceMatrix[i,j] <- ''
        next()
      }
      else if(i==j) {
        triangDistanceMatrix[i,j] <- 0
        next()
      }
      else {
        d <- dist(rbind(eigensList[[i]], eigensList[[j]]))
        print(paste("Distance between melodies ", i, " and ", j, " is:", d, sep = " "))
        triangDistanceMatrix[i,j] <- round(d)
      }
    }
  }
  print("-----------------------------------------------------------")
  print("Triangular distance matrix (triang(D)):")
  print("-----------------------------------------------------------")
  print(triangDistanceMatrix)
  len <- dim(distanceMatrix)[1]
  print(len)
  for(i in 1:len) {
    png(paste("plot", i, ".png", sep=""))
    plot(distanceMatrix[,i])
    dev.off()
  }
  
  library(qgraph)
  jpeg("graph.jpg", width=3000, height=3000, unit='px')
  qgraph(distanceMatrix, layout="spring", vsize=3)
  dev.off()
  
  jpeg("dendrogram.jpg", width=3000, height=3000, unit='px')
  dendrogram <- hclust(dist(distanceMatrix), method="ward.D")
  plot(dendrogram)
  distanceMatrix
}