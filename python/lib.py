#!/usr/bin/python3

# Add libraries with import
import random
import os
import sys
import pyperclip as clip
import webbrowser as web
from selenium import webdriver

def main():
    # Pyperclip test
    print(clip.paste())
    clip.copy("Copy this.")
    print(clip.paste())

    # Webbrowser test
    web.open("https://people.emmaus.edu/cs460/edromarsky")

def modWeb(): # Doesn't work
    browser = webdriver.Firefox()
    browser.get("https://people.emmaus.edu/cs460/edromarsky")

# modWeb()
main()

