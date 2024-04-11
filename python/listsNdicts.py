#!/usr/bin/python3

# Demo lists and dictionairies

list1 = ["Ryzen 5", "Ryzen 7", "Ryzen 9"]

print(list1)
for val in list1:
    print(val)

for index,value in enumerate(list1):
    print(str(index) + ": " + str(value))

print(list1[2])

list1.append("Ryzen 11")
list1.insert(0,"Ryzen 3")
# list1.remove("Ryzen 11")
# list1.pop(3)
print(list1)

# Creative list indexes

print(list1[-2])
print(list1[2:])
print(list1[:2])
print(list1[1:3])
for i in range(3):
    list1.append("Ryzen " + str(i))
print(list1[2:-2])

print("========================================================================================================================================================================")

dict1 = {"Samuel":"Coniglio","Elijah":"Dromarsky","Harley":"Locklear","Abilene":"Mast"}
print(dict1.keys())
print(dict1.values())
list2=[]
for i in dict1.keys():
    list2.append(i)
print(dict1[list2[1]])
print(dict1["Samuel"])
dict1.update({"Stephen":"Elliot"})
for k,v in dict1.items():
    print(k,v)

print("========================================================================================================================================================================")

string1 = "This is a string of words!"
print(string1[0])
print(string1[3:12])
print(string1[:9])

string2 = string1[:3] + "r" + string1[4:]
print(string2)

print(string1.upper())
print(string1.lower())

list3=string1.split('i')
print(list3)

list4=string1.partition('i')
print(list4)

print(' '.join(list1))

list5=string1.split(" ")
print(list5)
print(" ".join(list5))