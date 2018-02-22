# Code mostly based on example from http://www.vesnam.com/Rblog/transcribing-music-from-audio-files-2/

readMelody <- function(music) {
  
  library(tuneR)
  
  melodiesList <- list()
  melodiesNames <- list()
  melodiesAuthor <- list()
  len <- length(music)
  for(m in 1: len) {
    folder <- music[[m]]
    fname <- strsplit(folder,"/")
    filenames <- lapply(folder, list.files, recursive=T)
    
    for(i in 1:length(filenames[[1]])) {
      period <- periodogram(paste(folder, filenames[[1]][i], sep="/"), 4096)
      frequencies <- FF(period)
      frequencies <- na.omit(frequencies)
      notes <- noteFromFF(frequencies)
      
      n <- notenames(notes)
      n<-gsub(x=n, replacement="", pattern="'+")
      n<-gsub(x=n, replacement="", pattern=",+")
      n<-tolower(n)
      n<-gsub(x=n, replacement="h", pattern="b")
      
      melodiesList[[length(melodiesList)+1]] <- n
      melodiesNames[[length(melodiesNames)+1]] <- filenames[[1]][i]
      melodiesAuthor[[length(melodiesAuthor)+1]] <-  fname[[1]][3]
   }
  
  }
  melodiesTable <- list()
  melodiesTable$Melody <- melodiesList
  melodiesNames <- abbreviate(melodiesNames, 30, named=F)
  melodiesTable$Melody.name <- melodiesNames
  melodiesTable$Author <- melodiesAuthor
  melodiesTable
}