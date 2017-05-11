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
| --------------------------------------------- | -------------------------- |-------------------------- |--------------------------|
| Eigen simple graph|The data is divided in two groups, by author|Not significant|The data is divided in two groups, by author|
| Eigen multigraph                              |Data is divided in three group, one group containing melodies by Mozart, second by Bach and latter containing preludes of Bach, as composition of different style to the previous ones|Data is divided in four group, one group containing melodies by Mozart, other three groups only by Bach, but later differentiation among them has no uniform explanation|Data is divided into two groups, one containing only melodies by Mozart, second is mixed|
| Eigen multigraph with cumulative durations    | Not significant |Not significant|Not significant|
| Eigen multigraph with average durations       | Not significant |Not significant|Not significant|
| Levenstein distance                           |One cluster contains only melodies by Mozart, second contains melodies in G major scale, third contains two Preludes, remaining clustering not significant|Not significant |One cluster containing only melodies by Mozart, other is mixed|
| Cosine distance                              | Not significant |Not significant|Not significant|
| LCS                                         |One cluster contains three melodies by Bach written in G-dur, second two melodies by Bach, third is isolated with one melody, but it is logical, since it is the only one written in C major in dataset, third cluster contains two minuets by Mozart, fourth is isolated case, since the one melody it contains is uniquely in dataset written in E minor, fifth cluster contains two melodies written in G major, remaining clustering is not significant |Not significant|Not significant|
| OM                                            | Not significant |Not significant|Not significant|
| Qgrams                                        | Not significant |Not significant|Not significant|
| Jaccard coefficient                           | Not significant |Not significant|Not significant|
