#!/usr/bin/python3

# Version 0.0 PreBeta Testing Version

# Combat Sim Game with RPG Elements

# To Do:
    # Combat
        # Implement retreating from combat (DONEEEEE)
        # Implement intimidation in combat
        # Fix scaling for enemies, currently enemies are too weak at low levels and too powerful at higher levels
            # slightly fixed, fine tweaking more difficult
    # Items
        # Add equipping and unequipping items
        # Add finding craftable resources and equippable items
        # Add crafting items
            # May be too complicated for implementation at this stage

# Potential Improvements:
    # Add critical hits using the luck attribute

import random as rand
import math
import os
# Testing references to user-created libraries
# import myGameChar as ch

class Player():

    def __init__(self, name):
        self.name = name # User-assigned at beginning of main loop
        self.currenthp = rand.randint(8,15)
        self.maxhp = self.currenthp
        self.currentap = rand.randint(4,10)
        self.maxap = self.currentap
        self.alive = True # changed if currenthp drops below 1
        self.strength = rand.randint(1,10) # determines flat damage output
        self.perception = rand.randint(1,10) # increases likeliness to find items
        self.endurance = rand.randint(1,10) # allows for more AP (action points) per combat turn, allowing for more actions, also boosts HP gain/reduces HP loss
        self.charisma = rand.randint(1,10) # increases probability of positive outcomes when interacting with NPCs or intimidating enemies
        self.intelligence = rand.randint(1,10) # allows for better crafting options
        self.agility = rand.randint(1,10) # gives a higher probability of being able to attack twice, or dodge an enemies attack
        self.luck = rand.randint(1,10) # increases crit chance and rarity of items
        self.inventory = [] # stores all items
        self.armor = [] # contains currently equipped item
        self.weapon = [] # contains currently equipped item
        self.lvl = 1
        self.xp = 0 # cummulative XP over period of game
        self.xpSinceLastLevel = 0 # xp since last level up, meant to calculate when to level up again

    def displayStats(self):
        # Printed when game loop cycles
        print("Character: " + self.name)
        print("HP: " + str(self.currenthp) + "/" + str(self.maxhp))
        print("XP: " + str(self.xp))
        print("Level: " + str(self.lvl))
        print("Strength: " + str(self.strength))
        print("Perception: " + str(self.perception))
        print("Endurance: " + str(self.endurance))
        print("Charisma: " + str(self.charisma))
        print("Intelligence: " + str(self.intelligence))
        print("Agility: " + str(self.agility))
        print("Luck: " + str(self.luck))

    def checkLevel(self):
        if self.xpSinceLastLevel >= 10: # checks time since last leveling up
            print(addFancyThings("You leveled up!", "*"))
            self.lvl += 1
            # informs user of current stats 
            print("Current level: " + str(self.lvl))
            print("Choose a category to upgrade:")
            print("1: Strength (Current Strength: " + str(self.strength) + ")")
            print("2: Perception (Current Perception: " + str(self.perception) + ")")
            print("3: Endurance (Current Endurance: " + str(self.endurance) + ")")
            print("4: Charisma (Current Charisma: " + str(self.charisma) + ")")
            print("5: Intelligence (Current Intelligence: " + str(self.intelligence) + ")")
            print("6: Agility (Current Agility: " + str(self.agility) + ")")
            print("7: Luck (Current Luck: " + str(self.luck) + ")")
            levelSelection = checkUserInput()
            # Loop to prevent out of range errors or breaking the leveling system if number given greater than 7
            while True:
                if levelSelection == 1:
                    self.strength += 1
                    print("New Strength Level: " + str(self.strength))
                    break
                if levelSelection == 2:
                    self.perception += 1
                    print("New Perception Level: " + str(self.perception))
                    break
                if levelSelection == 3:
                    self.endurance += 1
                    self.maxhp += 5 # increments max hp in accordance with endurance philosophy
                    print("New Endurance Level: " + str(self.endurance))
                    break
                if levelSelection == 4:
                    self.charisma += 1
                    print("New Charisma Level :" + str(self.charisma))
                    break
                if levelSelection == 5:
                    self.intelligence += 1
                    print("New Intelligence Level: " + str(self.intelligence))
                    break
                if levelSelection == 6:
                    self.agility += 1
                    print("New Agility Level: " + str(self.agility))
                    break
                if levelSelection == 7:
                    self.luck += 1
                    print("New Luck Level: " + str(self.luck))
                    break
                else:
                    print(str(levelSelection) + " wasn't an option...")
            self.xpSinceLastLevel = 0
            self.currenthp = self.maxhp # resets health upon levelling up
            print(addFancyThings("", "*"))

    def displayInventory(self):
        # os.system('clear')
        # Placeholder space for a random enemy encounter when you open your inventory
        print(addFancyThings("Inventory", "-"))
        if len(self.inventory) == 0:
            print("Your Inventory is Empty.")
        else:
            for i,item in enumerate(self.inventory):
                    print(str(i) + ": " + str(item.name))
        print(addFancyThings("", "-"))
        if len(self.inventory) == 0:
            input("Press Enter to Continue...")
        else:
            print("1: Select an Item")
            print("2: Exit Inventory")
            inventorySelection = checkUserInput()
            if inventorySelection == 1:
                itemSelection = checkUserInput()
                if len(self.inventory) > itemSelection:
                    item = self.inventory[itemSelection]
                    print(addFancyThings(item.name, "-"))
                    print("Name: " + str(item.name))
                    print("Type: " + str(item.type))
                    if item.type == "armor":
                        print("Armor Stats: " + str(item.armorDebuff))
                    elif item.type == "weapon":
                        print("Weapon Stats: " + str(item.weaponDebuff))
                        print("AP Cost: " + str(item.apCost))
                    if item.isEquipped == True:
                        print("Equipped: Yes")
                    elif item.isEquipped == False:
                        print("Equipped: No")
                    print(addFancyThings("", "-"))
                    print("1: Equip/Unequip Item")
                    print("2: Exit to Inventory")
                    print("3: Exit to Game")
                    equipSelection = checkUserInput()
                    if equipSelection == 1:
                        if item.isEquipped == True:
                            self.unequipItem(item)
                        elif item.isEquipped == False:
                            self.equipItem(item)
                    elif equipSelection == 2:
                        self.displayInventory()
                    elif equipSelection == 3:
                        return
                else:
                    print("Did you even see an item " + str(itemSelection) + " in your inventory???")
                    input("Press Enter to continue...")
            if inventorySelection == 2:
                return
            
    def equipItem(self, item):
        # Take equippable item, change equip status, increment max health/strength
        if item.type == "weapon":
            if len(self.weapon) >= 1:
                print("Please unequip a weapon before you try to equip a new one.")
            else:
                self.weapon.append(item)
                item.isEquipped = True
                self.strength += item.weaponDebuff
        if item.type == "armor":
            self.armor.append(item)
            item.isEquipped = True
            self.currenthp += item.armorDebuff
            self.maxhp += item.armorDebuff
        print(str(item.name) + " has been equipped.")
        input("Press Enter to continue...")

    def unequipItem(self, item):
        if item.type == "weapon":
            self.weapon.remove(item)
            self.weapon.isEquipped = False
            self.strength -= item.weaponDebuff
        if item.type == "armor":
            if self.currenthp > item.armorDebuff:
                self.armor.remove(item)
                item.isEquipped = False
                self.currenthp -= item.armorDebuff
                self.maxhp -= item.armorDebuff
            else:
                print("You cannot unequip this armor as it is keeping you from dying.")
                return
        print(str(item.name) + " has been unequipped.")
        input("Press Enter to continue...")

    # Not going to be implemented, not enough time
    def craftItem(self):
        # Give player list of items able to be crafted and resources required
        # Check player inventory for resources
        # Remove those resources, add new item
        # Increment XP
        # If player tries to craft item they don't have resources for, restart crafting
        pass

