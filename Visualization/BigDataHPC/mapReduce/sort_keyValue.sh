#!/bin/bash

### ds730: activity 4: task 5
### Connie Sosa: 3/9/2016 
###
### input: part-*
### output file: wapSorted.txt
###
### this shell script sort_keyvValue.sh reads in all of the key/value pairs
### from the part-* files, merge and sort them, produce a single sorted output 
### file: wapSorted.txt 

num_files=`ls -l part-* | wc -l`
echo "sorting $num_files input files using dictionary order ... : "
echo "`ls part-*`"
echo " ... "
echo ""
echo "merging into one output file : "
echo "wapSorted.txt"
echo " ... "
echo ""

sort -d part-* -o wapSorted.txt
echo "done"
echo ""

exit
