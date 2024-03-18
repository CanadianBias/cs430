#!/usr/bin/python3
# Takes a single command line argument and outputs bool

# import sys
from sys import argv as cla

def main():
    # Check for command line arguments
    if len(cla) == 2:
        num=int(cla[1])
    # Determine if the number is even or not
    if num % 2 == 0:
        return True
    else:
        return False

print(main())