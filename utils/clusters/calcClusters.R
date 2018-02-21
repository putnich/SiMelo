calcClusters <- function(melodiesNames, authors, distanceMatrix, dataType, method) {
  
  #libraries
  library(cluster)
  
  #creating folders for cluster plots
  if(!(dir.exists("results/"))) {
    dir.create("results/")
  }
  if(!(dir.exists("results/plots/"))) {
    dir.create("results/plots/")
  }
  if(!(dir.exists("results/plots/dendrograms/"))) {
    dir.create("results/plots/dendrograms/")
  }
  
  clusterData <- matrix()
  if(startsWith(dataType, "qgramsMatrix")) {
      clusterData <- dist(distanceMatrix)
  } #Input is document-term matrix
  else {
    clusterData <- as.dist(distanceMatrix) 
  } #Input is distance matrix
  
  #Hierarchical clustering
  if(method == "hierarchical") {
    hierarchicalClustering(melodiesNames, authors, clusterData, dataType)
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

hierarchicalClustering <- function(melodiesNames, authors, clusterData, dataType) {
  melodiesNames <- abbreviate(melodiesNames, 30, named=F)
  print("-----------------------------------------------------------")
  print("Hierarchical clustering:")
  print("-----------------------------------------------------------")
  
  #Writing dendrogram to the file
  jpeg(paste("results/plots/dendrograms/dendrogram-", dataType, ".jpg", sep=""), width=1000, height=1000, unit='px')
  dendrogram <- hclust(clusterData, method="ward.D") #Ward method is used
  plot(dendrogram, labels = melodiesNames)
  dev.off()
  
  plot(dendrogram) #Plotting for user
  #Cluster cut - melodies are divided into groups
  print("Dendrogram file can be also found at data/plots/dendrograms")
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
  print(as.data.frame(list("Melody number" = unlist(melodiesNames), 
                           "Author" = unlist(authors), "Predicted cluster number" = cH)))
  
}

kmeansClustering <- function(colNames, author, clusterData) {
 
  
  print("-----------------------------------------------------------")
  print("K-means:")
  print("-----------------------------------------------------------")
  
  kmeansss <- list()
  
  for(i in 2:10) {
    set.seed(5)
    km <- kmeans(clusterData, i)
    kmeansss[[i]] <- km$tot.withinss
  }
  
  plot(2:10, unlist(kmeansss), type="b") #Elbow method
  
  k <- readline("What is the k for k-means? ")
  if((as.numeric(k) < 2)| (as.numeric(k) > 10)) {
    print("k must be between 2 and 10")
    return()
  }
  
  set.seed(5)
  kMeans <- kmeans(clusterData, k)

  print("-----------------------------------------------------------")
  print("K-means clustering")
  print(paste("Number of clusters ", k, sep=""))
  print("-----------------------------------------------------------")
  print(as.data.frame(list("Author" = author,"Predicted cluster number" = kMeans$cluster)))
  
  print(paste("Total within-cluster sum of squares: ", kMeans$tot.withinss, sep=""))
  
}

kmedoidsClustering <- function(colNames, author, clusterData) {
  
  print("-----------------------------------------------------------")
  print("K-medoids:")
  print("-----------------------------------------------------------")
  
  kmedoidssw <- list()
  
  for(i in 2:10) {
    set.seed(5)
    mCluster <- pam(clusterData, i)
    kmedoidssw[i] <- mCluster$silinfo$avg.width
  
  }
  
  plot(2:10, unlist(kmedoidssw), type="b") #Plotting average silhouette widths per number of clusters
  
  k <- readline("What is the k for k-medoids? ")
  if((as.numeric(k) < 2)| (as.numeric(k) > 10)) {
    print("k must be between 2 and 10")
    return()
  }
  
  set.seed(5)
  kMedoids <- pam(clusterData, k)
  print("-----------------------------------------------------------")
  print("K-medoids clustering")
  print(paste("Number of clusters ", k, sep=""))
  print("-----------------------------------------------------------")
  print("Medoids:")
  print(kMedoids$medoids)
  print("Silhouette info:")
  
  for(j in 1:length(kMedoids$silinfo$clus.avg.widths)) {
    print(paste("Average silhouette width per cluster ", j, " = [", kMedoids$silinfo$clus.avg.widths[[j]], "]", sep=""))
  }
  
  print(paste("Average silhouette width = [",kMedoids$silinfo$avg.width, "]", sep=""))
  print(as.data.frame(list("Author" = author, "Predicted cluster number" = kMedoids$clustering)))
}


