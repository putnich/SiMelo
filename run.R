run <- function() {
  source(paste(getwd(), "/main.R", sep=""))
  source(paste(getwd(), "/makeMatrices.R", sep=""))
  source(paste(getwd(), "/calcEigens.R", sep=""))
  source(paste(getwd(), "/calcDistances.R", sep=""))
  source(paste(getwd(), "/makeGraphs.R", sep=""))
  source(paste(getwd(), "/calcMetrics.R", sep=""))
  source(paste(getwd(), "/calcClusters.R", sep=""))
  main(paste(getwd(), "/melodies.csv", sep=''))
}