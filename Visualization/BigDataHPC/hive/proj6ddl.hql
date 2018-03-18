-- connie sosa : 4/18/2016 : ds730 : project 6
-- proj6ddl.hql
-- hive ddl script to create tables 
-- input files: Batting.csv, Master.csv, Fielding.csv

DROP TABLE IF EXISTS master;
CREATE EXTERNAL TABLE IF NOT EXISTS master(id STRING, byear INT, bmonth INT, bday INT, bcountry STRING, bstate STRING, bcity STRING, dyear INT, dmonth INT, dday INT, dcountry STRING, dstate STRING, dcity STRING, fname STRING, lname STRING, name STRING, weight INT, height INT, bats STRING, throws STRING, debut STRING, finalgame STRING, retro STRING, bbref STRING) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' LOCATION '/home/hduser/hive/master';

DROP TABLE IF EXISTS batting;
CREATE EXTERNAL TABLE IF NOT EXISTS batting(id STRING, year INT, team STRING, league STRING, games INT, ab INT, runs INT, hits INT, doubles INT, triples INT, homeruns INT, rbi INT, sb INT, cs INT, walks INT, strikeouts INT, ibb INT, hbp INT, sh INT, sf INT, gidp INT) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' LOCATION '/home/hduser/hive/batting';

DROP TABLE IF EXISTS fielding;
CREATE EXTERNAL TABLE IF NOT EXISTS fielding(id STRING, year INT, team STRING, league STRING, position INT, games INT, gs INT, innOuts INT, putouts INT, assists INT, errors INT, dp INT, pb INT, wp INT, sb INT, cs INT, zrating INT) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' LOCATION '/home/hduser/hive/fielding';


