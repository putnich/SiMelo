calcClusters <- function(melodiesTable, distanceMatrix, eigensList) {
  #libraries
  library(TraMineR)
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
  colNames <- melodiesTable$Melody.name
  author <- melodiesTable$Author
  jpeg("clusterPlots/dendrogram.jpg", width=1000, height=1000, unit='px')
  dendrogram <- hclust(dist(do.call(rbind, eigensList)), method="ward.D") #dendrogram for eigenvalues
  plot(dendrogram, labels = rownames(distanceMatrix))
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

  #K-means clustering for different k
  kmeansss <- list()
  for(k in 1:10) {
    set.seed(5)
    km <- kmeans(do.call(rbind, eigensList), k)
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
  plot(1:10, unlist(kmeansss), type="b") #Elbow method
  
  #Kmedoids clustering for different k, with silhouette info
  kmedoidssw <- list()
  for(k in 2:6) {
    print("-----------------------------------------------------------")
    print("K-medoids clustering")
    print(paste("Number of clusters ", k, sep=""))
    print("-----------------------------------------------------------")
    set.seed(5)
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
  plot(2:6, unlist(kmedoidssw), type="b") #Plotting average silhouette widths per number of clusters
  
  #TraMineR
  #Matching with OM method
  seq <- seqdef(melodiesTable,3)
  ccost <- seqsubm(seq, method = "CONSTANT")
  sd <- seqdist(seq, method="OM", sm=ccost)
  rownames(sd) <- melodiesTable$Melody.name
  colnames(sd) <- melodiesTable$Melody.name
  cl <- agnes(sd, diss=T, method="ward")
  jpeg("clusterPlots/dendrogramForTraMineR-OM.jpg", width=1000, height=1000, unit='px')
  plot(cl)
  dev.off()
  #Matching with LCP method
  seq <- seqdef(melodiesTable,3)
  ccost <- seqsubm(seq, method = "CONSTANT")
  sd <- seqdist(seq, method="LCP", sm=ccost)
  rownames(sd) <- melodiesTable$Melody.name
  colnames(sd) <- melodiesTable$Melody.name
  cl <- agnes(sd, diss=T, method="ward")
  jpeg("clusterPlots/dendrogramForTraMineR-LCP.jpg", width=1000, height=1000, unit='px')
  plot(cl)
  dev.off()
  #Matching with RLCP method
  seq <- seqdef(melodiesTable,3)
  ccost <- seqsubm(seq, method = "CONSTANT")
  sd <- seqdist(seq, method="RLCP", sm=ccost)
  rownames(sd) <- melodiesTable$Melody.name
  colnames(sd) <- melodiesTable$Melody.name
  cl <- agnes(sd, diss=T, method="ward")
  jpeg("clusterPlots/dendrogramForTraMineR-RLCP.jpg", width=1000, height=1000, unit='px')
  plot(cl)
  dev.off()
  #Matching with LCS method
  seq <- seqdef(melodiesTable,3)
  ccost <- seqsubm(seq, method = "CONSTANT")
  sd <- seqdist(seq, method="LCS", sm=ccost)
  rownames(sd) <- melodiesTable$Melody.name
  colnames(sd) <- melodiesTable$Melody.name
  cl <- agnes(sd, diss=T, method="ward")
  jpeg("clusterPlots/dendrogramForTraMineR-LCS.jpg", width=1000, height=1000, unit='px')
  plot(cl)
  dev.off()
}









