-- connie sosa : 4/6/2016 : ds730 : project 5
-- project5.pig
-- write pig script to solve several problems, use either local pig or AWS.
-- input files: Batting.csv, Master.csv, Fielding.csv

names = LOAD 'hdfs:/home/hduser/pigtest/Master.csv' using PigStorage(',') AS(playerID:chararray,birthYear:int,birthMonth:int,birthDay:int,birthCountry:chararray,birthState:chararray,birthCity:chararray,deathYear:int,deathMonth:int,deathDay:int,deathCountry:chararray,deathState:chararray,deathCity:chararray,nameFirst:chararray,nameLast:chararray,nameGiven:chararray,weight:int,height:int,bats:chararray,throws:chararray,debut:chararray,finalGame:chararray,retroID:chararray,bbrefID:chararray);

batters = LOAD 'hdfs:/home/hduser/pigtest/Batting.csv' USING PigStorage(',') AS (playerID:chararray,yearID:int,teamID:chararray,lgID:chararray,G:int,AB:int,R:int,H:int,B2:int,B3:int,HR:int,RBI:int,SB:int,CS:int,BB:int,SO:int,IBB:int,HBP:int,SH:int,SF:int,GIDP:int); 

fielding = LOAD 'hdfs:/home/hduser/pigtest/Fielding.csv' USING PigStorage(',') AS (playerID:chararray,yearID:int,teamID:chararray,lgID:chararray,POS:chararray,G:int,GS:int,InnOuts:int,PO:int,A:int,E:int,DP:int,PB:int,WP:int,SB:int,CS:int,ZR:int);

--------------------------------------------------------
-- 1) birth city of the player who had most at bats (AB)
-- get playerID and AB from batters, sum player's AB, find player with max(AB), get birth city
batters1 = FILTER batters BY (AB is not NULL);
playerAB = FOREACH batters1 GENERATE playerID, AB;

-- get each player's individual total AB
by_player = GROUP playerAB BY playerID;
players_AB_info = FOREACH by_player GENERATE group as player, SUM(playerAB.AB) as player_total_AB;

-- get the max AB
max_AB = GROUP players_AB_info ALL;
the_maxs = FOREACH max_AB GENERATE MAX(players_AB_info.player_total_AB) AS total_AB;

-- get player with max AB
max_player = FILTER players_AB_info BY (player_total_AB == the_maxs.total_AB);

-- get birth city
join_data1 = JOIN max_player BY player, names BY playerID;
results = FOREACH join_data1 GENERATE nameLast, nameFirst, birthCity, player_total_AB;
-- DUMP results;
STORE results INTO 'hdfs:/home/hduser/project5/prob1' USING PigStorage(',');

--------------------------------------------------------
-- 2) top three birthdates
-- get playerID, birthMonth, birthDay from Master, group by birthMonth, birthDay, count players, get top 3
names2 = FILTER names BY (birthMonth is not NULL AND birthDay is not NULL);
player_birthdate = FOREACH names2 GENERATE playerID, birthMonth, birthDay;
birthMonDay_player = GROUP player_birthdate BY (birthMonth, birthDay);

-- count number of players for each birthday
players_per_MonDay = FOREACH birthMonDay_player GENERATE group as MonDay, COUNT(player_birthdate.playerID) as birthday_counts;

-- get the top 3 most frequent birthdays
birthday_count = ORDER players_per_MonDay BY birthday_counts DESC;
results2 = LIMIT birthday_count 3;
-- DUMP results2;
STORE results2 INTO 'hdfs:/home/hduser/project5/prob2' USING PigStorage(',');

--------------------------------------------------------
-- 3) get second most common weight
names3 = FILTER names BY (weight is not NULL);
player_wt = FOREACH names3 GENERATE playerID, weight;

-- player count per weight
by_wt = GROUP player_wt BY weight; 
wt_count = FOREACH by_wt GENERATE group AS wt, COUNT(player_wt) AS num_players_per_wt;

-- order by player count
ordered_wts = ORDER wt_count BY num_players_per_wt DESC;

-- get 2 most common weight
most_wt = LIMIT ordered_wts 2;

ordered_wts_r = ORDER most_wt BY num_players_per_wt;
second_most_wt = LIMIT ordered_wts_r 1;

-- DUMP most_wt;
-- (180,1611)
-- (185,1591)
STORE second_most_wt INTO 'hdfs:/home/hduser/project5/prob3' USING PigStorage(',');

--------------------------------------------------------
--  4) team had the most errors in 2001
-- get teamID, E from Fielding for year 2001, group by teamID, count teamID, get max count of teamID, 
-- get the team name
fieldings = FILTER fielding BY (E is not NULL AND yearID == 2001);
teams_with_errors = FOREACH fieldings GENERATE teamID, E;

-- get each team's total errors
by_team_err = GROUP teams_with_errors BY teamID;
team_errors_info = FOREACH by_team_err GENERATE group as team, SUM(teams_with_errors.E) as errors;

-- get the max errors
team_errors = GROUP team_errors_info ALL;
max_errors = FOREACH team_errors GENERATE MAX(team_errors_info.errors) AS total_errs;

-- get team with max errors
most_err_team = FILTER team_errors_info BY (errors == max_errors.total_errs);
results4 = FOREACH most_err_team GENERATE team;
-- DUMP results4;
STORE results4 INTO 'hdfs:/home/hduser/project5/prob4' USING PigStorage(',');

--------------------------------------------------------
-- 5) player had the most errors in all seasons
-- get playerID, E from Fielding, group by playerID, sum E, get playerID with max errors
fieldings5 = FILTER fielding BY (E is not NULL);
playerE = FOREACH fieldings5 GENERATE playerID, E;

