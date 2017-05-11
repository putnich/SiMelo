# Melodies Recognition

The aim of this project is to test various mathematical and text methods on melodies similarity. 
Two main groups of methods are used:
* eigen vector of A*A' matrix, as proposed by (Cvetkovic, Manojlovic 2013)
  * of simple directed graphs
  * of multigraphs
  * of multigraphs, using sum of note durations
  * of multigraphs, using average of note durations
* string similarity
  * with Levenstein (edit) distance
  * with cosine distance
  * with length of longest subsequence measure
  * with optimal matching method
  * with qgrams method
  * with Jaccard coefficient
  

The dataset contains 17 instances, with compositions by Bach versus Mozart, as their style and epoch is opposed in music theory and practise. 

All melodies were transcribed to letter-duration notation. Also, the sheets are for violin, not for pianos, since accords make computability less possible. Sheets can be found at (8notes, 2017). 

With the distances of melodies from dataset, clustering was a good choise for recognition analysis, since the prediction is not possible without bigger dataset.

Three clustering methods were used:
  * Hierarchical clustering
  * K-means clustering
  * K-medoids clustering

The overall conclusion is that simple directed graphs are good at clustering by author, while LCS method can quite accurately divide melodies by author, type, tact and style.

# Data
Melodies are divided as follows:
  * Melodies by Bach:
   * two preludes
   * two minuets
   * one aria
   * one sonata
   * one concert
  * Melodies by Mozart:
    * two minuets
# Distance
## Details on eigen vector methods
### Simple directed graphs
The melodies from loaded dataset are tranformed into 0-1 adjacency matrices (function makeMatrices), whose cells contain 1 (if note is connected with another note), or 0 (if it is not connected). Then the eigenvector is calculated for every matrix A\*A' using calcEigens function. Later on, the distance matrix is produced, containing Euclidean distances between each pair of melodies (calcDistances function). 
### Multigraphs
The melodies are transformed into adjacency matrices, whose cells contain number of edges (connections) between each note (makeMatrices function). Eigenvectors are calculated also by using A\*A' matrix (calcEigens function), and Euclidean distances between those vectors (calcDistances function). 
### Multigraphs with cumulative durations
Besides melodies, for the calculation is used Duration column from the same dataset. The melodies are transformed into adjacency matrices, whose cells contain sum of durations of notes, i.e. weight of edges (makeMatrices function). Eigenvectors are calculated by using A\*A' matrix (calcEigens function), and Euclidean distances between those vectors (calcDistances function). 
### Multigraphs with average durations
The melodies are transformed into adjacency matrices, whose cells contain average of durations of notes, i.e. sum of durations divided by number of connections between notes (makeMatrices function). Eigenvectors are calculated by using A\*A' matrix (calcEigens function), and Euclidean distances between those vectors (calcDistances function). 
## Details on string similarity methods
### Levenstein edit distance
The levensteinSimilarity function is used. The edit distance is calculated between all melodies in dataset, and the distance matric is generated for later clustering. 
### Cosine distance
The melodies are converted into melody-note matrix, containing frequences of notes in a melody. Those freequency vectors are then used to calculate cosine distance between all melodies, while generating distance matrix for later clustering.
### LCS method
### OM method
### Qgrams
### Jaccard coefficient

# Clustering
## Hierarchical clustering
## K-means
## K-medoids

# Results

| Method                        | Hierarchical                         | K-means                      | K-medoids                    |
| ------------------------------| ------------------------------------ |------------------------------|------------------------------|
| Eigen simple graph | Two groups, by author | Not significant | Two groups, by author |
| Eigen multigraph | Three group, one is Mozart, second is Bach and latter preludes by Bach| Four group, one is Mozart, other three groups only by Bach (?)|Two groups, one is Mozart, remaining is mixed |
| Eigen multigraph with cumulative durations | Not significant | Not significant | Not significant |
| Eigen multigraph with average durations | Not significant | Not significant | Not significant |
| Levenstein distance | One is Mozart, second is G major scale, third are two Ppreludes, remaining not significant | Not significant | One is Mozart, remaining is mixed |
| Cosine distance | Not significant | Not significant | Not significant |
| LCS  | One is Bach in G-dur, second is Bach, third is one melody in C major in dataset, third is two minuets by Mozart, fourth is one in E minor, fifth is G major, remaining not significant | Not significant | Not significant |
| OM | Not significant | Not significant | Not significant |
| Qgrams| Not significant | Not significant | Not significant |
| Jaccard coefficient | Not significant | Not significant | Not significant |
