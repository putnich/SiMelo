# Melodies Recognition

The aim of this project is to test various mathematical and text methods on melodies similarity. 
Two main groups of methods are used:
1. eigen vector of A*A' matrix, as proposed by (Cvetkovic, Manojlovic 2013)
  i. of simple directed graphs
  ii. of multigraphs
  iii. of multigraphs, using sum of note durations
  iv. of multigraphs, using average of note durations
2. string similarity
  i. with Levenstein (edit) distance
  ii. with cosine distance
  iii. with length of longest subsequence measure
  iv. with optimal matching method
  v. with qgrams method
  vi. with Jaccard coefficient
  
 The dataset used contains 17 instances, with compositions by Bach versus Mozart, as their style and epoch is opposed in music theory and practise. 
 All melodies were transcribed to letter-duration notation. Also, the sheets are for violin, not for pianos, since accords make 
  computability less possible. Sheets can be found at (8notes, 2017). 
With the distances of melodies from dataset, clustering was a good choise forrecognition analysis, since the prediction is not posible without bigger dataset.
Three clustering methods were used:
  1. Hierarchical clustering
  2. K-means clustering
  3. K-medoids clustering
The overall conclusion is that simple directed graphs are good at clustering by author, while LCS method can quite accurately divide melodies by type, tact and style.

# Data
Melodies are divided as follows:
  1. Melodies by Bach:
   * two preludes
   * two minuets
   * one aria
   * one sonata
   * one concert
  2. Melodies by Mozart:
    * two minuets
# Distance
## Details on eigen vector methods
### Simple directed graphs
### Multigraphs
### Multigraphs with cumulative durations
### Multigraphs with average durations
## Details on string similarity methods
### Levenstein edit distance
### Cosine distance
### LCS method
### OM method
### Qgrams
### Jaccard coefficient

# Clustering
## Hierarchical clustering
## K-means
## K-medoids

# Results

| Method                                        |Hierarchical   |K-means       | K-medoids   |
| --------------------------------------------- | ------------- |------------- |-------------|
| Eigen simple graph                            |               |              |             |
| Eigen multigraph                              |               |              |             |
| Eigen multigraph with cumulative durations    |               |              |             |
| Eigen multigraph with average durations       |               |              |             |
| Levenstein distance                           |               |              |             |
| Cosine distance                               |               |              |             |
| LCS                                           |               |              |             |
| OM                                            |               |              |             |
| Qgrams                                        |               |              |             |
| Jaccard coefficient                           |               |              |             |
