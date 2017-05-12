# Melodies Recognition

The aim of this project is to test various mathematical and text methods on melodies similarity. For that purpose the eigen vectors of different types of graphs were used, but also the string distance measures. The melodies are tranformed into letter notation, so the graphs can be easily constructed. The sequence of notes is understood as a string, and the notes written in letters as its characters, which gives us an introduction to the approach of string sequence similarities. It has been observed among the data in this project that the eigenvector method for simple directed graphs has done clustering precisely by author, while longest common subsequence, as one of the string methods, has differentiated melodies by author and other characteristics, such as the scale that was used and type of melody (concert, menuet, aria etc). Besides, the hierarchical clustering method was the most accurate one, as shown in the following lines.

# Data

The dataset contains 17 instances, with compositions by Bach versus Mozart, as their style and epoch is opposed in music theory and practise. 

All melodies were transcribed to letter-duration notation. Also, the sheets are for violin, not for pianos, since accords make computability less possible.

Melodies are divided as follows, with scale specified:
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
* eigen vector of A*A' matrix, as proposed by Cvetkovic and Manojlovic, see references
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
## Eigen vector methods
The melody can be given in a form of the graph, where the adjacency matrix can be calculated, and then the eigenvector of the same matrix. The representative example is the melody Ode to Joy by Bethoven, and the procedure is shown below:

