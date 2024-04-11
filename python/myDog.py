#!/usr/bin/python3

# Creating a class for dog objects

from random import randint, choice

class Dog():
    def __init__(self, breed, colour, name): # Constructor
        self.br = breed
        self.cl = colour
        self.nm = name
        # Additional properties that are not parameterized
        self.age = 0
        self.energy = 10
        self.food = 10
        self.hydration = 10
        self.hunger = 0
        self.thirst = 0
        self.pottyTrained = False
    def bark(self):
        print(str(self.nm.capitalize()) + " is barking.")
        # print("Woof!")
    def growl(self):
        print(str(self.nm.capitalize()) + " is growling.")
        # print("Grrrrr!")
    def whine(self):
        print(str(self.nm.capitalize()) + " is whining.")
    def sleep(self):
        print(str(self.nm.capitalize()) + " is sleeping.")
        self.energy += 10
    def eat(self):
        print(str(self.nm.capitalize()) + " is eating.")
        self.hunger = 0
        self.food -= 1
    def drink(self):
        print(str(self.nm.capitalize()) + " is drinking.")
        self.thirst = 0
        self.hydration -= 1
    def update(self):
        # method that controls what the dog does moment by moment
        # if the dog has energy, bark
        if randint(1,100) > 60:
            if self.energy > 0:
                self.bark()
            # otherwise, sleep
            else:
                self.sleep()
        # if hungry, eat/whine
        if randint(1,100) < 30:
            if self.hunger > 0 and self.food > 0:
                self.eat()
            elif self.hunger > 0 and self.food == 0:
                self.whine()
        # if thirsty, drink/whine
        if randint(1,100) < 50:
            if self.thirst > 0 and self.hydration > 0:
                self.drink()
            elif self.thirst > 0 and self.hydration == 0:
                self.whine()
        # increase age of dog
        self.energy -= 1
        self.age += 1
        self.hunger += 1
        self.thirst += 1
        # run around
        input()

def main():
    breedList = ['French Bulldog', 'Labrador Retriever', 'Golden Retriever', 'German Shepherd', 'Poodle', 'Bulldog', 'Rottweiler', 'Beagle', 'Dachshund', 'German Shorthair Pointer']
    colorList = ['Red', 'Green', 'Blue', 'Yellow', 'Orange', 'Violet', 'White', 'Black', 'Purple', 'Beige', 'Gold', 'Grey', 'Brown', 'Silver']
    nameList = ['Bella', 'Luna', 'Max', 'Daisy', 'Charlie', 'Coco', 'Buddy', 'Lucy', 'Milo', 'Bailey']
    dogList = []
    dogmeat = Dog("german shepherd", "brown", "dogmeat")
    penny = Dog("schnauzer", "black and white", "penny")
    clifford = Dog("big", "red", "clifford")
    dogList.append(dogmeat)
    dogList.append(penny)
    dogList.append(clifford)

    for i in range(12):
        newDog = Dog(choice(breedList), choice(colorList), choice(nameList))
        dogList.append(newDog)
    
    while True:
        for i,dog in enumerate(dogList):
            dog.update()
            x = randint(1,100)
            if x > 90:
                print(str(dog.nm.capitalize()) + " has exploded.")
                dogList.remove(dogList[i])
            if dog.age > 20:
                print(str(dog.nm.capitalize()) + " has died of old age.")
                dogList.remove(dogList[i])
            
        if len(dogList) == 0:
            break

        
        
main()