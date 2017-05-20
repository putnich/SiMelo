# Melodies Recognition

The aim of this project was to examine the effectiveness of various mathematical and string-based methods for computing similarity of melodies. In particular, Eigen vectors of different types of graphs were used, as well as several string distance measures. Melodies have been transformed into letter notation, so that graphs could be easily constructed. A sequence of notes is understood as a string of letters, each letter representing one note, which enabled us to use the existing methods for computing string sequence similarities. We found that the eigenvector method for simple directed graphs has done clustering precisely by the author, while longest common subsequence, one of the string methods, has differentiated melodies by the author and other characteristics, such as the scale that was used and type of melody (concert, menuet, aria etc). Besides, the hierarchical clustering method proved to be the most accurate one, as shown in the following.

# Data

The dataset contains 17 instances, with compositions by Bach and Mozart. These composers were chosen as their style and epoch differ significantly both in music theory and practice. 

All melodies were transcribed to letter-duration notation. Also, the sheets are for violin, not for pianos, since accords make computability less possible.

The included melodies are as follows, with scale specified:
  * Melodies by Bach:
    * Prelude from Suite no. 1 for unaccompanied cello - C major
    * Air on G-string - A major
    * Menuet from French Suite no. 3 - a minor
    * Aria from Goldberg Variations - G major
    * Bist Du Bei Mir - D major
    * Arioso from Cantata - G major
    * Prelude no. 1 from 48 Preludes and Fugues - D major
    * Minuet - G major
    * Sonata no. 5 BWV 1034 - D major
    * Violin Concerto BWV 1056 -  f# minor
  * Melodies by Mozart:
    * Minuet from Don Giovanni - D major
    * Minuet -  D major
    * German Dance no. 1 K 605 -  A major
    * Laudate Dominum - G major
    * March of the Priest from The Magic Flute - A major
    * Oh Isis Und Osiris - G major
    * Lacrimosa Dies Illa - e minor
   
    
# Distance

Two main groups of methods are used:
* Eigen vector of A*A' matrix, as proposed in [2]
  * of simple directed graphs
  * of multigraphs
  * of multigraphs, using sum of note durations
  * of multigraphs, using average of note durations
* String similarity based on
  * the Levenstein (edit) distance
  * the cosine distance
  * the longest common subsequence measure
  * the optimal matching method
  * the qgrams method
  * the Jaccard coefficient

## Eigen vector methods
A melody can be given in the form of graph, where the adjacency matrix can be calculated, and then the eigenvector of this matrix can be determined. A representative example is the melody Ode to Joy by Beethoven, and the procedure is shown below:

