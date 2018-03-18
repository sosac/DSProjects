#!/usr/bin/env python

### DS730: project 3: problem 3: clothing coordination
### connie sosa: 2/24/2016, due 2/28/2016
### mapperTask3z.py

## mapper's input format :
## k : v1 v2 v3 ! v4
## get all possible 'number combination' for each input line,
## if k is in that combination
##    output that combination as key, and 'good and not list' as value.

## output for an input line:
#k v1 : v1 v2 v3 ! v4
#k v2 : v1 v2 v3 ! v4
#k v3 : v1 v2 v3 ! v4
#k v4 : v1 v2 v3 ! v4
#k v1 v2 : v1 v2 v3 ! v4
#k v1 v3 : v1 v2 v3 ! v4
#k v1 v4 : v1 v2 v3 ! v4
#k v2 v3 : v1 v2 v3 ! v4
#k v2 v4 : v1 v2 v3 ! v4
#k v3 v4 : v1 v2 v3 ! v4
#k v1 v2 v3 : v1 v2 v3 ! v4
#k v1 v2 v4 : v1 v2 v3 ! v4
#. . .

import sys
import re
import itertools
import operator

def main(argv):
    line = sys.stdin.readline()
    line = line.strip()
    while line:
        all_items = []
        item, good_match, bad_match = re.split(':|!', line) # split on ':', '!'
        item=item.strip()
        good_match = good_match.strip() ## remove spaces at begin, end
        bad_match = bad_match.strip() ## remove spaces at begin, end
        good_matches = good_match.split()
        bad_matches = bad_match.split()

        all_items = good_matches + bad_matches 
        all_items.append(item)
        all_items.sort()
        all_items_str = ' '.join(map(str, all_items))

        # get all combination of item, good_matches, and bad_matches
        good_matches_len = len(good_matches) + 1
        bad_combination = []
        good_comb_list2 = []

        for x in range(1, len(all_items) + 1): 
            for subset in itertools.combinations(all_items, x):
                subset_sort = sorted(subset) # sort numbers within each row 
                subset_str = ' '.join(map(str, subset))
                subset_int = [int(x) for x in subset]
                if item in subset:
                    print(subset_str + " : " + good_match + " ! " + bad_match)

        line = sys.stdin.readline()
        line = line.strip()

if __name__ == "__main__":
    main(sys.argv)
