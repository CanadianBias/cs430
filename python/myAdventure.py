#!/usr/bin/python3

# This is Elijah Dromarsky's Work
# Do not steal
# Thanks

import random as rand

# Player Class
class Player():
    def __init__(self, name):
        self.name = name
        self.hp = 10
        self.xp = 0
        self.lvl = 1
        self.strength = rand.randint(1,10)
        self.perception = rand.randint(1,10)
        self.endurance = rand.randint(1,10)
        self.charisma = rand.randint(1,10)
        self.intelligence = rand.randint(1,10)
        self.agility = rand.randint(1,10)
        self.luck = rand.randint(1,10)
        self.inventory = []
        self.eH = 0 # equipped headgear
        self.eA = 0 # equipped armor
        self.eW = 0 # equipped weapon
        self.dead = False
    def displayStats(self):
        print("Character: " + self.name)
        print("HP: " + str(self.hp))
        print("Level: " + str(self.lvl))
        print("Strength: " + str(self.strength))
        print("Perception: " + str(self.perception))
        print("Endurance: " + str(self.endurance))
        print("Charisma: " + str(self.charisma))
        print("Intelligence: " + str(self.intelligence))
        print("Agility: " + str(self.agility))
        print("Luck: " + str(self.luck))

# Enemy Class
class Player():
    def __init__(self, name):
        self.name = name
        self.hp = 10
        self.strength = rand.randint(1,10)
        self.perception = rand.randint(1,10)
        self.endurance = rand.randint(1,10)
        self.charisma = rand.randint(1,10)
        self.intelligence = rand.randint(1,10)
        self.agility = rand.randint(1,10)
        self.luck = rand.randint(1,10)
        self.inventory = []
        self.eH = 0 # equipped headgear
        self.eA = 0 # equipped armor
        self.eW = 0 # equipped weapon
        self.dead = False
    def displayStats(self):
        print("Character: " + self.name)
        print("HP: " + str(self.hp))
        print("Strength: " + str(self.strength))
        print("Perception: " + str(self.perception))
        print("Endurance: " + str(self.endurance))
        print("Charisma: " + str(self.charisma))
        print("Intelligence: " + str(self.intelligence))
        print("Agility: " + str(self.agility))
        print("Luck: " + str(self.luck))

# Game Class - Defines parameters of current game, difficulty, etc.
class Game():
    def __init__(self):
        self.difficulty = 1
        self.nothingChance = 0.5
        self.itemChance = 0.6
        self.friendlyChance = 0.7
        self.enemyChance = 1
        self.currentLevel = 1
# Item Class, Weapon Class, Event Class, etc.

# Game Loop
def gameLoop(character, game):
    # Random generateed encounter (nothing, enemy, item, friendlies, etc.)
    # -- Nothing: Character can access inventory, heal, change equipment, etc.
    # -- Enemy: Character can run, fight, use magic
    # -- Item: Character can access inventory, heal, change equipment, etc.
    # -- Friendly: Character can converse, run away, attack
    while True:
        dieRoll = rand.random()
        if dieRoll <= game.nothingChance:
            print("Nothing happened...")
        elif dieRoll <= game.itemChance:
            print("You found an item.")
        elif dieRoll <= game.friendlyChance:
            print("You found a friend.")
        else:
            print("You found an enemy.")
    # Go to the next level
    # Win condition
    # Character death or victory ends the loop

def showIntro():
    print("You have begun a game...")

def endOfGame(character):
    if character.dead == True:
        print("You have lost.")
    else:
        print("You have won!")

# Main func
def main():
    # Intro
    showIntro()
    # Character Select/Customize, select difficulty
    me = Player("Jedi Bob")
    game = Game()
    # Launch game loop
    gameLoop(me, game)
    # Display end of game
    endOfGame(me)
    # Exit / Restart

main()