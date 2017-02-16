makeGraphs <- function(matricesList) {
  require(scales)
  library(igraph)
  if(!(dir.exists("graphPlots"))) {
    dir.create("graphPlots")
  }
  else {
    unlink("graphPlots",recursive = T)
    dir.create("graphPlots")
  }
  len <- length(matricesList)
  for(i in 1:len) {
    degrees <- colSums(matricesList[[i]])
    g <- graph_from_adjacency_matrix(matricesList[[i]], mode="undirected")
    jpeg(paste("graphPlots/gplot", i, ".jpg", sep=""), width=4000, height=3000, unit='px')
    V(g)$color <- sample(rainbow(12),12,replace=FALSE)
    V(g)$label.color = "black"
    V(g)$label.cex <- rescale(degrees, to = c(15,25))
    E(g)$width <- 4
    E(g)$color <- alpha("gray", rescale(
      degrees, to = c(0.3, 1)))
    plot(g, vertex.size=rescale(degrees, to = c(15,25)),  layout=layout.fruchterman.reingold(g, niter=10000))
    dev.off()
  }
}