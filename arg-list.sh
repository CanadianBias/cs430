#!/bin/bash

# A simple program that outputs command line arguments with a for loop

# DEFINE FUNCTIONS BEFORE THEY ARE USED

function name {
	echo "I'm in a function $1"
}

name2 () {
	local arg=0
	echo "I'm in another function $arg"
}


for arg in $*
do
	echo $arg
	name $arg
	name2 $arg
done
