#!/usr/bin/python3

# Calculates if given array of numbers is prime, or a number given is prime

from sys import argv as cla
from math import sqrt

def main():
    if len(cla) > 1: # Conditonal to check for command line arguments
        results_dict = {} # Creates dictionairy of numbers given and results
        for i in range(1,len(cla)):
            try: # Try statement to prevent int() conversion errors
                key = int(cla[i])
                value = isPrime(key)
            except: # If a nonnumeric string is given, return NaN (not a number)
                key = cla[i]
                value = "NaN"
            results_dict[key] = value # Creates entry in the dictionairy for number and prime value
        for j in results_dict: # iterates over new dictionairy to display results
            print(str(j) + ": " + str(results_dict[j]))
    else:
        promptUser()

def isPrime(num): # Calculates whether a given number is prime or not prime
    if num <= 1:
        return "Neither Prime nor Not Prime"
    elif num % 2 == 0 and num != 2:
        return "Not Prime"
    else:
        ceiling = int(sqrt(num)) # Finds square root of number, stores it to variable
        for i in range(3,ceiling+1):
            if num % i == 0:
                return "Not Prime"
    return "Prime"

def promptUser(): # Function to keep prompting user to input a number until they do
    try:
        usrNum = int(input("Enter a number: "))
        print(str(usrNum) + ": " + str(isPrime(usrNum)))
    except:
        print("You did not enter a number. Try again.")
        promptUser()

main()
    

            