main <- function(path) {
  l<-list()
  bytes <- readBin(path, raw(), file.info(path)$size);
  notesChar <- rawToChar(bytes);
  notes <- strsplit(notesChar, "\\r\\n")
  melodiesList <- strsplit(notes[[1]], "[ ]");
  print("-----------------------------------------------------------")
  print("Melodies list:")
  print("-----------------------------------------------------------")
  print(melodiesList)
  matricesList <- makeMatrices(melodiesList)
  makeGraphs(matricesList)
  print("-----------------------------------------------------------")
  print("Adjacency matrices (A) for melodies, respectively:")
  print("-----------------------------------------------------------")
  print(matricesList)
  eigensList <- calcEigens(matricesList)
  print("-----------------------------------------------------------")
  print("Matrices spectra, respectively")
  print("-----------------------------------------------------------")
  print(eigensList)
  print("-----------------------------------------------------------")
  print("Euclidean distances, respectively:")
  print("-----------------------------------------------------------")
  distanceMatrix <- calcDistances(eigensList)
  
}