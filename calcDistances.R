calcDistances <- function(melodies, eigensList) {
  len<-length(eigensList)
  distanceMatrix <- matrix(ncol = len, nrow = len, dimnames = list(melodies, melodies))
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
  # for(i in 1:len) {
  #   png(paste("distancePlots/plot - ", row.names(distanceMatrix)[i], ".png", sep=""))
  #   plot(distanceMatrix[,i], xaxn="n")
  #   axis(1, at=melodies, labels=abbreviate(melodies, 4), las=2)
  #   dev.off()
  # }

  library(qgraph)
  jpeg("distancePlots/distanceGraph1.jpg", width=3000, height=3000, unit='px')
  qgraph(distanceMatrix, layout="spring", vsize=3)
  dev.off()

  library(igraph)
  jpeg("distancePlots/distanceGraph2.jpg", width=3000, height=3000, unit='px')
  g <- graph_from_adjacency_matrix(distanceMatrix, mode="undirected", weighted = T)
  V(g)$label <- abbreviate(melodies, 4)
  V(g)$label.cex <- 5
  plot(g, edge.width=E(g)$weight)
  dev.off()
  calcMetrics(g)
  
  distanceMatrix
}