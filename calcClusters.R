calcClusters <- function(melodiesTable, distanceMatrix, eigensList) {
  library(cluster)
  if(!(dir.exists("clusterPlots"))) {
    dir.create("clusterPlots")
  }
  else {
    unlink("clusterPlots",recursive = T)
    dir.create("clusterPlots")
  }
  
  jpeg("clusterPlots/dendrogram.jpg", width=1000, height=1000, unit='px')
  dendrogram <- hclust(dist(do.call(rbind, eigensList)), method="ward.D")
  plot(dendrogram, labels = rownames(distanceMatrix))
  dev.off()
  clusterCut <- cutree(dendrogram, 2)
  jpeg("clusterPlots/dendrogramCut.jpg", width=1000, height=1000, unit='px')
  plot(clusterCut, xaxn="n")
  axis(1, at=melodiesTable$Melody.name, labels=abbreviate(melodiesTable$Melody.name, 4), las=2)
  dev.off()
  colNames <- melodiesTable$Melody.name
  author <- melodiesTable$Author
  cH <- vector()
  len <- length(clusterCut)
  for(i in 1:len) cH[i] <- clusterCut[i][[1]]
  print("-----------------------------------------------------------")
  print("Hierarchical clustering")
  print("-----------------------------------------------------------")
  print(as.data.frame(list("Melody number" = colNames, "Author" = author, "Predicted cluster number" = cH)))

  km <- kmeans(do.call(rbind, eigensList), 2)
  jpeg("clusterPlots/kMeans.jpg", width=1000, height=1000, unit='px')
  plot(km$cluster, xaxn="n")
  axis(1, at=melodiesTable$Melody.name, labels=abbreviate(melodiesTable$Melody.name, 4), las=2)
  dev.off()
  cKm <- km$cluster
  len <- length(colNames)
  print("-----------------------------------------------------------")
  print("K-means clustering")
  print("-----------------------------------------------------------")
  print(as.data.frame(list("Melody number" = colNames, "Author" = author,"Predicted cluster number" = cKm)))
  
  print("-----------------------------------------------------------")
  print("K-medoids clustering")
  print("-----------------------------------------------------------")
  mCluster <- pam(do.call(rbind, eigensList), 2)
  cM <- mCluster$clustering
  plot(mCluster)
  print("Medoids:")
  print(mCluster$medoids)
  print("Silhouette info:")
  for(i in 1:length(mCluster$silinfo$clus.avg.widths)) {
    print(paste("Average silhouette width per cluster ", i, " = [", mCluster$silinfo$clus.avg.widths[[i]], "]", sep=""))
  }
  print(paste("Average silhouette width = [",mCluster$silinfo$avg.width, "]", sep=""))
  print(as.data.frame(list("Melody number" = colNames, "Author" = author, "Predicted cluster number" = cM)))
}









