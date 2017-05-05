run <- function() {
  source(paste(getwd(), "/main/run.R", sep=""))
  source(paste(getwd(), "/utils/similarity/eigenSimilarity.R", sep=""))
  source(paste(getwd(), "/utils/similarity/stringSequenceSimilarity.R", sep=""))
  source(paste(getwd(), "/utils/distance/calcDistances.R", sep=""))
  source(paste(getwd(), "/utils/clusters/calcClusters.R", sep=""))
  source(paste(getwd(), "/utils/graphs/makeGraphs.R", sep=""))
  source(paste(getwd(), "/utils/metrics/calcMetrics.R", sep=""))
  main()
}

main <- function() {
  
  melodiesTable <- read.csv(paste(getwd(), "/data/melodies.csv", sep=''), sep=";") #Reading melodies from a .csv file
  melodiesTableStrings <- read.csv(paste(getwd(), "/data/melodiesStrings.csv", sep=''), sep=";")
  
  
  #Analysing melodies using simple graph
  eigenSimilarity(melodiesTable, "simple")


  #Analysing melodies using multigraph
  eigenSimilarity(melodiesTable, "multi")


  #Analysing melodies using multigraph with cumulative durations
  eigenSimilarity(melodiesTable, "duration")

  #Analysing melodies using multigraph with average durations
  eigenSimilarity(melodiesTable, "duration-average")


  #Analysing melodies using Levenshtein distance
  stringSequenceSimilarity(melodiesTableStrings, "levenstein")
  
  #Analysing melodies using cosine similarity
  stringSequenceSimilarity(melodiesTableStrings, "cosine")
  
  #Analysing melodies using longest common subsequence method
  stringSequenceSimilarity(melodiesTableStrings, "LCS")
  
  #Analysing melodies using optimal matching method
  stringSequenceSimilarity(melodiesTableStrings, "OM")
  
  #Analysing melodies using qgrams
  stringSequenceSimilarity(melodiesTableStrings, "qgrams")
  
}
