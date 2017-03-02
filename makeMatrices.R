makeMatrices <- function(melodiesList, flag = "simple") {
  matricesList <- list()
  len <- length(melodiesList)
  for(i in 1:len) {
    m <- matrix(rep(0, 144), ncol = 12, nrow = 12, 
                dimnames = list(c("c", "c#", "d", "d#", "e", "f", "f#", "g", "g#", "a", "a#", "h"), 
                                c("c", "c#", "d", "d#", "e", "f", "f#", "g", "g#", "a", "a#", "h")))
    vLen <- length(melodiesList[[i]])
    
    #Creating 0-1 adjacency matrix
    for(j in 1:vLen) {
      if(j == vLen) {
        if(flag == "multi") m[melodiesList[[i]][vLen], melodiesList[[i]][1]] = m[melodiesList[[i]][vLen], melodiesList[[i]][1]] + 1
        else m[melodiesList[[i]][vLen], melodiesList[[i]][1]] = 1
      }
      else {
        if(flag == "multi") m[melodiesList[[i]][j], melodiesList[[i]][j+1]] = m[melodiesList[[i]][j], melodiesList[[i]][j+1]] + 1
        else m[melodiesList[[i]][j], melodiesList[[i]][j+1]] = 1
      }
    }
    matricesList[[i]] <- m
  }
  matricesList
}