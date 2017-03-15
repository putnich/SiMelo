calcMetrics <- function(g) {
  metrics <- list(
    "Number of vertices" = vcount(g),
    "Number of edges" = ecount(g),
    "Graph density" = graph.density(as.undirected(g, mode =
                                                         "mutual")),
    "Diameter" = diameter(g),
    "Farthest edge" = paste(
      farthest_vertices(g)$vertices[1],
      farthest_vertices(g)$vertices[2],
      sep = " <--> ")
  )
  print("-----------------------------------------------------------")
  print("Graph metrics")
  print("-----------------------------------------------------------")
  print(metrics)
}