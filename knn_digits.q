// Chap.2
show test:`num xkey flip ((`$'16#.Q.a),`num)!((16#"i"),"c"; ",") 0:`pendigits.tes;
show  tra:`num xkey flip ((`$'16#.Q.a),`num)!((16#"i"),"c"; ",") 0:`pendigits.tra;

// Chap.3
show tra1:1#tra;
show tes1:1#test;
dist:{abs x-y};
show tra1 dist' tes1;
show sums each tra1 dist' tes1;
\ts tra dist\: 1_flip 0!tes1
\ts (1_flip 0!tes1) dist/: tra
show {sums each (1_x) dist/: tra} flip 0!tes1;
apply_dist:{[d;t] select num,distance:p from sums each t dist/: d};

show apply_dist[tra] each delete num from tes1;
show raze apply_dist[tra] each delete num from tes1;

// Chap.4
show select Prediction:num, distance from raze apply_dist[tra]each (delete num from tes1) where distance=min distance;
show select from tra where i in exec i from raze apply_dist[tra]each (delete num from tes1) where distance=min distance;
show select Prediction:num from 1#`distance xasc raze apply_dist[tra]each delete num from tes1;
show select Prediction:num from `distance xasc raze apply_dist[tra]each(delete num from tes1) where i<1;

k:3; show select Neighbour:num,distance from k#`distance xasc raze apply_dist[tra]each delete num from tes1;
k:5; show select Neighbour:num,distance from k#`distance xasc raze apply_dist[tra]each delete num from tes1;

get_nn:{[k;d] select nn:num,distance from k#`distance xasc d};
predict:{1#select Prediction:nn from x where ((count;i)fby nn)=max (count;i)fby nn};

// Chap.5
test_harness:{[d;k;t]
  select Test:t`num, Prediction, Hit:Prediction=' t`num from
  predict get_nn[k] apply_dist[d] raze delete num from t
  };
R5:test_harness[tra;5;] peach 0!test;
show select Accuracy:sum[Hit]%count i by Test from raze R5;

R3:test_harness[tra;3;] peach 0!test;
show select Accuracy:sum[Hit]%count i by Test from raze R3;

R1:test_harness[tra;1;] peach 0!test;
show select Accuracy:sum[Hit]%count i by Test from raze R1;

// Chap.6
// 6.1
\ts test_harness[tra;1;] each 0!test

\ts test_harness[tra;1;] peach 0!test

// 6.2
\ts:250 {[d;t] select num,distance:p from sums each abs t dist/: d}[tra;] raze delete num from tes1

\ts:250 {[d;t] select num,distance:p from sums each abs t -/: d}[tra;] raze delete num from tes1

// 6.3
apply_dist:{[d;t] select num,distance:p from sqrt sums each t {(x-y) xexp 2}/: d};
\ts:1000 r1:{[t;d] t {(x-y)xexp 2}/: d}[tra;]raze delete num from tes1
\ts:1000 r2:{[t;d] t {x*x:x-y}/: d}[tra;]raze delete num from tes1

show min over (=) . (r1;r2);
show (~) . (r1;r2);
show type @''' value each (r1;r2);
show -22!'(r1;r2);

\ts:1000 r3:{[t;d] t*t:t -/: d}[tra;]raze delete num from tes1
\ts:1000 r2:{[t;d] t {x*x:x-y}/: d}[tra;]raze delete num from tes1
show min over (=) . (r2;r3);
show (~) . (r2;r3);

apply_dist:{[d;t] select num,distance:p from sqrt sums each t {x*x:x-y}/: d};
\ts R1:test_harness[tra;1;] peach 0!test
show select Accuracy:sum[Hit]%count i by Test from raze R1;

show select Accuracy_Manhattan:(avg;med)@\: Accuracy from select Accuracy:sum[Hit]%count i by Test from raze R1;