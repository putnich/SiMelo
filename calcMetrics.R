calcMetrics <- function(g) {
  metrics <- list(
    "Number of vertices" = vcount(g),
    "Number of edges" = ecount(g),
    "Graph density" = graph.density(as.undirected(g, mode =
                                                         "mutual")),
    "Connectivity" = vertex.connectivity(as.undirected(g, mode =
                                                                  "collapse")),
    "Diameter" = diameter(g),
    "Farthest edge" = paste(
      farthest_vertices(g)$vertices[1],
      farthest_vertices(g)$vertices[2],
      sep = " <--> "),
    "Transitivity" = transitivity(g),
    "Betweeness centrality" = centralization.betweenness(g, directed = F)$centralization,
    "Degree centrality" = centralization.degree(g, mode = "all")$centralization
  )
  print("-----------------------------------------------------------")
  print("Graph metrics")
  print("-----------------------------------------------------------")
  print(metrics)
}