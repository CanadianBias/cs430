#!/usr/bin/python3

# Version 0.0 PreBeta Testing Version

# Combat Sim Game with RPG Elements

import random as rand
import os

class Player():
    def __init__(self, name):
        self.name = name
        self.currenthp = rand.randint(8,15)
        self.maxhp = self.currenthp
        self.alive = True # changed if currenthp drops below 1
        self.strength = rand.randint(1,10) # determines flat damage output
        self.perception = rand.randint(1,10) # increases likeliness to find items
        self.endurance = rand.randint(1,10) # allows for more AP (action points) per combat turn, allowing for more actions, also boosts HP gain/reduces HP loss
        self.charisma = rand.randint(1,10) # increases probability of positive outcomes when interacting with NPCs or intimidating enemies
        self.intelligence = rand.randint(1,10) # allows for better crafting options
        self.agility = rand.randint(1,10) # gives a higher probability of being able to attack twice, or dodge an enemies attack
        self.luck = rand.randint(1,10) # increases crit chance and rarity of items
        self.inventory = []
        self.lvl = 0
        self.xp = 0
    def displayStats(self):
        print("Character: " + self.name)
        print("HP: " + str(self.currenthp) + "/" + str(self.maxhp))
        print("Level: " + str(self.lvl))
        print("Strength: " + str(self.strength))
        print("Perception: " + str(self.perception))
        print("Endurance: " + str(self.endurance))
        print("Charisma: " + str(self.charisma))
        print("Intelligence: " + str(self.intelligence))
        print("Agility: " + str(self.agility))
        print("Luck: " + str(self.luck))
    def displayInventory(self):
        # os.system('clear')
        for i in self.inventory:
            print(i.name)
    def equipItem(self):
        # Take equippable item, change equip status, increment max health/strength
        pass
    def unequipItem(self):
        # Take equipped item, change equip status, deincrement max health/strength
        pass
    def findItem(self):
        # Check perception stat, adjust probability needed to find item accordingly
        # Create random stat using lists of possible items,
        pass
    def craftItem(self):
        # Give player list of items able to be crafted and resources required
        # Check player inventory for resources
        # Remove those resources, add new item
        # Increment XP
        # If player tries to craft item they don't have resources for, restart crafting
        pass

class Enemy():
    def __init__(self) -> None:
        pass

class Game():
    def __init__(self, currentPlayer) -> None:
        self.player = currentPlayer
        self.distance = 0 # determines progression through game, scales enemies
    def walkForward(self):
        self.distance += 100

class Item():
    def __init__(self, name) -> None:
        # Name of item
        self.name = name
        # Definition determining type of item
        # If debuff items, have respective stats or placeholder for different types
        # Crafting class if item is a crafting item
        # Health/strength stat change if item is armor/weapon
        # Equipped status if equipped
        pass

def addFancyThings(string, char): # Adds some title flair
    stopPoint = os.get_terminal_size()[0]/2
    i = 0
    line = ""
    while i < stopPoint:
        line += char
        i += 1
    line += string
    j = len(line)
    while j < int(os.get_terminal_size()[0]):
        line += char
        j += 1
    return line


def coreGame(me, game):
    while True:
        # os.system('clear')
        print(addFancyThings("Status Report", "-"))
        # Print character stats to terminal to let player know their stats/hp
        me.displayStats()
        print("Distance Travelled: " + str(game.distance) + "m")
        print(addFancyThings("", "-"))
        # Give player option to move forward, check inventory, look around for items, or craft items
        print("1: Open Invetory Menu")
        print("2: Open Crafting Menu")
        print("3: Look for Items")
        print("4: Continue Pressing Onward")
        selection = input()
        if int(selection) == 1:
            newItem = Item("Sword")
            me.inventory.append(newItem)
            print(addFancyThings("Inventory", "-"))
            me.displayInventory()
            print(addFancyThings("", "-"))
        # When looking around or moving forward, higher probability of encountering enemy
        # When looking in inventory or crafting, lower probability of encountering enemy

    pass

def combat(me):
    pass

def main():
    print("Welcome to Fight Sim Game v.0.0 prebeta")
    myName = input("What's your name, yo? ")
    me = Player(myName)
    game = Game(me)
    coreGame(me, game)
    
def endOfGame():
    # End game
    # Print stats
    # Prompt user to restart with this character or choose a new one or quit
    pass

main()