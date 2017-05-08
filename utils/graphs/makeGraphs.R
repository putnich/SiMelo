makeGraphs <- function(melodiesNames, matricesList, type) {
  
  #libraries
  require(scales)
  library(igraph)
  
  #Creating directories for graph plots
  if(!(dir.exists("data/plots/graphPlots/"))) {
    dir.create("data/plots/graphPlots/")
  }
  
  if(!(dir.exists(paste("data/plots/graphPlots/", type, sep="")))) {
    dir.create(paste("data/plots/graphPlots/", type, sep=""))
  }
  
  #Plotting melody graph for each melody
  len <- length(matricesList)
  graphs <- list()
  for(i in 1:len) {
    degrees <- colSums(matricesList[[i]])
    g <- graph_from_adjacency_matrix(matricesList[[i]], mode="directed")
    jpeg(paste(paste("data/plots/graphPlots/", type, sep=""), "/gplot-", melodiesNames[[i]], ".jpg", sep=""), width=4000, height=3000, unit='px')
    V(g)$color <- sample(rainbow(12),12,replace=FALSE)
    V(g)$label.color = "black"
    V(g)$label.cex <- rescale(degrees, to = c(10,20))
    E(g)$width <- 4
    E(g)$color <- alpha("gray", rescale(
      degrees, to = c(0.3, 1)))
    plot(g, vertex.size=rescale(degrees, to = c(10,20)),  layout=layout.fruchterman.reingold(g, niter=10000))
    
    #Calculating graph metrics
    calcMetrics(g, paste(type, melodiesNames[[i]], sep="-")) 
    
    dev.off()
  }
  
}
