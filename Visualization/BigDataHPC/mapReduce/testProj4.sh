#!/bin/sh

### DS730: project 4:
### connie sosa: 3/19/2016, due 3/20/2016, testProj4.sh
### this file serves as README.txt, if not running this shell script

export PATH=./:$PATH ### add current directory to search PATH

##############
echo -e "\nProblem 1 ... "
echo "`date`: Running mapper, processing input file 'warAndPeace.txt' ... "
mapperProb1.py < warAndPeace.txt | sort > intersorted1.txt

echo "`date`: Running reducer, processing input file 'intersorted1.txt' ... "
reducerProb1.py < intersorted1.txt > output1.txt
echo "Output to 'output1.txt' ... "

##############
### generate random pet census input data for Problem 2
echo -e "\nProblem 2 ... "
echo "change file permission to executable for genRandomPet.py"
chmod ugo+x genRandomPet.py
genRandomPet.py

echo "`date`: Running mapper, processing input file 'pets.txt' ... "
mapperProb2.py < pets.txt > intermediate2.txt 
sort < intermediate2.txt > intersorted2.txt

echo "`date`: Running reducer, processing input file 'intersorted2.txt' ... "
reducerProb2.py < intersorted2.txt > output2.txt
echo "Output to 'output2.txt' ... "

exit