-- get player's individual total errors
by_player5 = GROUP playerE BY playerID;
player_err_info = FOREACH by_player5 GENERATE group as player, SUM(playerE.E) as player_total_e;

-- get the max E
max_E = GROUP player_err_info ALL;
the_max_E = FOREACH max_E GENERATE MAX(player_err_info.player_total_e) AS total_E;

-- get player with max E
max_e_player = FILTER player_err_info BY (player_total_e == the_max_E.total_E);

-- get player name
join_data5 = JOIN max_e_player BY player, names BY playerID;
results5 = FOREACH join_data5 GENERATE nameLast, nameFirst, player_total_e;
-- DUMP results5;
STORE results5 INTO 'hdfs:/home/hduser/project5/prob5' USING PigStorage(',');

--------------------------------------------------------
-- 6) player hits well
-- get playerID, E, and G from fielding, played at least 20 games
fielding6 = FILTER fielding BY (E is NOT NULL AND G is NOT NULL AND (yearID >= 2005 AND yearID <=2009) AND (G >=20) AND E > 0 );
player_EG = FOREACH fielding6 GENERATE playerID as player, yearID, E, G, (float)E/G as err_per_game;

-- get playerID, H, AB from batters, had at least 40 at bats
batting6 = FILTER batters BY (H is NOT NULL AND AB is NOT NULL AND (yearID >= 2005 AND yearID <= 2009) AND (AB >= 40) AND H > 0);
player_H_AB = FOREACH batting6 GENERATE playerID, yearID, H, AB, (float)H/AB as bat_avg;

-- get players' hits well criterion for each year
player_EG_H_AB = JOIN player_EG BY player, player_H_AB BY playerID;
player_stat_info = FOREACH player_EG_H_AB GENERATE player, (bat_avg - err_per_game) as player_stat;

-- group by player and get player's average of his hits well criterion
stat_by_player = GROUP player_stat_info BY player;
stat_avg = FOREACH stat_by_player GENERATE group as player, (float)AVG(player_stat_info.player_stat) as player_stat_avg;

-- get player names
joined_data6 = JOIN stat_avg BY player, names BY playerID;
result6 = FOREACH joined_data6 GENERATE nameLast, nameFirst, player, player_stat_avg;

-- get top 3
ordered_stat = ORDER result6 by player_stat_avg DESC;
result6_top3 = LIMIT ordered_stat 3;
-- DUMP results6b;
STORE result6_top3 INTO 'hdfs:/home/hduser/project5/prob6' USING PigStorage(',');

--------------------------------------------------------
-- 7) top 5 birth (city, state) produced players with most doubles + triples
batters7 = FILTER batters BY (B2 is NOT NULL AND B3 is NOT NULL);
playerB23 = FOREACH batters7 GENERATE playerID AS player, B2, B3, B2+B3 AS B23;

-- get birthCity, birthState, playerID, B2, B3, B2+B3:
join_data7 = JOIN names BY playerID, playerB23 BY player;
birthplace_B23 = FOREACH join_data7 GENERATE birthCity, birthState, player, B2, B3, B23;
by_birthLoc_B23 = GROUP birthplace_B23 BY (birthCity, birthState);

-- count (doubles+triples) for each birth City/State
B23_per_location = FOREACH by_birthLoc_B23 GENERATE group as birthLoc, SUM(birthplace_B23.B23) as birthLoc_TwoThree; 
-- get top 5 most doubles + triples
B23_count = ORDER B23_per_location BY birthLoc_TwoThree DESC;
results7 = LIMIT B23_count 5;
STORE results7 INTO 'hdfs:/home/hduser/project5/prob7' USING PigStorage(',');

--------------------------------------------------------
-- 8) birth month, state combo produced the worst players: min(H/AB)
batters8 = FILTER batters BY (AB is not NULL AND H is not NULL AND H > 0 AND AB > 0);
player_bat_avg = FOREACH batters8 GENERATE playerID as player, (float)H/AB as bat_avg;

-- get each player's career batting average
by_player_BA = GROUP player_bat_avg BY player;
players_BA_info = FOREACH by_player_BA GENERATE group as player, (float)AVG(player_bat_avg.bat_avg) as career_BA;

-- get player's birthMonth, State, first, last name, batting average
join_data8 = JOIN players_BA_info BY player, names BY playerID;
birthInfo_bat_avg = FOREACH join_data8 GENERATE birthMonth, birthState, nameFirst, nameLast, player, career_BA;
by_Mo_St = GROUP birthInfo_bat_avg BY (birthMonth, birthState);

-- at least 3 people came from the same state and were born in the same month
Mo_St_count_player = FOREACH by_Mo_St GENERATE group as Mo_St, COUNT(birthInfo_bat_avg.player) as Mo_St_count;
moreThan3players = FILTER Mo_St_count_player by Mo_St_count >= 3;

-- group all players with the same birthMonth and birthState together, get the lowest batting average
Mo_St_bat_avg = FOREACH by_Mo_St GENERATE group as MoSt, MIN(birthInfo_bat_avg.career_BA) as lowest_bat_avg;

-- join to make sure no skew data
join_data8b = JOIN moreThan3players BY Mo_St, Mo_St_bat_avg BY MoSt;

results8 = FOREACH join_data8b GENERATE Mo_St, lowest_bat_avg;
ordered_results8 = ORDER results8 BY lowest_bat_avg;
lowest_BA = LIMIT ordered_results8 1;
STORE lowest_BA INTO 'hdfs:/home/hduser/project5/prob8' USING PigStorage(',');


