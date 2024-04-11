#!/usr/bin/python3

# Returns length of collatz sequence
# I am creating this program because having multiple programming courses already we seem to always do this assignment anyways

from sys import argv

def main():
    if len(argv) == 2: # Checks if one CLA was given, if not, prompts user for input
        try: # Catches strings in CLAs
            num = int(argv[1])
        except:
            num = int(input("Enter an integer greater than 1: "))
        printResults(num)
    else:
        num = int(input("Enter an integer greater than 1: "))
        printResults(num)

def findCollatzLen(x): # Finds length of Collatz Sequence
    collatzLen = 0
    while x > 1:
        if x % 2 == 0:
            x /= 2
            collatzLen += 1
        else:
            x = 3 * x + 1
            collatzLen += 1
    return collatzLen

def printResults(n):
    ans = findCollatzLen(n)
    print("The length of the Collatz sequence starting with " + str(n) + " is " + str(ans) + ".")

main()