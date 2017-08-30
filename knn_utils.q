// Lib version
\d .knn

// Euclidean Distance Calculator
apply_dist_eucl:{[d;t] flip `class`dst!(exec class from d;sqrt sum each {x*x} t -/: flip value flip value d)};

// Manhattan Distance Calculator
apply_dist_manh:{[d;t] flip `class`dst!(exec class from d; sum each abs t -/: flip value flip value d)};

apply_dist: apply_dist_manh;

// Function get_nn
// Given a k parameter and a table with at least a class lable and distance column
// returns a table representing the k entries with smaller distance.
// Works using apply_dist output.
//
// Param k numeric integer
// Param d table
// 
// Returns table
get_nn:{[k;d] select class,dst from k#`dst xasc d};

// Function predict
// Given a k parameter and a table with at least a class lable and distance column
// returns a table representing the k entries with smaller distance.
//
// Param x table
// 
// Returns table
predict:{1#select Prediction:class from x where ((count;i)fby class)=max(count;i)fby class};

// Function test_harness
// Given a k parameter, training_set and a validation set (if multinstance, pass with each), 
// it runs a validation benchmark. Returns list of tables of t lenght. 
//
// Param d table training set
// Param t table validation set
// Param k integer k value
// 
// Returns table
test_harness:{[d;k;t] select Test:t`class, Hit:Prediction=' t`class from
  predict get_nn[k] apply_dist[d] raze delete class from t };

// Function test_harness
// Optimized for benchmarking multiple values of K 
// Param k list of indexes - can be lenght 1 (enlist n)
test_harness:{[d;k;t] R:apply_dist[d] raze delete class from t; 
  select Test:t`class, Hit:Prediction=' t`class,k from raze predict each k#\:`dst xasc R}

explain:{ 
  -1 "Usage: .knn.test_harness[training_set;k_value;] each 0!test_set"; 
  -1 "Usage: .knn.test_harness_op[training_set;enlist 1;] each 0!test_set"; 
  -1 "Usage: .knn.test_harness_op[training_set;1+til 10;] each 0!test_set"; 
  -1 "Usage: .knn.predict .knn.get_nn[k_value;] .knn.apply_dist[training_set;]raze delete class from test_instance";};

\d .