class Enemy():

    def __init__(self, name):
        # Enemy's stats are modified and scaled by the game and the player's stats
        self.name = name
        self.currenthp = 1
        self.maxhp = self.currenthp
        self.currentap = 1
        self.maxap = self.currentap
        self.alive = True # changed if currenthp drops below 1
        self.strength = 1 # determines flat damage output
        self.endurance = 1 # allows for more AP (action points) per combat turn, allowing for more actions, also boosts HP gain/reduces HP loss
        self.agility = 1 # gives a higher probability of being able to attack twice, or dodge an enemies attack
        self.luck = 1 # increases crit chance and rarity of items
        

class Game():
    
    def __init__(self, currentPlayer) -> None:
        self.player = currentPlayer
        self.distance = 0 # determines progression through game, scales enemies
        
    def walkForward(self):
        self.distance += 1
        if self.player.currenthp < self.player.maxhp:
            self.player.currenthp += 1
        print(addFancyThings("You progress through the forest", "*"))
        print("You have walked " + str(self.distance) + "km so far...")
        input("Press Enter to Continue...")
    def findItem(self):
        # Placeholder for chance of enemy spawning when looking for an item
        print(addFancyThings("Looking for item", "*"))
        percEncounter = rand.random()
        if percEncounter > 0.6:
            combat(self.player, self)
        if rand.random() > 0.5:
            print("You wander around the forest and stumble across an item.")
            if rand.random() > 0.5:
                sword_names = [
    "Excalibur",
    "Stormbringer",
    "Frostbite",
    "Shadowstrike",
    "Doombringer",
    "Soulreaper",
    "Dragonfang",
    "Nightfall",
    "Sunblade",
    "Voidrender",
    "Windrider",
    "Bloodthirst",
    "Starfall",
    "Goreblade",
    "Eclipse",
    "Dawnbreaker",
    "Whisperwind",
    "Thunderbolt",
    "Venomstrike",
    "Spectral Edge",
    "Runeblade",
    "Hellfire",
    "Oathkeeper",
    "Dreamslayer",
    "Fateweaver",
    "Grimfang",
    "Harbinger",
    "Bonecrusher",
    "Serpent's Bite",
    "Darkheart",
    "Skysteel",
    "Flameburst",
    "Death's Embrace",
    "Frostfang",
    "Wraithblade",
    "Moonshadow",
    "Obsidian Edge",
    "Bloodmoon",
    "Night's Whisper",
    "Dreadscythe",
    "Voidblade",
    "Silent Death",
    "Ragefire",
    "Lightning Fury",
    "Dragonfire",
    "Sunspear",
    "Soulshatter",
    "Stargazer",
    "Twilight's Call",
    "Shadowstrike",
    "Thunderclap",
    "Inferno",
    "Blazefury",
    "Iceshatter",
    "Frostbite",
    "Whirlwind",
    "Vorpal Blade",
    "Ebonrazor",
    "Windchill",
    "Bloodlust",
    "Skysplitter",
    "Shadowflame",
    "Doomhammer",
    "Hellforge",
    "Starfury",
    "Dreadbane",
    "Heartseeker",
    "Voidstorm",
    "Frostreaver",
    "Soulflayer",
    "Darkbane",
    "Stormcaller",
    "Oblivion",
    "Blackthorn",
    "Venomspine",
    "Moonlight",
    "Starseeker",
    "Abyssal Edge",
    "Bloodborn",
    "Skyslicer",
    "Ebonblade",
    "Nethersteel",
    "Sunflare",
    "Soulcleaver",
    "Shadowmourne",
    "Doomsayer",
    "Voidwalker",
    "Frostwind",
    "Stormblade",
    "Dragonclaw",
    "Nightslayer",
    "Eclipse",
    "Bloodforge",
    "Grimslayer",
    "Whisperblade",
    "Thunderstrike",
    "Dreadblade",
    "Flamefang",
    "Windwalker"
]
                newSword = Item(rand.choice(sword_names), rand.randint(1,5), "weapon", (rand.randint(1,int((rand.random()+1)*self.player.lvl))))
                self.player.inventory.append(newSword)
                print(str(newSword.name) + " added to inventory.")
            else:
                armor_names = [
    "Dragonscale Mail",
    "Shadowcloak",
    "Titanium Platemail",
    "Stormguard Plate",
    "Phoenix Guard",
    "Frostforged Armor",
    "Demonhide Vest",
    "Celestial Plate",
    "Moonshadow Robes",
    "Soulstone Armor",
    "Voidwalker Garb",
    "Fireborn Plate",
    "Obsidian Shell",
    "Aegis of Valor",
    "Thunderstruck Plate",
    "Sunfire Mantle",
    "Darksteel Plate",
    "Spiritforge Mail",
    "Dreadplate Armor",
    "Blazeguard Mail",
    "Skyward Defender",
    "Ghostwalker Cloak",
    "Icebound Plate",
    "Serpent Scale Armor",
    "Starlight Shroud",
    "Bloodmoon Plate",
    "Windchaser Armor",
    "Nethersteel Mail",
    "Shadowweave Robes",
    "Titanic Scale Armor",
    "Stormcloak",
    "Flamekeeper's Plate",
    "Runebound Armor",
    "Whirlwind Mail",
    "Voidheart Vestments",
    "Phoenixscale Armor",
    "Twilight Cloak",
    "Dragonbone Plate",
    "Nightfall Robes",
    "Sunshard Armor",
    "Eclipse Guard",
    "Frostbite Mail",
    "Doomguard Plate",
    "Mystic Mantle",
    "Blackthorn Mail",
    "Thunderbolt Armor",
    "Soulbound Plate",
    "Deathshroud Cloak",
    "Bladewalker Armor",
    "Firestorm Plate",
    "Dreadshadow Cloak",
    "Shadowflame Armor",
    "Celestial Robes",
    "Moonlit Mail",
    "Soulweave Cloak",
    "Voidborn Plate",
    "Starcaller Mantle",
    "Bloodfury Armor",
    "Windwalker Vest",
    "Nightsong Mail",
    "Abyssal Plate",
    "Frostguard Armor",
    "Doombringer Cloak",
    "Spectral Armor",
    "Dragonhide Vestments",
    "Skysunder Plate",
    "Ebonsteel Mail",
    "Netherweave Robes",
    "Stormwrath Plate",
    "Flamestrike Armor",
    "Shadowbound Cloak",
    "Titanforged Mail",
    "Sunshadow Robes",
    "Eclipsed Armor",
    "Frostward Cloak",
    "Darkstorm Plate",
    "Bloodfrost Mail",
    "Twilightweave Robes",
    "Soulreaver Plate",
    "Voidscale Armor",
    "Phoenixguard Cloak",
    "Thunderclad Mail",
    "Abyssal Shroud",
    "Windwhisper Armor",
    "Nightshade Robes",
    "Doomcloak",
    "Starborn Plate",
    "Celestial Mantle",
    "Moonshroud Armor",
    "Shadowfrost Cloak",
    "Blazeforged Mail",
    "Skyshatter Armor",
    "Dreadshade Robes",
    "Soulkeeper Plate",
    "Voidwalker's Mantle",
    "Frostflame Armor",
    "Doomward Cloak",
    "Bloodbound Mail",
    "Necrotic Plate"
]
                newArmor = Item(rand.choice(armor_names), 0, "armor", rand.randint(1,10))
                self.player.inventory.append(newArmor)
                print(str(newArmor.name) + " added to inventory.")
        else:
            print("You have wasted your time aimlessly walking around the forest. You have found nothing.")
        input("Press Enter to continue...")

