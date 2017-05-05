calcDistances <- function(melodies, melodiesNames, authors, eigensList, docTermMatrix, method = " ") {
  
  #libraries
  library(qgraph)
  library(igraph)
  library(TraMineR)
  
  #creating distance matrix
  len <- length(melodiesNames)
  
  distanceMatrix <- matrix(rep(0, len*len), ncol = len, nrow = len, dimnames = list(melodiesNames, melodiesNames))
  
  if(method == "LCS") {
    sequences <- seqdef(melodies)
    ccost <- seqsubm(sequences, method = "CONSTANT")
    m <- seqdist(seq, method, sm=ccost, norm=T)
    distanceMatrix <- matrix(m, ncol=ncol(m), nrow=nrow(m), dimnames=list(melodiesNames, melodiesNames))
  }
  
  else {
    if(method == "OM") {
      sequences <- seqdef(melodies)
      ccost <- seqsubm(sequences, method = "CONSTANT")
      m <- seqdist(seq, method, sm=ccost, norm=T)
      distanceMatrix <- matrix(m, ncol=ncol(m), nrow=nrow(m), dimnames=list(melodiesNames, melodiesNames))
    }
    else {
      for(i in 1:len) {
        for(j in 1:len) {
          if(is.null(docTermMatrix)) {
            if(is.null(eigensList)) {
              d <- distanceMatrix[i,j] <- distanceMatrix[j,i] <- adist(melodies[i], melodies[j]) #Levenstein edit distance
            }
            else d <- distanceMatrix[i,j] <- distanceMatrix[j,i] <- dist(rbind(eigensList[[i]], eigensList[[j]]))
          } 
          else  d <- distanceMatrix[i,j] <- distanceMatrix[j,i] <- lsa::cosine(docTermMatrix[i,], docTermMatrix[j,]) #cosine distance
          
          distanceMatrix[i,i] <- 0
          if(i>j || i==j) {
            next()
          }
          else {
            print(paste("Distance between melodies ", i, " and ", j, " is:", d, sep = " "))
          }
        }
      }
      
    }
  }
  
  
  # #creating folder for distance plots
  # if(!(dir.exists("distancePlots"))) {
  #   dir.create("distancePlots")
  # }
  # else {
  #   unlink("distancePlots",recursive = T)
  #   dir.create("distancePlots")
  # }
  # 
  # 
  # jpeg("distancePlots/distanceGraph1.jpg", width=5000, height=5000, unit='px') #plotting distance matrix graph using qgraph
  # qgraph(distanceMatrix, layout="spring", vsize=3)
  # dev.off()
  # 
  # 
  # jpeg("distancePlots/distanceGraph2.jpg", width=3000, height=3000, unit='px') #ploting distance matrix graph using igraph with edge thickness equal to distance between nodes
  # g <- graph_from_adjacency_matrix(distanceMatrix, mode="undirected", weighted = T)
  # V(g)$label <- abbreviate(melodies, 4)
  # V(g)$label.cex <- 5
  # plot(g, edge.width=E(g)$weight)
  # dev.off()
  # 
  # calcMetrics(g) #calculating graph metrics for graph from distance matrix
  
  distanceMatrix
}