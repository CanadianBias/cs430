#!/usr/bin/python3

# Draws a turtle using turtle API (idk)

import turtle
from random import randint


def main():
    turtle.shape('turtle')
    turtle.color('blue')
    turtle.speed(1)
    x = 2

    while x > 1:
        if x % 2 == 2:
            x = x / 2
            turtle.forward(x)
            turtle.right(90)
            # if int(turtle.xcor()) > 200 or int(turtle.ycor()) > 200:
            #     turtle.right(180)
            #     turtle.forward(x)
        else:
            x = 3 * x + 1
            turtle.forward(x)
            turtle.right(90)
            # if int(turtle.xcor()) > 200 or int(turtle.ycor()) > 200:
            #     turtle.right(180)
            #     turtle.forward(x)

    # for i in range(4):
    #     turtle.forward(100)
    #     turtle.right(90)

    # for i in range(3):
    #     turtle.forward(100)
    #     turtle.right(120)
    input()

def turtlePolygon(sideLength, numSides):
    for i in range(numSides):
        turtle.forward(sideLength)
        internalAngle=((numSides-2)*180)/numSides
        externalAngle=180-internalAngle
        turtle.right(externalAngle)

main()