class Item():
    
    def __init__(self, name, apCost, type, debuff):
        self.name = name
        # Bools to let inventory know difference between resource and item
        self.isItem = True
        self.isResource = False
        self.apCost = apCost
        self.type = type
        if type == "armor":
            self.armorDebuff = debuff
        elif type == "weapon":
            self.weaponDebuff = debuff
        self.isEquipped = False

# Not going to be properly implemented in time, too much additional logic required at this time
# class Resource():

#     def __init__(self, name, type):
#         self.name = name
#         # Bools to let inventory know difference between resource and item
#         self.isItem = False
#         self.isResource = True
#         self.type = type
        
        
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

# Simple function to check user input so that way I don't need to type out this try-except a million times
def checkUserInput():
    while True:
        try:
            selection = int(input("Enter a number: "))
            break
        except ValueError:
            print("Selection not understood, please try again.")
    return selection


def coreGame(me, game):
    while True:
        os.system('clear')
        print(addFancyThings("Status Report", "-"))
        # Print character stats to terminal to let player know their stats/hp
        me.displayStats()
        print("Distance Travelled: " + str(game.distance) + "km")
        print(addFancyThings("", "-"))
        # Give player option to move forward, check inventory, look around for items, or craft items
        print("1: Open Inventory Menu") # Functional
        # print("2: Open Crafting Menu")
        print("2: Look for Items")
        print("3: Continue Pressing Onward")
        print("4: End Your Journey")
        actionSelection = checkUserInput() # reference to input function
        if actionSelection == 1:
            # newItem = Item("Sword")
            # me.inventory.append(newItem)
            me.displayInventory()
        elif actionSelection == 2:
            game.findItem()
        # elif actionSelection == 3:
        elif actionSelection == 3:
            # When looking around or moving forward, higher probability of encountering enemy
            percEncounter = rand.random()
            if percEncounter > 0.6:
                combat(me, game)
            game.walkForward()
        elif actionSelection == 4:
            break
        else:
            print("Yo, that's not an option...")
        # When looking in inventory or crafting, lower probability of encountering enemy

    pass

