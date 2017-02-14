calcEigens <- function(matricesList) {
  eigensList <- list()
  len <- length(matricesList)
  for(i in 1:len) {
    print(matricesList[[i]]%*%t(matricesList[[i]]))
    e <- eigen(matricesList[[i]]%*%t(matricesList[[i]]))
    eigensList[[i]] <- e$values
  }
  eigensList
}