![alt text](https://github.com/putnich/MelodiesRecognition/blob/master/misc/odetojoy.PNG)

The melody is transformed into a graph, whose nodes are notes, transcribed to letter notation.

![alt text](https://github.com/putnich/MelodiesRecognition/blob/master/misc/odetojoygraph.PNG)

Now the adjacency matrix can be easily determined:

![alt text](https://github.com/putnich/MelodiesRecognition/blob/master/misc/odetojoymatrix.PNG)

The eigenvector of this matrix is (0.0389, 1, 1.2696, 3.0536, 6.6379) and it can be used as a signature for melody, thus for database idexing purposes [1], as it is a single melodic dot in 12-dimensional space of melodies. In this implementation, the eigenvector of A\*A' matrix is used, as aforementioned.

### Simple directed graphs
The melodies from the loaded dataset are transformed into 0-1 adjacency matrices (function makeMatrices), with cells having value 1 (if a note is connected with another note), or 0 (if it is not connected). Then the eigenvector is calculated for every matrix A\*A' using calcEigens function. Later on, the distance matrix is produced, containing Euclidean distances between each pair of melodies (calcDistances function).  

### Multigraphs
The melodies are transformed into adjacency matrices, with cells containing the number of edges (connections) between each pair of notes (makeMatrices function). Eigenvectors are calculated also by using the A\*A' matrix (calcEigens function), followed by the computation of Euclidean distances between those vectors (calcDistances function). 

### Multigraphs with cumulative durations
Besides melodies, this calculation method uses the Duration column from the same dataset. The melodies are transformed into adjacency matrices, with cells containing the sum of durations of notes, i.e. weight of edges (makeMatrices function). Eigenvectors are calculated by using the A\*A' matrix (calcEigens function), and Euclidean distances between those vectors are computed (calcDistances function). 

### Multigraphs with average durations
The melodies are transformed into adjacency matrices, with each cell containing the average of durations of notes, i.e. sum of durations divided by the number of connections between two notes (makeMatrices function). Eigenvectors are calculated by using A\*A' matrix (calcEigens function), and Euclidean distances between those vectors are computed (calcDistances function). 

## Details on string similarity methods

### Levenstein edit distance
The levensteinSimilarity function is used to calculate edit distance between all pairs of melodies in the dataset, and the distance matrix is generated for later clustering. 

### Cosine distance
The cosineSimilarity function is used. The melodies are converted into a melody-note matrix, containing frequencies of notes in a melody. Those frequency vectors are then used to calculate cosine distance between all melody pairs, thus generating a distance matrix for later clustering. The lsa R package was used for cosine distance calculations (it will be described below).

### LCS method
The computation is done using the LCSSimilarity function. The distances between melodies are calculated as the length of the longest common subsequence of the melodies. Melodies are transformed into sequences of notes, and then the distance is calculated, using transformation cost matrix, whose values are constant (since the operations of inserting, deleting or substituting a note in a melody equally affect the melody). Distances are later used for clustering. The computation is done using the TraMineR package (described below).

### OM method
The OM distance is computed using the OMSimilarity function. Similarly to the LCS method, melodies are transformed into sequences of notes, an then the distance matrix is generated using optimal matching algorithm and the cost matrix. This method also relies on the TraMineR package.

### Qgrams
The qgramsSimilarity function is used. Here the distances are frequencies of term (of various length, that user defines) in a document, i.e. note pairs in melodies. The output is document-term matrix, later used for clustering. The function uses the stringdist R package.  
### Jaccard coefficient
The jaccardSimilarity function is used to compute the Jaccard coefficient, or index, which measures similarity of strings as sets. It is the cardinality of the intersection of two sets divided by the union of those sets, in this case of strings. 

![alt text](https://wikimedia.org/api/rest_v1/media/math/render/svg/eaef5aa86949f49e7dc6b9c8c3dd8b233332c9e7)

# Clustering
Since the dataset contains just 17 instances, the decision was to use clustering as the method for analysing melodies, not the prediction. The aim of clustering was to observe if the melodies would be grouped by some melody attribute, for example by author, scale or other. 
Three clustering methods were used:
  * Hierarchical clustering
  * K-means clustering
  * K-medoids clustering

The R package cluster was used for clustering.

## Hierarchical clustering
The hierarchicalClustering function performs agglomerative hierarchical clustering using the Ward's method. The function also prints melodies from each cluster. The dendrogram of clustering is plotted.

## K-means
The kmeansCLustering function is uded. The clustering error is calculated for groups two to ten, and the Elbow plot is shown to the user, so that the right value of k can be chosen. After the user choses the k, the algorithm prints the clustering for the right k, with names of melodies, authors and the cluster the melody belongs. 

## K-medoids
The kmedoidsClustering function is used. Similarly to k-means, the average silhouette width is calculated for groups two to ten, and the plot of those widths is shown to the user, so that the right value of k can be chosen. After the user choses the right k, the algorithm prints the clustering for the k, with names of melodies, authors and the cluster the melody belongs. 

# Results
The results of running different clustering methods are summarized in the table below. Term "Not explicable" was used in the table to state that the clustering produced results that could not be explained by the known attributes of the examined melodies (e.g. author, type of melody or some other feature).

| Method                        | Hierarchical                         | K-means                      | K-medoids                    |
| ------------------------------| ------------------------------------ |------------------------------|------------------------------|
| Eigen simple graph | Two groups, by author | Not explicable | Two groups, by author |
| Eigen multigraph | Three group, one is Mozart, second is Bach and latter preludes by Bach| Four group, one is Mozart, other three groups only by Bach (?)|Two groups, one is Mozart, remaining is mixed |
| Eigen multigraph with cumulative durations | Not explicable | Not explicable | Not explicable |
| Eigen multigraph with average durations | Not explicable | Not explicable | Not explicable |
| Levenstein distance | One is Mozart, second is G major scale, third are two Preludes, remaining not significant | Not explicable | One is Mozart, remaining is mixed |
| Cosine distance | Not explicable | Not explicable | Not explicable |
| LCS  | One is Bach in G-dur, second is Bach, third is one melody in C major in dataset, third is two minuets by Mozart, fourth is one in E minor, fifth is G major, remaining not significant | Not explicable | Not explicable |
| OM | Not explicable | Not explicable | Not explicable |
| Qgrams| Not explicable | Not explicable | Not explicable |
| Jaccard coefficient | Not explicable | Not explicable | Not explicable |

Here not significant means the clustering was random, meaning not grouped by any common music characteristic.

# Conclusion
According to the table above, the Eigen vector method for simple graphs gives a signature for the author of the melody. There hierarchical clustering and k-medoids clustering were successful in correctly clustering melodies by author. The results are given in the form of dendrogram:
![alt text](https://github.com/putnich/MelodiesRecognition/blob/master/misc/dendrogram-eigen-simple.jpg)

Here, in the first cluster, five out of six melodies were composed by Mozart, while in the second cluster nine out of 11 melodies were authored by Bach.  

Also, the multigraph method with hierarchical clustering has divided melodies by author, further isolating the group of Preludes by Bach, but it is logical since that is the completely different type of melodies. Unfortunately, it does not give a further clustering by type of melody, so it can be understood as a more sensitive method, but not more accurate than simple graph method. 

Among string methods, the LCS method provided most interesting results as it divided melodies by scale that was used and the type. That was expected, since the usage of notes is the one that determines the type of melody, and a specific usage belongs to a scale. But still, there are melodies whose membership in a cluster cannot be explained.

![alt text](https://github.com/putnich/MelodiesRecognition/blob/master/misc/dendrogram-string-LCS.jpg)

Here we have the first cluster containing melodies by Bach in G major (Minuet, Aria and Arioso). The second cluster cannot be explained. The third, which is the composition named Prelude no. 1 for unaccompanied cello is isolated, probably since it is the only melody in the dataset written in C major scale. The fourth cluster is miced A major, G major, but it is not fully clear. The fifth cluster are menuets from Mozart, as a melodic type. Lacrimosa, as sixth, is isolated case, since it is the only one in the dataset written in e minor scale. And the last cluster (Laudate dominum, Oh Isis und Osiris) is in G major. It can be concluded that this method is very sensitive to types and scales. It would probably cluster the data of the larger proportions well by melody type and scale. 

The remaining methods have not proven to be good at clustering with the dataset of this small proportions. 

When considering clustering methods, overall, k-means has not proven to be a good choice for clustering, either because of the small dataset, or because of the random choice of centroids in the melodic space. K-medoids has slightly better clustered the data than k-means, since the melodies are used as centroids. The hierarchical clustering was the method with the most fruitful results. 

For further analysis of efficiency of these methods a larger dataset is required.

# R Packages

## TraMineR
This package is generally used for analysing sequences of states, i.e. discrete sequence data. It was developed at the Institute of Demography and Socioeconomics at the University of Geneva, Switzerland, under the name Life Trajectory Miner for R. The main purpose of the package is to analyse social sciences data, especially in describing family trajectories, as the name tells us [5].
It can be found [here](http://traminer.unige.ch/)

## stringdist
The package was designed to calculate various string distances, such as Levenstein distance, Optimal matching, qgrams etc. The aim was to create an uniform interface of string distance methods which are usually scattered around various R packages (as native adist which was used in this project for calculating Levenstein distance) [4]. It can be found at [this Github project](https://github.com/markvanderloo/stringdist).

## lsa
This package provides support for latent semantic analysis, which is a technique used in natural language processing, where the relationships between the documents and terms are examined. [3] 
It can be found [here](https://cran.r-project.org/web/packages/lsa/index.html)

# References
1. Alberto Pinto, Reinier H. van Leuken, M. Fatih Demirci, Frans Wiering, Remco C. Veltkamp. Indexing music collections through graph spectra. Department of Information and Computer Sciences, Universiteit Utrecht (The Netherlands) and Dipartimento di Informatica e Comunicazione, Universita degli Studi di Milano (Italy). Austiran Computer Society OCG, 2007. 
2. Cvetković Dragoš, Manojlović Vesna. Spectral recognition of music melodies. SYM-OP-IS 2013. Univerzitet u Beogradu, Fakultet organizacionih nauka. 2013. 269-270
3. CRAN R project lsa, https://cran.r-project.org/web/packages/lsa/index.html , date accessed: 12.05.2017.
4. Github stringdist project, https://github.com/markvanderloo/stringdist, date accessed: 12.05.2017.
5. TraMineR, http://traminer.unige.ch/ , date accessed: 12.05.2017.
