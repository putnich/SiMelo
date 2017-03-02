calcClusters <- function(melodiesTable, distanceMatrix, eigensList) {
  #libraries
  library(cluster)
  
  #creating folder for cluster plots
  if(!(dir.exists("clusterPlots"))) {
    dir.create("clusterPlots")
  }
  else {
    unlink("clusterPlots",recursive = T)
    dir.create("clusterPlots")
  }
  
  #Hierarchical clustering
  jpeg("clusterPlots/dendrogram.jpg", width=1000, height=1000, unit='px')
  dendrogram <- hclust(dist(do.call(rbind, eigensList)), method="ward.D") #dendrogram for eigenvalues
  plot(dendrogram, labels = rownames(distanceMatrix))
  dev.off()
  clusterCut <- cutree(dendrogram, 2) #dendrogram cut
  jpeg("clusterPlots/dendrogramCut.jpg", width=1000, height=1000, unit='px')
  plot(clusterCut, xaxn="n")
  axis(1, at=melodiesTable$Melody.name, labels=abbreviate(melodiesTable$Melody.name, 4), las=2) #matching labels to abbreviated melodies' names
  dev.off()
  colNames <- melodiesTable$Melody.name
  author <- melodiesTable$Author
  cH <- vector()
  len <- length(clusterCut)
  for(i in 1:len) cH[i] <- clusterCut[i][[1]] #accessing predicted cluster numbers
  print("-----------------------------------------------------------")
  print("Hierarchical clustering")
  print("-----------------------------------------------------------")
  print(as.data.frame(list("Melody number" = colNames, "Author" = author, "Predicted cluster number" = cH)))

  #K-means clustering for different k
  kmeansss <- list()
  for(k in 2:10) {
    km <- kmeans(do.call(rbind, eigensList), k)
    jpeg("clusterPlots/kMeans.jpg", width=1000, height=1000, unit='px')
    plot(km$cluster, xaxn="n")
    axis(1, at=melodiesTable$Melody.name, labels=abbreviate(melodiesTable$Melody.name, 4), las=2)
    dev.off()
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
  plot(2:10, unlist(kmeansss), type="b") #Elbow method
  
  #Kmedoids clustering for different k, with silhouette info
  kmedoidssw <- list()
  for(k in 2:10) {
    print("-----------------------------------------------------------")
    print("K-medoids clustering")
    print(paste("Number of clusters ", k, sep=""))
    print("-----------------------------------------------------------")
    mCluster <- pam(do.call(rbind, eigensList), k)
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
  plot(2:10, unlist(kmedoidssw), type="b") #Plotting average silhouette widths per number of clusters
}









