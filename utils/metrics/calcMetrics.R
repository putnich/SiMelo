calcMetrics <- function(g, name) {
  
  v <- V(g)$name
  
  metrics <- list(
    "Number of vertices" = vcount(g),
    "Number of edges" = ecount(g),
    "Graph density" = graph.density(as.undirected(g, mode = "mutual")),
    "Diameter" = diameter(g),
    "Farthest edge" = paste(v[[farthest_vertices(g)$vertices[1]]], v[[farthest_vertices(g)$vertices[2]]], 
                            sep = " <--> "),
    "In-degrees of nodes" = degree(g, v = V(g), mode = "in"),
    "Out-degrees of nodes" = degree(g, v = V(g), mode = "out"),
    "All degrees of nodes" = degree(g, v = V(g), mode = "all")
  )
  
  print("-----------------------------------------------------------")
  print(paste("Graph metrics for graph: ", name, sep=""))
  print("-----------------------------------------------------------")
  print(metrics)
}