calcClusters <- function(melodyNames, authors, data, dataType, method) {
  
  #libraries
  library(cluster)
  
  #creating folder for cluster plots
  if(!(dir.exists("data/plots/"))) {
    dir.create("data/plots/")
  }
  if(!(dir.exists("data/plots/dendrograms/"))) {
    dir.create("data/plots/dendrograms/")
  }
  
  clusterData <- matrix()
  if(startsWith(dataType, "qgramsMatrix")) clusterData <- dist(data) #Input is document-term matrix
  else clusterData <- as.dist(data) #Input is distance matrix
  
  #Hierarchical clustering
  if(method == "hierarchical") {
    hierarchicalClustering(melodyNames, authors, clusterData, dataType)
  }
  
  #K-means clustering
  if(method == "k-means") {
    kmeansClustering(melodyNames, authors, clusterData)
  }

  #K-medoids clustering
  if(method == "k-medoids") {
    kmedoidsClustering(melodyNames, authors, clusterData)
  }
  
}

hierarchicalClustering <- function(colNames, author, clusterData, dataType) {
  
  print("-----------------------------------------------------------")
  print("Hierarchical clustering:")
  print("-----------------------------------------------------------")
  
  #Writing dendrogram to the file
  jpeg(paste("data/plots/dendrograms/dendrogram-", dataType, ".jpg", sep=""), width=1000, height=1000, unit='px')
  dendrogram <- hclust(clusterData, method="ward.D") #Ward method is used
  plot(dendrogram, labels = rownames(colNames))
  dev.off()
  
  #Cluster cut - melodies are divided into groups
  cut <- readline("What is the cut number for dendrogram? ")
  if(cut <= 1) {
    print("Must be greater then 1")
    cut <- 2
  }
  clusterCut <- cutree(dendrogram, cut) #Dendrogram cut - see dendrogram.jpg for cut number
  cH <- vector()
  len <- length(clusterCut)
  for(i in 1:len) cH[i] <- clusterCut[i][[1]] #Accessing predicted cluster numbers
  print("-----------------------------------------------------------")
  print("Hierarchical clustering")
  print("-----------------------------------------------------------")
  print(as.data.frame(list("Melody number" = colNames, "Author" = author, "Predicted cluster number" = cH)))
  
}

kmeansClustering <- function(colNames, author, clusterData) {
 
  k <- readline("What is the k for k-means? ")
  if(k <= 1 || k > length(colNames)) {
    print("k must be between 2 and number of melodies in the dataset")
    k <- 5
  }
  print("-----------------------------------------------------------")
  print("K-means:")
  print("-----------------------------------------------------------")
  kmeansss <- list()
  for(i in 2:k) {
    set.seed(5)
    km <- kmeans(clusterData, i)
    cKm <- km$cluster
    len <- length(colNames)
    print("-----------------------------------------------------------")
    print("K-means clustering")
    print(paste("Number of clusters ", i, sep=""))
    print("-----------------------------------------------------------")
    print(as.data.frame(list("Author" = author,"Predicted cluster number" = cKm)))
    kmeansss[i] <- km$tot.withinss
    print(paste("Total within-cluster sum of squares: ", kmeansss[i], sep=""))
    print(paste("The ratio of between-cluster sum of squares and total sum of squares: ", km$betweenss/km$totss, sep=""))
  }
  plot(2:k, unlist(kmeansss), type="b") #Elbow method
}

kmedoidsClustering <- function(colNames, author, clusterData) {
  
  k <- readline("What is the k for k-medoids? ")
  if(k <= 1 || k > length(colNames)) {
    print("k must be between 2 and number of melodies in the dataset")
    k <- 5
  }
  print("-----------------------------------------------------------")
  print("K-medoids:")
  print("-----------------------------------------------------------")
  kmedoidssw <- list()
  for(i in 2:k) {
    print("-----------------------------------------------------------")
    print("K-medoids clustering")
    print(paste("Number of clusters ", i, sep=""))
    print("-----------------------------------------------------------")
    set.seed(5)
    mCluster <- pam(clusterData, i)
    cM <- mCluster$clustering
    # plot(mCluster$clustering)
    print("Medoids:")
    print(mCluster$medoids)
    print("Silhouette info:")
    for(j in 1:length(mCluster$silinfo$clus.avg.widths)) {
      print(paste("Average silhouette width per cluster ", j, " = [", mCluster$silinfo$clus.avg.widths[[j]], "]", sep=""))
    }
    kmedoidssw[i] <- mCluster$silinfo$avg.width
    print(paste("Average silhouette width = [",mCluster$silinfo$avg.width, "]", sep=""))
    print(as.data.frame(list("Author" = author, "Predicted cluster number" = cM)))
  }
  plot(2:k, unlist(kmedoidssw), type="b") #Plotting average silhouette widths per number of clusters
}


