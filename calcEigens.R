calcEigens <- function(matricesList, model = "basic") {
  eigensList <- list()
  if(model == "markov") {
    d <- diag(degree(matricesList[[i]]))
    p <- t(d)%*%matricesList[[i]] #Transition matrix - Markov matrix
    phi <- solve(p - diag(ncol(p)), c(rep(0, ncol(p))))
    g <-sqrt(phi) %*% (diag(ncol(p)) - p) %*% (1/sqrt(phi))
    eigensList[i] <- eigen(g)
  }
  else {
    len <- length(matricesList)
    for(i in 1:len) {
      e <- eigen(matricesList[[i]]%*%t(matricesList[[i]])) #Calculating eigenvalues for A*A' matrix
      eigensList[[i]] <- e$values
    }
  }
  eigensList
}