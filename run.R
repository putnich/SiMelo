run <- function() {
  source(paste(getwd(), "/main.R", sep=""))
  source(paste(getwd(), "/makeMatrices.R", sep=""))
  source(paste(getwd(), "/calcEigens.R", sep=""))
  source(paste(getwd(), "/calcDistances.R", sep=""))
  source(paste(getwd(), "/plotAll.R", sep=""))
  main(paste(getwd(), "/first.melodies", sep=''))
}