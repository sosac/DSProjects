#!/usr/bin/env python
##
## connie sosa : 3/30/2016 : ds730 : activity 6, task 1
## baseball.py

from pig_util import outputSchema

@outputSchema("calcValue:float")
def sum_fraction(first, second, third):
## sum_fraction function accepts 3 arguments: first, second, third
## return : 0.4 x first + 0.5 x second + 0.2 x third
    return ( float(first) * 0.4 + float(second) * 0.5 + float(third) * 0.2 )

