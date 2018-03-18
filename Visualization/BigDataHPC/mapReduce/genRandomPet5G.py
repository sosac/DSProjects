#!/usr/bin/env python

### DS730: project 4:
### connie sosa: 3/15/2016, due 3/20/2016
### generateRandPet.py

import sys
import random
import string

file_name = "pets.txt"
file_size = 1024 * 1000 * 5120  ### set file_size to 5 GB or whatever size
#file_size = 1024
max_num_pets = 6 ### set maximum number of pets to 6 or some other number

f = open(file_name, 'w')
print("Generating file: '" + file_name + "' of about " + str(file_size) + " Bytes ...")

byte_count = 0
byte_count_line = 0
max_char_count_line = 80  ### about 80 characters per line

num_of_pets=random.randint(1, max_num_pets) 

### top 8 most common pet:BCDFGHMS, source www.animalplanet.com
def id_generator(size=num_of_pets, chars="BCDFGHMS"):
    return ''.join(random.choice(chars) for _ in range(size))

byte_count = 0
byte_count_line = 0
while byte_count < file_size :
    num_of_pets = random.randint(1, max_num_pets) 
    pets = id_generator(num_of_pets)

    byte_count += num_of_pets
    if byte_count_line < max_char_count_line:
        byte_count_line += num_of_pets
        f.write(pets)
        f.write(" ")
        byte_count += 1
    else:
        byte_count_line = 0
        f.write("\n")
        byte_count += 1
f.close()



