\c 15 237

"Load dataset into memory"
{x set `class xkey flip ((`$'16#.Q.a),`class)!((16#"i"),"c"; ",") 0: ` sv `pendigits,x}each `tra`tes;

"Test set:"
show tes;

"Trainig set"
show tra;

// Chapter 3. Calculating distance metric
"Taking the first element of tra and test to build the classificator"
"tra1:"
show tra1:1#tra;
"tes1:"
show tes1:1#tes;

"Applying Calculating distance metric between tra1 and tes1"
dist:{abs x-y};
// sums tra1 dist' tes1;
show sums each tra1 dist' tes1;

"each right/left benchmark - toggle comment to run"
// \ts:5000 tra dist\: 1_flip 0!tes1
// \ts:5000 (1_flip 0!tes1) dist/: tra

"Extending distance calculation to tra entirely"
show {sums each (1_x) dist/: tra} flip 0!tes1;

"Dropping dist benchmark - toggle comment to run"
// \ts:250 {[d;t] sums each t dist/: d}[tra;] raze delete class from tes1

// \ts:250 {[d;t] sums each abs t -/: d}[tra;] raze delete class from tes1

"Converting d into vectors benchmark - toggle comment to run"
// \ts:250 {[d;t] flip `class`dst!(exec class from d; sum each abs t -/: flip value flip value d)} [tra;] raze delete class from tes1

"apply_dist_manh Examples:"
apply_dist_manh:{[d;t] flip `class`dst!(exec class from d; sum each abs t -/: flip value flip value d)};

"Single Test instance passed as dictionary using adverb each"
show apply_dist_manh[tra;]each delete class from tes1;
"Multiple Test instances passed as dictionary using adverb each"
show apply_dist_manh[tra]each 2#delete class from tes;
"Single Test instance passed as dictionary, no adverb each"
show apply_dist_manh[tra;]raze delete class from tes1;

// Chapter 4. k-Nearest Neighbors and prediction
// Chapter 4.1 Nearest Neighbor k=1
"Prediction test with k=1"
show select Prediction:class, dst from apply_dist_manh[tra;]raze[delete class from tes1] where dst=min dst;
"Nearest Neighbor instance:"
show select from tra where i in exec i from apply_dist_manh[tra;]raze[delete class from tes1] where dst=min dst;

// Comparing different ways to select the nearest neigbor
// show select Prediction:class from 1#`dst xasc apply_dist_manh[tra;]raze delete class from tes1;
// show select Prediction:class from `dst xasc apply_dist_manh[tra;]raze[delete class from tes1] where i<1;

// Chapter 4.2 k>1
"Three nearest neighbors of tes1:"
k:3; show select Neighbor:class,dst from k#`dst xasc apply_dist_manh[tra;]raze delete class from tes1;
"Five nearest neighbors of tes1:"
k:5; show select Neighbor:class,dst from k#`dst xasc apply_dist_manh[tra;]raze delete class from tes1;

get_nn: {[k;d] select class,dst from k#`dst xasc d};

// Chapter 4.3 Prediction test
predict:{1#select Prediction:class from x where ((count;i)fby class)=max(count;i)fby class};

// Testing fallback to k=1 for tie-up scenarios
// Prediction unclear
foo1: {   select Prediction:class from x where ((count;i)fby class)=max (count;i)fby class};
// Prediction unclear - Fallback to k=1
foo2: { 1#select Prediction:class from x where ((count;i)fby class)=max (count;i)fby class};
"Comparing fallback to k=1"
show (foo1;foo2)@\: ([] class:"28833"; dst: 20 21 31 50 60); // Dummy table, random values

"Tes1 validation test against tra:"
show predict get_nn[5;] apply_dist_manh[tra;]raze delete class from tes1;
"SPOT ON!"

// Assigning to general apply_dist
apply_dist:apply_dist_manh;

// Chapter 5. Accuracy checks
test_harness:{[d;k;t] select Test:t`class, Hit:Prediction=' t`class from
  predict get_nn[k] apply_dist[d] raze delete class from t };

// Chapter 5.1 Running with k=5
"Validating each instance in tes against tra"
"Running k=5. Wait ..."
show select Accuracy:avg Hit by Test from raze R5:test_harness[tra;5;] peach 0!tes;
"Running k=3. Wait ..."
show select Accuracy:avg Hit by Test from raze R3:test_harness[tra;3;] peach 0!tes;
"Running k=1. Wait ..."
show select Accuracy:avg Hit by Test from raze R1:test_harness[tra;1;] peach 0!tes;


// Chapter 6 Further Approaches
// Chapter 6.1 Use slave threads
"each Validation benchmark 1000 times - uncomment to toggle on"
// \ts:1000 test_harness[tra;1;] each 0!test
"-s 4, peach Validation benchmark 1000 times - uncomment to toggle on"
// \ts:1000 test_harness[tra;1;] peach 0!test

// Chapter 6.2 Euclidean or Manhattan distance
"xexp benchmark - change ts to 1000 to test. \ts r1:"
\ts r1:{[d;t] {x xexp 2}each t -/: flip value flip value d}[tra;]raze delete class from tes1;
" square approach {x*x} benchmark - change ts to 1000 to test. \ts r2:"
\ts r2:{[d;t] {x*x} t -/: flip value flip value d}[tra;]raze delete class from tes1;

"r1=r2"
show  min over r1=r2;
"r1~r2"
show r1~r2
"xexp returns is datatype float"
show exec distinct t from meta r1;
"{x*x} preserve the dataset type int"
show exec distinct t from meta r2;
"Size comparison between the float and int result set"
show -22!'(r1;r2);

apply_dist_eucl:{[d;t] flip `class`dst!(exec class from d;sqrt sum each {x*x} t -/: flip value flip value d)};
apply_dist: apply_dist_eucl;
"Benchmarking classification of tes using apply_dist_eucl. Wait ..."
\ts R1:test_harness[tra;1;] peach 0!tes;
"k=1 Accuracy"
show select Accuracy: avg Hit from raze R1;
"k=1 Accuracy per class"
show select Accuracy:avg Hit by Test from raze R1;

// Chapter 6.4 Benchmarks
"Euclidean Distance Benchmark. Wait ..."
{[t;d;k] t0:.z.t; res: raze test_harness[t;k;]peach 0!d;t1:.z.t;
  0N! "|"sv ("k: ",string k;"ms: ",string`int$t1-t0;"accuracy: ",string exec avg Hit from res)
  }[tra;tes;]each 1+til 10;

"Manhattan Distance Benchmark. Wait ..."
apply_dist: apply_dist_manh;
{[t;d;k] t0:.z.t; res: raze test_harness[t;k;]peach 0!d;t1:.z.t;
  0N! "|"sv ("k: ",string k;"ms: ",string`int$t1-t0;"accuracy: ",string exec avg Hit from res)
  }[tra;tes;]each 1+til 10;