#!/usr/bin/env python

### DS730: project 4: problem 2: pet census analysis
### connie sosa: 3/15/2016, due 3/20/2016
### mapperProb2.py

import sys
import re

def main(argv):

    line = sys.stdin.readline()
    line = line.strip()
    while line:
        ### regular expression split on spaces, tabs(\t\v), newlines(\n\r\f)
        for token in re.split('\s+', line):
            pets = re.findall('\w', token.upper())
            pet_sorted = sorted(pets)  ### sort
            key = ''.join(pet_sorted) ### convert from list to string 
            print(key + " : " + "1")
        line = sys.stdin.readline()
        line = line.strip()

if __name__ == "__main__":
    main(sys.argv)

