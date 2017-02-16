calcDistances <- function(eigensList) {
  len<-length(eigensList)
  distanceMatrix <- matrix(ncol = len, nrow = len, dimnames = list(c(1:len), c(1:len)))
  for(i in 1:len) {
    for(j in 1:len) {
      distanceMatrix[i,j] = distanceMatrix[j,i] <- dist(rbind(eigensList[[i]], eigensList[[j]]))
      distanceMatrix[i,i] <- 0
      if(i>j || i==j) {
        next()
      }
      else {
        d <- dist(rbind(eigensList[[i]], eigensList[[j]]))
        print(paste("Distance between melodies ", i, " and ", j, " is:", d, sep = " "))
      }
    }
  }
  len <- dim(distanceMatrix)[1]
  if(!(dir.exists("distancePlots"))) {
    dir.create("distancePlots")
  }
  else {
    unlink("distancePlots",recursive = T)
    dir.create("distancePlots")
  }
  for(i in 1:len) {
    png(paste("distancePlots/plot", i, ".png", sep=""))
    plot(distanceMatrix[,i])
    dev.off()
  }

  library(qgraph)
  jpeg("distancePlots/graph.jpg", width=3000, height=3000, unit='px')
  qgraph(distanceMatrix, layout="spring", vsize=3)
  dev.off()
  
  library(igraph)
  g <- graph_from_adjacency_matrix(distanceMatrix, mode="undirected", weighted = T)
  plot(g)
  calcMetrics(g)
  
  distanceMatrix
}