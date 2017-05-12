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
  
The melody can be represented as graph, where the adjacency matrix can be calculated, and then the eigenvector of the same matrix. The representative example is the melody Ode to Joy by Bethoven, and the procedure is shown below:

![alt text](https://github.com/putnich/MelodiesRecognition/blob/master/data/misc/odetojoy.PNG)

The melody is transformed into graph, whose nodes are notes, transcribed to letter notation.

![alt text](https://github.com/putnich/MelodiesRecognition/blob/master/data/misc/odetojoygraph.PNG)

Now the adjacency matric can be easily determined:

![alt text](https://github.com/putnich/MelodiesRecognition/blob/master/data/misc/odetojoymatrix.PNG)

The eigenvector of this matrix is (0.0389,1,1.2696,3.0536,6.6379) and it can be used as a signature for melody, and it is a single melodic dot in 12-dimensional space of melodies. In this implementation, the eigenvector of A\*A' matrix is used, as aforementioned.

With the distances of melodies from dataset, clustering was a good choise for recognition analysis, since the prediction is not possible without bigger dataset.

Three clustering methods were used:
  * Hierarchical clustering
  * K-means clustering
  * K-medoids clustering

The overall conclusion is that simple directed graphs are good at clustering by author, while LCS method can quite accurately divide melodies by author, type, and style. The hierarchical clustering method was the most accurate one.

# Data

The dataset contains 17 instances, with compositions by Bach versus Mozart, as their style and epoch is opposed in music theory and practise. 

All melodies were transcribed to letter-duration notation. Also, the sheets are for violin, not for pianos, since accords make computability less possible. Sheets can be found at (8notes, 2017). 

Melodies are divided as follows:
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
The distances between melodies are calculated as the length of the longest commom subsequence of the melodies. Melodies are transformed into sequences, and then the distance is calculated, using tranformation cost matrix, whose values are constant (since the operations of inserting, deleting or substituting note in melody equally affect the melody). Distances are later used for clustering.
### OM method
Similarly to LCS method, melodies are tranformed into sequences, an then the distance matrix is generated using optimal matching algorithm and the cost matrix. 
### Qgrams
Here the distances are frequencies of term (of various length, that user defines) in a document, i.e. note pairs in melodies. The output is document-term matrix, later used for clustering.
### Jaccard coefficient
Jaccard coefficient, or index, measures similaritiy of strings as sets. It is the cardinality of intersection divided by union of set, in this case of strings. 
![alt text](https://wikimedia.org/api/rest_v1/media/math/render/svg/eaef5aa86949f49e7dc6b9c8c3dd8b233332c9e7)
# Clustering
Since the dataset contains just 17 instances, the decission was to use clustering as method for analysing melodies, not the prediction. The aim of clustering was to observe if the melodies would be grouped by some melody attribute, for example by author, scale or other.  
## Hierarchical clustering
Agglomerative hierarchical clustering was used, using Ward method. The cluster cut is also implemented, that prints melodies in the cut cluster. The dendrogram of clustering is plotted.
## K-means
The user can chose the k, maximum number of clusters desired. Then the algortithm prints all the clustering, with the plot of within cluster sum of squares (Elbow method), that is used to determine the real number of clusters. 
## K-medoids
Similarly to k-means, user choses the maximum number of clusters. Tthe algorithm does the clustering while printing maximum silhouette width of clusters, used to finally chose the real number of clusters. 
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

# Conclusion
K-means has proven no to be a good choise for clustering, either because of the small dataset, or because of the random choise of centroid in the melodic space. K-medoids has slightly better clustered the data then k-means, since the melodies are used as centroids. The hierarchical clustering was the metod with the most fruitful results. 
