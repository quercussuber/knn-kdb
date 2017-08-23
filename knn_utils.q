// Lib version
\d .knn

// Euclidean Distance Calculator
apply_dist_eucl:{[d;t] select num,distance:p from sqrt sums each t {x*x:x-y}/: d};

// Manhattan Distance Calculator
apply_dist_manh:{[d;t] select num,distance:p from sums each abs t -/: d};

get_nn:{[k;d] select nn:num,distance from k#`distance xasc d};
predict:{1#select Prediction:nn from x where ((count;i)fby nn)=max (count;i)fby nn};

test_harness:{[d;k;t]
  select Test:t`num, Prediction, Hit:Prediction=' t`num from
  predict get_nn[k] apply_dist[d] raze delete num from t
  };


explain:{ 
  -1 "Usage: .knn.test_harness[training_set;k_value;] each 0!test_set"; 
  -1 "Usage: .knn.predict .knn.get_nn[k_value;] .knn.apply_dist[training_set;]raze delete num from test_instance";};

\d .