![alt text](https://github.com/putnich/MelodiesRecognition/blob/master/data/misc/odetojoy.PNG)

The melody is transformed into graph, whose nodes are notes, transcribed to letter notation.

![alt text](https://github.com/putnich/MelodiesRecognition/blob/master/data/misc/odetojoygraph.PNG)

Now the adjacency matric can be easily determined:

![alt text](https://github.com/putnich/MelodiesRecognition/blob/master/data/misc/odetojoymatrix.PNG)

The eigenvector of this matrix is (0.0389,1,1.2696,3.0536,6.6379) and it can be used as a signature for melody (see ), and it is a single melodic dot in 12-dimensional space of melodies. In this implementation, the eigenvector of A\*A' matrix is used, as aforementioned.
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
The cosineSimilarity function is used. The melodies are converted into melody-note matrix, containing frequences of notes in a melody. Those freequency vectors are then used to calculate cosine distance between all melodies, while generating distance matrix for later clustering. The lsa pakage was used for cosine distance calculations, and it will be described in the following lines.
### LCS method
The LCSSimilarity function is used. The distances between melodies are calculated as the length of the longest common subsequence of the melodies. Melodies are transformed into sequences, and then the distance is calculated, using tranformation cost matrix, whose values are constant (since the operations of inserting, deleting or substituting note in melody equally affect the melody). Distances are later used for clustering. The package used was TraMineR, described in the following lines.
### OM method
The OMSimilarity function is used. Similarly to LCS method, melodies are tranformed into sequences, an then the distance matrix is generated using optimal matching algorithm and the cost matrix. The package used was TraMineR, described in the following lines.
### Qgrams
The qgramsSimilarity function is used. Here the distances are frequencies of term (of various length, that user defines) in a document, i.e. note pairs in melodies. The output is document-term matrix, later used for clustering. The stringdist package was used. 
### Jaccard coefficient
The jaccardSimilarity function is used. Jaccard coefficient, or index, measures similarity of strings as sets. It is the cardinality of intersection divided by union of set, in this case of strings. 

![alt text](https://wikimedia.org/api/rest_v1/media/math/render/svg/eaef5aa86949f49e7dc6b9c8c3dd8b233332c9e7)

# Clustering
Since the dataset contains just 17 instances, the decission was to use clustering as method for analysing melodies, not the prediction. The aim of clustering was to observe if the melodies would be grouped by some melody attribute, for example by author, scale or other. 
Three clustering methods were used:
  * Hierarchical clustering
  * K-means clustering
  * K-medoids clustering

The package cluster was used for clustering.

## Hierarchical clustering
The hierarchicalClustering function is used. Agglomerative hierarchical clustering was the HC type, using Ward method. The cluster cut is also implemented, that prints melodies in the cut cluster. The dendrogram of clustering is plotted.
## K-means
The kmeansCLustering function is uded. There user can chose the k, maximum number of clusters desired. Then the algortithm prints all the clustering, with the plot of within cluster sum of squares (Elbow method), that is used to determine the real number of clusters. 
## K-medoids
The kmedoidsClustering function is used. Similarly to k-means, user choses the maximum number of clusters. The algorithm does the clustering while printing maximum silhouette width of clusters, used to finally chose the real number of clusters. 
# Results
The results of running the program can be summarized as below:

| Method                        | Hierarchical                         | K-means                      | K-medoids                    |
| ------------------------------| ------------------------------------ |------------------------------|------------------------------|
| Eigen simple graph | Two groups, by author | Not significant | Two groups, by author |
| Eigen multigraph | Three group, one is Mozart, second is Bach and latter preludes by Bach| Four group, one is Mozart, other three groups only by Bach (?)|Two groups, one is Mozart, remaining is mixed |
| Eigen multigraph with cumulative durations | Not significant | Not significant | Not significant |
| Eigen multigraph with average durations | Not significant | Not significant | Not significant |
| Levenstein distance | One is Mozart, second is G major scale, third are two Preludes, remaining not significant | Not significant | One is Mozart, remaining is mixed |
| Cosine distance | Not significant | Not significant | Not significant |
| LCS  | One is Bach in G-dur, second is Bach, third is one melody in C major in dataset, third is two minuets by Mozart, fourth is one in E minor, fifth is G major, remaining not significant | Not significant | Not significant |
| OM | Not significant | Not significant | Not significant |
| Qgrams| Not significant | Not significant | Not significant |
| Jaccard coefficient | Not significant | Not significant | Not significant |

Here not significant means the clustering was random, meaning not grouped by any common music characteristic.

# Conclusion
From the table above it can be concluded that eigen vector method for simple graphs gives a signature for the author of the melody. There hierarchical clustering and k-medoids clustering was successful at correctly clustering by author. The results are given in a form of dendrogram:
![alt text](https://github.com/putnich/MelodiesRecognition/blob/master/data/misc/dendrogram-eigen-simple.jpg)
Also, the multigraph method with hierarchical clustering has divided melodies by author, further isolating the group of Preludes of Bach, but it is logical since that is the completely different type of melodies. Unfortunatelly, it does not give a further clustering by type of melody, so it can be understood as a more sensitive method, but not more accurate then simple graph method. 

Among string methods, the LCS method has mostly interesting divided melodies by scale that was used and the type. That was expected, since the usage of notes is the one that determines the type of melody, and that specific usage belongs to a scale. But still, there are melodies whose membership in a cluster cannot be explained.

The remaining methods have not proven to be good at clustering with the dataset of these small proportions. 

When about clustering methods, overall, k-means has not proven to be a good choise for clustering, either because of the small dataset, or because of the random choise of centroids in the melodic space. K-medoids has slightly better clustered the data then k-means, since the melodies are used as centroids. The hierarchical clustering was the metod with the most fruitful results. 

For the further analysis of efficiency of these methods the larger dataset is requiered.

# Packages

## TraMineR
This package is generally used for analysing the sequences of states, i.e. discrete sequence data. It was developed at the Institute of Demography and Socioeconomics at the University of Geneva, Switzerland, with the name Life Trajectory Miner for R. The main purpose of the package is to analyse social sciences data, especially in describing family trajectories, as the name tells us. It can be found [here](http://traminer.unige.ch/)

## stringdist
The package was designed to calculate various string distances, such as Levenstein distance, Optimal matching, qgrams etc. The aim was to create an uniform interface of string distance methods which are usually scattered around various R packages (as native adist which was used in this project for calculating Levenstein distance). It can be found at [this Github project](https://github.com/markvanderloo/stringdist).

## lsa
This package provides latent semantic utilities, which is the technique used in natural language processing, where the relationships between the documents and terms are observed. It can be found [here](https://cran.r-project.org/web/packages/lsa/index.html)

# References
1. Cvetković Dragoš, Manojlović Vesna. Spectral recognition of music melodies. SYM-OP-IS 2013. Univerzitet u Beogradu, Fakultet organizacionih nauka. 2013. 269-270
2. CRAN R project lsa, https://cran.r-project.org/web/packages/lsa/index.html , date accessed: 12.05.2017.
3. TraMineR, http://traminer.unige.ch/ , date accessed: 12.05.2017.
4. Github stringdist project, https://github.com/markvanderloo/stringdist, date accessed: 12.05.2017.
