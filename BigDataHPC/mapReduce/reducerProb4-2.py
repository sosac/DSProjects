#!/usr/bin/env python

### DS730: project 4: problem 2: pet census analysis
### connie sosa: 3/15/2016, due 3/20/2016
### reducerProb2.py

import sys

def main(argv):
    current_number=None
    current_count=0
    the_number=None

### input sorted
    for line in sys.stdin:
        line=line.strip() ## remove leading and trailing blanks
        line=line.replace(" ", "") ## remove blanks in between: CCDFM : 1 --> CCDFM:1
        the_number, count = line.split(':', 1) ## split key/value on ':'
        count=int(count) ## convert count to number

        if current_number == the_number:
            current_count += count
        else:
            if current_number: ## checks current_number isn't empty, as in initial case
                print('%s : %s' % (current_number, current_count))

            ### set current_count and current_number to values read in
            current_count = count
            current_number = the_number

    if current_number == the_number: # checks if any value to print at end
        print('%s : %s' % (current_number, current_count))

if __name__ == "__main__":
    main(sys.argv)



