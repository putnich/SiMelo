run <- function() {
  source(paste(getwd(), "/main/run.R", sep=""))
  source(paste(getwd(), "/utils/similarity/eigenSimilarity.R", sep=""))
  source(paste(getwd(), "/utils/similarity/stringSequenceSimilarity.R", sep=""))
  source(paste(getwd(), "/utils/distance/calcDistances.R", sep=""))
  source(paste(getwd(), "/utils/clusters/calcClusters.R", sep=""))
  source(paste(getwd(), "/utils/graphs/makeGraphs.R", sep=""))
  source(paste(getwd(), "/utils/metrics/calcMetrics.R", sep=""))
  source(paste(getwd(), "/utils/input/readMelody.R", sep=""))
  main()
}

main <- function() {
  
  #Reading melodies from a .csv file
  #melodiesTable <- read.csv(paste(getwd(), "/data/melodies.csv", sep=''), sep=";") 
  #melodiesTableStrings <- read.csv(paste(getwd(), "/data/melodiesStrings.csv", sep=''), sep=";")
  melodiesTable <- readMelody(list("data/music/bach", "data/music/mozart"))
  #Analysing melodies with eigenvalues:
  #1. using simple graph
  eigenSimilarity(melodiesTable, "simple")


  #2. using multigraph
  eigenSimilarity(melodiesTable, "multi")


  #3. using multigraph with cumulative durations
  eigenSimilarity(melodiesTable, "duration")

  #4. using multigraph with average durations
  eigenSimilarity(melodiesTable, "duration-average")

  
  #Analysing melodies using string metrics:
  #1. using Levenshtein distance
  stringSequenceSimilarity(melodiesTableStrings, "levenstein")
  
  #2. cosine similarity
  stringSequenceSimilarity(melodiesTableStrings, "cosine")
  
  #3. longest common subsequence method
  stringSequenceSimilarity(melodiesTableStrings, "LCS")
  
  #4. optimal matching
  stringSequenceSimilarity(melodiesTableStrings, "OM")
  
  #5. qgrams
  stringSequenceSimilarity(melodiesTableStrings, "qgrams")
  
  #6. Jaccard coefficient
  stringSequenceSimilarity(melodiesTableStrings, "jaccard")
  
}
