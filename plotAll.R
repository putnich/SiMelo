plotAll <- function(distanceMatrix) {
  len <- dim(distanceMatrix)[1]
  # for(i in 1:len) {
  #   plot(distanceMatrix[,i])
  #   png(paste("plot", i, ".png", sep=""))
  #   dev.off()
  # }
  library(qgraph)
  jpeg("graph.jpg", width=3000, height=3000, unit='px')
  qgraph(distanceMatrix, layout="spring", vsize=3)
  dev.off()
  
  dendrogram <- hclust(dist(distanceMatrix), method="ward.D")
  plot(dendrogram)
}