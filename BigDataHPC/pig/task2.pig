batters = LOAD 'hdfs:/home/hduser/pigtest/Batting.csv' using PigStorage(',');
realbatters = FILTER batters BY $1>0;
data = FOREACH realbatters GENERATE $0 AS id, (int)$1 AS year:int, (int)$8 AS doubles:int, (int)$9 AS triples:int, (int)$10 AS hr: int;
filtereddata = FILTER data BY year==2011;
Register 'baseball.py' using streaming_python as myfuncs;
answer = FOREACH filtereddata GENERATE myfuncs.sum_fraction(doubles, triples, hr), id;
DUMP answer;
DESCRIBE answer;
best_player = ORDER answer BY calcValue DESC;
top_ten = LIMIT best_player 10;
DUMP top_ten;




