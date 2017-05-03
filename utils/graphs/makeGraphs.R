makeGraphs <- function(matricesList) {
  
  #libraries
  require(scales)
  library(igraph)
  
  #Creating directories for graph plots
  if(!(dir.exists("graphPlots"))) {
    dir.create("graphPlots")
  }
  else {
    unlink("graphPlots",recursive = T)
    dir.create("graphPlots")
  }
  
  #Plotting melody graph for each melody
  len <- length(matricesList)
  stronglyConnected <- c()
  graphs <- list()
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
    stronglyConnected[i] <- is.connected(g, mode = "strong")
    dev.off()
  }
  
  if(all(stronglyConnected) == T) {
    print("All directed graphs are strongly connected, switching to finite Markov chain (Perron-Frobenius theorem)")
    #further procedure to be implemented
  }
}