#!/usr/bin/env python

### DS730: project 3: problem 1: words with same number of vowels
### connie sosa: 3/15/2016, due 3/20/2016
### mapperProb1.py

import sys
import re

def main(argv):

    for line in sys.stdin:
        line = line.strip()
        if len(line) > 0: ### skip blank line
            ### regular expression split on spaces, tabs, newlines.
            for word in re.split('\s+', line):
                vowels = re.findall('[aeiouy]', word, re.IGNORECASE)
                vowel_len = len(vowels)
                print(str(vowel_len) + " : " + "1")

if __name__ == "__main__":
    main(sys.argv)

