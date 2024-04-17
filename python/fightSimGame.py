#!/usr/bin/python3

# Combat Sim Game with RPG Elements

import random as rand

class Player():
    def __init__(self):
        self.currenthp = rand.randint(8,15)
        self.maxhp = self.currenthp
        self.strength = rand.randint(1,10)
        self.perception = rand.randint(1,10)
        self.endurance = rand.randint(1,10)
        self.charisma = rand.randint(1,10)
        self.intelligence = rand.randint(1,10)
        self.agility = rand.randint(1,10)
        self.luck = rand.randint(1,10)
        self.inventory = []
        self.lvl = 0
        self.xp = 0

def craftItem():
    # Give player list of items able to be crafted and resources required
    # Check player inventory for resources
    # Remove those resources, add new item
    # Increment XP
    # If player tries to craft item they don't have resources for, restart crafting
    input()

def endOfGame():
    # End game
    # Print stats
    # Prompt user to restart with this character or choose a new one or quit
    input()