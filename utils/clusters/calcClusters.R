calcClusters <- function(melodyNames, authors, data, dataType, method, type=" ") {
  #libraries
  
  library(cluster)
  
  #creating folder for cluster plots
  if(!(dir.exists("data/plots/clusterPlots"))) {
    dir.create("data/plots/clusterPlots")
  }
  else {
    unlink("data/plots/clusterPlots",recursive = T)
    dir.create("data/plots/clusterPlots")
  }
  clusterData <- matrix()
  if(dataType == "eigen") clusterData <- dist(do.call(rbind, data))
  if(dataType == "cosine") clusterData <- dist(t(data))
  if(dataType == "string") clusterData <- as.dist(data)
  
  if(method == "hierarchical") {
    hierarchicalClustering(melodyNames, authors, clusterData, type)
  }
  
  if(method == "k-means") {
    kmeansClustering(melodyNames, authors, clusterData)
  }

  if(method == "k-medoids") {
    kmedoidsClustering(melodyNames, authors, clusterData)
  }
  
}

hierarchicalClustering <- function(colNames, author, clusterData, type) {
  #Hierarchical clustering
  
  print("-----------------------------------------------------------")
  print("Hierarchical clustering:")
  print("-----------------------------------------------------------")
  colNames <- melodiesTable$Melody.name
  author <- melodiesTable$Author
  jpeg(paste("data/plots/clusterPlots/dendrogram-", type, ".jpg", sep=""), width=1000, height=1000, unit='px')
  dendrogram <- hclust(clusterData, method="ward.D") #dendrogram for eigenvalues
  plot(dendrogram, labels = rownames(colNames))
  dev.off()
  # clusterCut <- cutree(dendrogram, 3) #dendrogram cut - see dendrogram.jpg for cut number
  # jpeg("clusterPlots/dendrogramCut.jpg", width=1000, height=1000, unit='px')
  # plot(clusterCut, xaxn="n")
  # axis(1, at=melodiesTable$Melody.name, labels=abbreviate(melodiesTable$Melody.name, 4), las=2) #matching labels to abbreviated melodies' names
  # dev.off()
  # cH <- vector()
  # len <- length(clusterCut)
  # for(i in 1:len) cH[i] <- clusterCut[i][[1]] #accessing predicted cluster numbers
  # print("-----------------------------------------------------------")
  # print("Hierarchical clustering")
  # print("-----------------------------------------------------------")
  # print(as.data.frame(list("Melody number" = colNames, "Author" = author, "Predicted cluster number" = cH)))
  
}

kmeansClustering <- function(colNames, author, clusterData) {
  #K-means clustering for different k
  
  print("-----------------------------------------------------------")
  print("K-means:")
  print("-----------------------------------------------------------")
  kmeansss <- list()
  for(k in 2:6) {
    set.seed(5)
    km <- kmeans(clusterData, k)
    cKm <- km$cluster
    len <- length(colNames)
    print("-----------------------------------------------------------")
    print("K-means clustering")
    print(paste("Number of clusters ", k, sep=""))
    print("-----------------------------------------------------------")
    print(as.data.frame(list("Melody number" = colNames, "Author" = author,"Predicted cluster number" = cKm)))
    kmeansss[k] <- km$tot.withinss
    print(paste("Total within-cluster sum of squares: ", km$tot.withinss, sep=""))
    print(paste("The ratio of between-cluster sum of squares and total sum of squares: ", km$betweenss/km$totss, sep=""))
  }
  plot(2:6, unlist(kmeansss), type="b") #Elbow method
}

kmedoidsClustering <- function(colNames, author, clusterData) {
  #Kmedoids clustering for different k, with silhouette info
  
  print("-----------------------------------------------------------")
  print("K-medoids:")
  print("-----------------------------------------------------------")
  kmedoidssw <- list()
  for(k in 2:6) {
    print("-----------------------------------------------------------")
    print("K-medoids clustering")
    print(paste("Number of clusters ", k, sep=""))
    print("-----------------------------------------------------------")
    set.seed(5)
    mCluster <- pam(clusterData, k)
    cM <- mCluster$clustering
    plot(mCluster)
    print("Medoids:")
    print(mCluster$medoids)
    print("Silhouette info:")
    for(i in 1:length(mCluster$silinfo$clus.avg.widths)) {
      print(paste("Average silhouette width per cluster ", i, " = [", mCluster$silinfo$clus.avg.widths[[i]], "]", sep=""))
    }
    kmedoidssw[k] <- mCluster$silinfo$avg.width
    print(paste("Average silhouette width = [",mCluster$silinfo$avg.width, "]", sep=""))
    print(as.data.frame(list("Melody number" = colNames, "Author" = author, "Predicted cluster number" = cM)))
  }
  plot(2:6, unlist(kmedoidssw), type="b") #Plotting average silhouette widths per number of clusters
}


