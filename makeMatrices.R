makeMatrices <- function(melodiesList, durationsList, type) {
  matricesList <- list()
  len <- length(melodiesList)
  for(i in 1:len) {
    m <- matrix(rep(0, 144), ncol = 12, nrow = 12, 
                dimnames = list(c("c", "c#", "d", "d#", "e", "f", "f#", "g", "g#", "a", "a#", "h"), 
                                c("c", "c#", "d", "d#", "e", "f", "f#", "g", "g#", "a", "a#", "h")))
    vLen <- length(melodiesList[[i]])
    
    for(j in 1:vLen) {
      if(j == vLen) next() 
      else {
        if(type == "simple") {
          if(m[melodiesList[[i]][j], melodiesList[[i]][j+1]] != 1) m[melodiesList[[i]][j], melodiesList[[i]][j+1]] = 1
          else next()
        }
        if(type == "multi") m[melodiesList[[i]][j], melodiesList[[i]][j+1]] = m[melodiesList[[i]][j], melodiesList[[i]][j+1]] + 1
        if(type == "duration") m[melodiesList[[i]][j], melodiesList[[i]][j+1]] = m[melodiesList[[i]][j], melodiesList[[i]][j+1]] + as.numeric(durationsList[[i]][j])
      }
    }
    matricesList[[i]] <- m
  }
  matricesList
}