makeMatrices <- function(melodiesList) {
  matricesList <- list()
  len <- length(melodiesList)
  for(i in 1:len) {
    m <- matrix(c(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0), 
                ncol = 12, nrow = 12, dimnames = list(c("c", "c#", "d", "d#", "e", "f", "f#", "g", "g#", "a", "a#", "h"), 
                                                      c("c", "c#", "d", "d#", "e", "f", "f#", "g", "g#", "a", "a#", "h")));
    vLen <- length(melodiesList[[i]])
    for(j in 0:vLen-1) {
      if(i == vLen-1) {
        m[melodiesList[[i]][vLen-1], melodiesList[[i]][0]] <- m[melodiesList[[i]][vLen-1], melodiesList[[i]][0]] + 1
      }
      else m[melodiesList[[i]][j], melodiesList[[i]][j+1]] <- m[melodiesList[[i]][j], melodiesList[[i]][j+1]] + 1
    }
    matricesList[[i]] <- m
  }
  matricesList
}