def combat(me, game):
    # Generate new Enemy instance with random name from list
    # Generated from ChatGPT 3.5 prompt "Create a list of random 100 fantasy enemy names in a bracket encapsulated, comma separated list with each name in quotes"
    potentialNameList = [
  "Zarog the Shadowcaster",
  "Grimmok the Bloodthirsty",
  "Sylvana the Enchantress",
  "Thornax the Thorned",
  "Malphas the Darkwing",
  "Vorax the Devourer",
  "Eldritch the Soulless",
  "Nyxia the Nightwalker",
  "Ignatius the Infernal",
  "Ragnor the Reckoner",
  "Drakara the Dreaded",
  "Mordred the Malevolent",
  "Lilith the Temptress",
  "Grendor the Ghastly",
  "Zephyra the Stormbringer",
  "Skaar the Skullcrusher",
  "Fenrir the Fangbearer",
  "Cyrax the Corrupted",
  "Havoc the Harbinger",
  "Valeria the Vile",
  "Karnak the Cursed",
  "Azazel the Fallen",
  "Netheron the Shadowfiend",
  "Thalador the Twisted",
  "Morogar the Malignant",
  "Vexia the Venomous",
  "Zarathos the Inferno",
  "Sindra the Siren",
  "Golgoth the Grim",
  "Necros the Necromancer",
  "Xerxes the Exiled",
  "Lysandra the Lich",
  "Morgath the Malefic",
  "Venomar the Vicious",
  "Spikejaw the Spinecrusher",
  "Mystara the Malevolent",
  "Gloomfang the Gruesome",
  "Razorwing the Ravager",
  "Draven the Deathbringer",
  "Zaladar the Zealot",
  "Vorath the Voidwalker",
  "Dreadclaw the Darkspawn",
  "Crimsonbane the Corruptor",
  "Nyxar the Nightstalker",
  "Varathar the Vanquisher",
  "Thornblade the Treacherous",
  "Nocturna the Nightshade",
  "Ragefire the Ruthless",
  "Grimclaw the Grim",
  "Xanathar the Xerxes",
  "Valkor the Vanquisher",
  "Ravenna the Rogue",
  "Grimgar the Grotesque",
  "Zaros the Zealot",
  "Soulreaver the Shadow",
  "Azura the Azure",
  "Mortis the Malevolent",
  "Necrosia the Necromancer",
  "Ragnok the Ravager",
  "Sylvanus the Sylvan",
  "Vexia the Vexing",
  "Grendel the Ghastly",
  "Thornstrike the Thorny",
  "Havoc the Hateful",
  "Morghul the Malefic",
  "Xeraphim the Exalted",
  "Vorax the Vortex",
  "Zephyrion the Zephyr",
  "Necroshade the Shadowcaster",
  "Dreadmaw the Dreaded",
  "Korvath the Corrupted",
  "Sindarin the Sable",
  "Malachi the Malevolent",
  "Vorador the Vindicator",
  "Xanathor the Xerxes",
  "Ragnara the Ravager",
  "Sableye the Shadow",
  "Vortexia the Voracious",
  "Nyxaris the Nightmarish",
  "Grimmjaw the Grim",
  "Thornspine the Thorny",
  "Havocar the Harbinger",
  "Morghast the Malefic",
  "Xeros the Exiled",
  "Vorakor the Vanquisher",
  "Zarathan the Zealot",
  "Sindri the Sulfurous",
  "Necronis the Necromancer",
  "Ravageclaw the Ruthless",
  "Sylvador the Sylvan",
  "Vexar the Vexing",
  "Grendorath the Ghastly",
  "Thornwrath the Thorny",
  "Havocorn the Hateful",
  "Mordrim the Malefic",
  "Xerathar the Exalted",
  "Voraxius the Vortex",
  "Zephyros the Zephyr",
  "Necrotor the Shadowcaster",
  "Dreadshade the Dreaded",
  "Korvax the Corrupted",
  "Sindarok the Sable",
  "Malagor the Malevolent",
  "Vorathor the Vindicator"
]

    myAdversary = Enemy(rand.choice(potentialNameList))
    # Adjust enemies stats based on XP and distance travelled
    myAdversary.strength = int(myAdversary.strength + (0.08 * game.distance) * (0.08 * me.xp) * rand.random())
    myAdversary.endurance = int(myAdversary.currenthp + (0.08 * game.distance) * (0.08 * me.xp) * rand.random())
    myAdversary.agility = int(myAdversary.agility + (0.08 * game.distance) * (0.08 * me.xp) * rand.random())
    myAdversary.luck = int(myAdversary.luck + (0.08 * game.distance) * (0.08 * me.xp) * rand.random()) 
    myAdversary.currenthp = int(myAdversary.endurance + (0.08 * game.distance) * (0.08 * me.xp) * rand.random())
    myAdversary.maxhp = myAdversary.currenthp
    myAdversary.currentap = int(myAdversary.currentap + (0.08 * game.distance) * (0.08 * me.xp) * rand.random()) 
    myAdversary.maxap = myAdversary.currentap
    # While loop that is broken when either enemy or player is dead
    while myAdversary.alive == True:
        # Clear screen and print enemy information and actions available
        os.system('clear')
        print(addFancyThings("An Enemy Has Appeared!", "*"))
        print(addFancyThings(myAdversary.name, "-"))
        print(str(myAdversary.name) + "'s HP: " + str(myAdversary.currenthp) + "/" + str(myAdversary.maxhp))
        print(str(myAdversary.name) + "'s AP: " + str(myAdversary.currentap) + "/" + str(myAdversary.maxap))
        print(addFancyThings("", "-"))
        print("Your HP: " + str(me.currenthp) + "/" + str(me.maxhp))
        print("Your AP: " + str(me.currentap) + "/" + str(me.maxap))
        print(addFancyThings("", "-"))
        print("1: Attack")
        print("2: Check Inventory")
        # print("3: Attempt Intimidate")
        print("3: Retreat")
        combatSelection = checkUserInput()
        # If choosing to attack
        if combatSelection == 1:
            # Check to see if player has enough action points to attack with current weapon
            if len(me.weapon) > 0:
                if me.currentap >= me.weapon[0].apCost:
                    me.currentap -= me.weapon[0].apCost
                    if rand.random() * me.agility >= 0.7 and rand.random() * myAdversary.agility >= 0.3:
                        # Combat damage is dealt
                        myAdversary.currenthp -= me.strength
                        print("You did " + str(me.strength) + " damage to " + str(myAdversary.name))
                    else:
                        print(str(myAdversary.name) + " dodged your attack!")
                else:
                    print("You do not have enough AP to attack with your current weapon.")
            else:
                if rand.random() * me.agility >= 0.7 and rand.random() * myAdversary.agility >= 0.3:
                    # Combat damage is dealt
                    myAdversary.currenthp -= me.strength
                    print("You did " + str(me.strength) + " damage to " + str(myAdversary.name))
                else:
                    print(str(myAdversary.name) + " dodged your attack!")
            # Roll to see if either attack is dodged or if player/enemy missed
        # If choosing to open inventory
        if combatSelection == 2:
            if me.currentap >= 2:
                me.displayInventory()
                me.currentap -= 2
        # if combatSelection == 3:
        #     print("Intimidation failed (for now, we haven't implemented it as a feature)")
        if combatSelection == 3:
            # print("You cannot retreat yet. Sorry. (We haven't made this feature yet)")
            if rand.random() * me.agility >= 0.7 and rand.random() * myAdversary.agility >= 0.3:
                print("You have successfully retreated. You gain no XP.")
                break
            else:
                print("You're not fast enough, and you failed to retreat.")
        if rand.random() * myAdversary.agility >= 0.7 and rand.random() * me.agility >= 0.3:
            me.currenthp -= myAdversary.strength
            print(str(myAdversary.name) + " did " + str(myAdversary.strength) + " damage to you")
        else:
            print("You dodged " + str(myAdversary.name) + "'s attack!")
        # Check to see if enemy or player is dead
        if me.currenthp <= 0:
            me.alive = False
            endOfGame(me, game)
        elif myAdversary.currenthp <= 0:
            myAdversary.alive = False
            print("You slayed " + str(myAdversary.name) + "!")
            xp = math.ceil(myAdversary.strength * 0.5)
            print("You gained " + str(xp) + " xp.")
            me.xp += xp
            me.xpSinceLastLevel += xp
            me.checkLevel()
        if me.currentap <= 0:
            me.currentap = me.maxap
        input("Press Enter to Continue...")

def main():
    print("Welcome to Fight Sim Game v.0.0 prebeta")
    myName = input("What's your name, yo? ")
    me = Player(myName)
    game = Game(me)
    coreGame(me, game)
    endOfGame(me, game)
    
def endOfGame(me, game):
    # End game
    print(addFancyThings(" YOU DIED ", "*"))
    print("The End.")
    print("You Lost.")
    print("That Sucks.")
    print(addFancyThings("", "*"))
    # Print stats
    print("XP: " + str(me.xp))
    print("Level: " + str(me.lvl))
    print("Distance Travelled: " + str(game.distance))
    # Prompt user to restart with this character or choose a new one or quit
    print("Would you like to restart or exit?")
    print("1: Restart")
    print("2: Exit")
    endSelection = checkUserInput()
    while True:
        if endSelection == 1:
            print("Just kidding, we haven't figured out how to restart the game yet. Just launch it again.")
            # os.system('./home/elidrom/Documents/cs430/cs430/python/fightSimGame.py')
            exit()
        if endSelection == 2:
            exit()
        else:
            continue

main()