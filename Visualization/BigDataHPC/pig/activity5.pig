-- connie sosa : 3/26/2016 : ds730 : activity 5, task 5
-- activity5.pig
-- data dictionary reference http://seanlahman.com/files/database/readme58.txt

/* Batting.csv:playerID,yearID,teamID,lgID,G,AB,R,H,2B,3B,HR,RBI,SB,CS,BB,SO,IBB,HBP,SH,SF,GIDP */
batters = LOAD 'hdfs:/home/hduser/pigtest/Batting.csv' USING PigStorage(',') AS (playerID:chararray,yearID:int,teamID:chararray,lgID:chararray,G:int,AB:int,R:int,H:int,B2:int,B3:int,HR:int,RBI:int,SB:int,CS:int,BB:int,SO:int,IBB:int,HBP:int,SH:int,SF:int,GIDP:int); 

/* Master.csv:playerID,birthYear,birthMonth,birthDay,birthCountry,birthState,birthCity,deathYear,deathMonth,deathDay,deathCountry,deathState,deathCity,nameFirst,nameLast,nameGiven,weight,height,bats,throws,debut,finalGame,retroID,bbrefID
*/
names = LOAD 'hdfs:/home/hduser/pigtest/Master.csv' using PigStorage(',') AS(playerID:chararray,birthYear:int,birthMonth:int,birthDay:int,birthCountry:chararray,birthState:chararray,birthCity:chararray,deathYear:int,deathMonth:int,deathDay:int,deathCountry:chararray,deathState:chararray,deathCity:chararray,nameFirst:chararray,nameLast:chararray,nameGiven:chararray,weight:int,height:int,bats:chararray,throws:chararray,debut:chararray,finalGame:chararray,retroID:chararray,bbrefID:chararray);

-------------------------------------------------------------------
-- 1) heaviest player to hit > 5 triples (3B) in 2005 
-- get players with more than 5 triples in 2005 from Batting
--
players_triple = FILTER batters BY (yearID == 2005 AND B3 > 5);
triple_data = FOREACH players_triple GENERATE playerID, yearID, B3;
master_player_wt = FOREACH names GENERATE playerID, nameFirst, nameLast, weight;
join_data = JOIN triple_data BY playerID, master_player_wt BY playerID;

-- format data:hollima01,2005,7,hollima01,Matt,Holliday,250
join_data_n = FOREACH join_data GENERATE nameLast, nameFirst, weight, B3, yearID;
player_heavy = ORDER join_data_n BY weight DESC;
top_one = LIMIT player_heavy 1; 
DUMP top_one;
STORE top_one INTO 'hdfs:/home/hduser/pigtest/proj5task5_1' USING PigStorage(',');

-------------------------------------------------------------------
-- 2) the player played for the most teams in any single season and the number  
-- of teams he played for
--
player_teams = FOREACH batters GENERATE playerID, yearID, teamID;
by_player_yr = GROUP player_teams BY (playerID, yearID);
player_teams_num = FOREACH by_player_yr GENERATE group, COUNT(player_teams) AS num_teams;
-- player_max = FOREACH player_teams_num GENERATE MAX(player_teams_num.num_team);
-- player_teams_num = FOREACH player_teams_num GENERATE FLATTEN(group), num_teams;
ordered_player_team = ORDER player_teams_num BY num_teams DESC;
most_teams_player = LIMIT ordered_player_team 1;

-- format data:(huelsfr01,1904),5
most_teams_player_f = FOREACH most_teams_player GENERATE FLATTEN(group) AS (playerID, year), num_teams;
join_data2 = JOIN most_teams_player_f BY playerID, names BY playerID;
results = FOREACH join_data2 GENERATE nameLast, nameFirst, num_teams, year;
DUMP results;
STORE results INTO 'hdfs:/home/hduser/pigtest/proj5task5_2' USING PigStorage(',');

-------------------------------------------------------------------
-- 3) the player had the most extra base hits during the 80s.
-- extra base hit : a double (2B), triple (3B), or home run (HR)
--
extra_base_hit = FILTER batters BY ( (B2 is not NULL) AND (B3 is not NULL) AND (HR is not NULL) AND (B2 >0 OR B3 >0 OR HR >0) AND (yearID <= 1989) AND yearID >= 1980 );
player_extra_bh = FOREACH extra_base_hit GENERATE playerID, yearID, B2, B3, HR, B2+B3+HR AS extra_base_hits;
master_player = FOREACH names GENERATE playerID, nameFirst, nameLast;
extra_base = JOIN player_extra_bh BY playerID, master_player BY playerID;
extra_base_n = FOREACH extra_base GENERATE nameLast, nameFirst, yearID, B2, B3, HR, extra_base_hits;

-- format data:yountro01,1982,46,12,29,87
player_max_ebh = ORDER extra_base_n BY extra_base_hits DESC;
top_extra_base_hit = LIMIT player_max_ebh 2;
-- top_extra_base_hit = LIMIT player_max_ebh 1;
-- extra_base_group = GROUP extra_base_n ALL;
-- max_eb = FOREACH extra_base_group GENERATE group, MAX(player_extra_bh.extra_base_hits);
DUMP top_extra_base_hit;
STORE top_extra_base_hit INTO 'hdfs:/home/hduser/pigtest/proj5task5_3' USING PigStorage(',');

-------------------------------------------------------------------
-- 4) most hits right-handed batter who were born in Oct and died in 2011 
--
-- get player handed info, birth month, and death year
player_hand = FOREACH names GENERATE playerID, nameFirst, nameLast, bats, birthMonth, deathYear;
playerR10_2011 =  FILTER player_hand BY ( bats == 'R' AND birthMonth == 10 AND deathYear == 2011 );
-- get players id and H (hits) from Batting
player_hits = FOREACH batters GENERATE playerID, H;
join_data4 = JOIN playerR10_2011 BY playerID, player_hits BY playerID;

-- format data:careyan01,R,10,2011,careyan01,131
player_hits = ORDER join_data4 BY H DESC;
top_player_hits = FOREACH player_hits GENERATE nameLast, nameFirst, bats, H;
top_hits = LIMIT top_player_hits 1; 
DUMP top_hits;
STORE top_hits INTO 'hdfs:/home/hduser/pigtest/proj5task5_4' USING PigStorage(',');
