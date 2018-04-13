#!/usr/bin/env python

### DS730: project 3: problem 3: clothing coordination
### connie sosa: 2/26/2016, due 2/28/2016
### reducerProb3y.py

### previous version: reducerProb3r.py

### expect input to be sorted prior to invoking reducer 

import sys
import re

def main(argv):
    current_token=None
    the_token=None

    prev_list = []
    curr_list = []
    intersect_list = []

### for each same key, get intersect of its good list
    for line in sys.stdin:
        line=line.strip() ## remove leading and trailing blanks
        the_token, value, bad_match = re.split(':|!', line) # split on ':', '!'
        the_token=the_token.strip() 
        value=value.strip()

        if current_token == the_token:
            prev_list = intersect_list
            curr_list = value.split()
            ### find intersect
            intersect_list = list(set(prev_list) & set(curr_list))
        else:
            ### new token
            if current_token: ## check current_token isn't empty, as in initial case
                intersect_list.sort()
                if len(current_token) > 1: ## output keys with pair or more 
                    print('%s : %s' % (current_token, ' '.join(intersect_list)))
                prev_list = value.split()
                curr_list = value.split()

            curr_list = value.split()
            intersect_list = curr_list

            ### set current_token to the_token read in
            current_token = the_token

    if current_token == the_token: ## check if any value to print at end
        intersect_list.sort()
        if len(current_token) > 1: ## output keys with pair or more 
            print('%s : %s' % (current_token, ' '.join(intersect_list)))

if __name__ == "__main__":
    main(sys.argv)



