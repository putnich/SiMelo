traminer <- function(melodiesTable) {
  library(TraMineR)
  #TraMineR
  #Matching with OM method
  seq <- seqdef(melodiesTable,3)
  ccost <- seqsubm(seq, method = "CONSTANT")
  sd <- seqdist(seq, method="OM", sm=ccost)
  rownames(sd) <- melodiesTable$Melody.name
  colnames(sd) <- melodiesTable$Melody.name
  cl <- agnes(sd, diss=T, method="ward")
  jpeg("data/plots/dendrogramForTraMineR-OM.jpg", width=1000, height=1000, unit='px')
  plot(cl)
  dev.off()
  #Matching with LCP method
  seq <- seqdef(melodiesTable,3)
  ccost <- seqsubm(seq, method = "CONSTANT")
  sd <- seqdist(seq, method="LCP", sm=ccost)
  rownames(sd) <- melodiesTable$Melody.name
  colnames(sd) <- melodiesTable$Melody.name
  cl <- agnes(sd, diss=T, method="ward")
  jpeg("data/plots/dendrogramForTraMineR-LCP.jpg", width=1000, height=1000, unit='px')
  plot(cl)
  dev.off()
  #Matching with RLCP method
  seq <- seqdef(melodiesTable,3)
  ccost <- seqsubm(seq, method = "CONSTANT")
  sd <- seqdist(seq, method="RLCP", sm=ccost)
  rownames(sd) <- melodiesTable$Melody.name
  colnames(sd) <- melodiesTable$Melody.name
  cl <- agnes(sd, diss=T, method="ward")
  jpeg("data/plots/dendrogramForTraMineR-RLCP.jpg", width=1000, height=1000, unit='px')
  plot(cl)
  dev.off()
  #Matching with LCS method
  seq <- seqdef(melodiesTable,3)
  ccost <- seqsubm(seq, method = "CONSTANT")
  sd <- seqdist(seq, method="LCS", sm=ccost)
  rownames(sd) <- melodiesTable$Melody.name
  colnames(sd) <- melodiesTable$Melody.name
  cl <- agnes(sd, diss=T, method="ward")
  jpeg("data/plots/dendrogramForTraMineR-LCS.jpg", width=1000, height=1000, unit='px')
  plot(cl)
  dev.off()
}