run <- function() {
  source(paste(getwd(), "/main/run.R", sep=""))
  source(paste(getwd(), "/utils/similarity/eigenSimilarity.R", sep=""))
  source(paste(getwd(), "/utils/similarity/levensteinSimilarity.R", sep=""))
  source(paste(getwd(), "/utils/similarity/cosineSimilarity.R", sep=""))
  source(paste(getwd(), "/utils/similarity/traminer.R", sep=""))
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


  #Discrete sequence similarity analysis using TraMineR package
  traminer(melodiesTable)


  #Analysing melodies using Levenshtein distance
  levensteinSimilarity(melodiesTableStrings)
  
  #Analysing melodies using cosine similarity
  cosineSimilarity(melodiesTableStrings)
  
}
