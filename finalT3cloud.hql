-- connie sosa : ds730 : 5/2/2016 final task3
-- finalT3ex1.hql
-- task3 : find the most common age/addressStreet combination:

DROP TABLE IF EXISTS person;
CREATE EXTERNAL TABLE IF NOT EXISTS person(studentId INT, fName STRING, lName STRING, age INT, addressNum STRING, addressDir STRING, addressStreet STRING, addressType STRING, city STRING, state STRING) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' LOCATION 's3://uw-hpc-final/final'; 

DROP VIEW IF EXISTS addr_age_view;
CREATE VIEW IF NOT EXISTS addr_age_view AS
SELECT addressStreet, age, COUNT(studentId) AS cnt
FROM person
GROUP BY addressStreet, age;

INSERT OVERWRITE DIRECTORY 's3://uw-hpc-final/output' 
SELECT "age: ", aav2.age, " addrStreet: ", aav2.addressStreet, " count: ", aav2.cnt
FROM addr_age_view aav2
WHERE aav2.cnt IN (SELECT MAX(aav1.cnt) FROM addr_age_view aav1);




