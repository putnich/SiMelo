levensteinSimilarity <- function(melodiesTableStrings) {
  len <- length(melodiesTableStrings$Melody)
  
  melodies <- melodiesTableStrings$Melody
  melodiesNames <- melodiesTableStrings$Melody.name
  authors <- melodiesTableStrings$Author
  
  distanceMatrix <- calcDistances(melodies, melodiesNames, authors, NULL, NULL)

  calcClusters(melodiesNames, authors, distanceMatrix, "string", "hierarchical", "string")
  # calcClusters(melodiesNames, authors, distanceMatrix, "string", "k-means")
  calcClusters(melodiesNames, authors, distanceMatrix, "string", "k-medoids")
  
}