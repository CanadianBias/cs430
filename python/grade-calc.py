#!/usr/bin/python3

# Takes a single command line argument and converts it from a percentage score to a letter grade
# Based off of the syllabus for CS430 Scripting Languages

from sys import argv as cla

def main():
    if len(cla) == 2: # Only accepts one command line argument
        try: # Try statement to catch nonnumeric values entered as CLA
            letter_grade = giveMeMyGrade(int(cla[1]))
        except:
            print("Grade was not entered as a numeric value.")
            letter_grade = enterMyPercent()
    else: # Handles no or too many command line arguments
        letter_grade = enterMyPercent()
    print(letter_grade)

def enterMyPercent():
    # print("Enter a grade percent: ")
    percent=int(input("Enter a grade percent: ")) 
    return giveMeMyGrade(percent)

def giveMeMyGrade(grade):
    match grade: # match case to assign value to letter_grade based on score
        case grade if grade > 100:
            letter_grade = "A+"
        case grade if grade in range(99,101):
            letter_grade = "A+" 
        case grade if grade in range(93,99):
            letter_grade = "A"
        case grade if grade in range(90,93):
            letter_grade = "A-"
        case grade if grade in range(87,90):
            letter_grade = "B+"
        case grade if grade in range(83,87):
            letter_grade = "B"
        case grade if grade in range(80,83):
            letter_grade = "B-"
        case grade if grade in range(77,80):
            letter_grade = "C+"
        case grade if grade in range(73,77):
            letter_grade = "C"
        case grade if grade in range(70,73):
            letter_grade = "C-"
        case grade if grade in range(67,70):
            letter_grade = "D+"
        case grade if grade in range(65,67):
            letter_grade = "D"
        case grade if grade in range(0,65):
            letter_grade = "F"
        case grade if grade < 0:
            letter_grade = "How did you get a negative score???"
    return letter_grade

main()
