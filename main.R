main <- function(path) {
  melodiesList <- list()
  melodiesTable <- read.csv(path, sep=",") #Reading melodies from a .csv file
  len <- length(melodiesTable$Melody.name)
  for(i in 1:len) {
    melodiesList[i] <- strsplit(as.character(melodiesTable$Melody[[i]]), "[ ]")
  }
  print("-----------------------------------------------------------")
  print("Melodies list:")
  print("-----------------------------------------------------------")
  print(melodiesList)
  
  matricesList <- makeMatrices(melodiesList) #Creating adjacency matrices from musical notes sequence
  print("-----------------------------------------------------------")
  print("Adjacency matrices (A) for melodies, respectively:")
  print("-----------------------------------------------------------")
  print(matricesList)
  
  eigensList <- calcEigens(matricesList) #Calculating eigenvalues from matrices
  print("-----------------------------------------------------------")
  print("Matrices spectra, respectively")
  print("-----------------------------------------------------------")
  print(eigensList)
  
  print("-----------------------------------------------------------")
  print("Euclidean distances, respectively:")
  print("-----------------------------------------------------------")
  distanceMatrix <- calcDistances(melodiesTable$Melody.name, eigensList) #Creating distance matrix using eigenvalues
 
   print("-----------------------------------------------------------")
  print("Cluster analysis:")
  print("-----------------------------------------------------------")
  
  calcClusters(melodiesTable, distanceMatrix, eigensList) #Calculating clusters using hierarchical clustering, kmeans and kmedoids methods
  
  # makeGraphs(matricesList) #Creating graphs for each melody
  
}