#!/bin/bash

# Calculates possible subnet configurations based on given IP and netmask
# Can calculate based on number of devices per network desired
# Can calculate based on number of networks desired


# Function from utils.sh for adding borders
# Takes two parameters, the character to make the border, and the title (can be a blank string) to put in the middle
function addFancyThings {
	local char=$1
	local title=$2
	local titleLen=${#title}
	local stopPoint=$[(COLUMNS-titleLen)/2]
	local line
	for ((i=0;i<$stopPoint;i++)); do
		line+=$char
	done
	line+=$title
	for ((j=${#line};j<$COLUMNS;j++)); do
		line+=$char
	done
	echo $line
}

# Utilizes global variables
function convertNetmask {
#Convert slash notation to netmask
#Assumes slash is non-zero
#Convert slash notation to netmask
        for ((i=0;i<4;i++)); do
                if [[ slash -ge 8 ]]; then
                        netmask[$i]=255
                        slash=$[slash-8]
                else
                        case $slash in 
                                0 ) netmask[i]=0;;
                                1 ) netmask[i]=128;;
                                2 ) netmask[i]=192;;
                                3 ) netmask[i]=224;;
                                4 ) netmask[i]=240;;
                                5 ) netmask[i]=248;;
                                6 ) netmask[i]=252;;
                                7 ) netmask[i]=254;;
                        esac
			slash=0
                fi
	done
}

clear

addFancyThings "*" "Subnet Calculator"

# Override IFS to seperate addresses on dots
oldIFS=$IFS

# Check for CLAs and populate IP and NetMask
if [[ $# -eq 0 ]]; then
	IFS="."
	echo -n "Enter your IP address: "
	read -a IP
	echo -n "Enter your Netmask: "
	read netmaskInput
	case $netmaskInput in
                255.*.*.* ) read -a netmask <<< $netmaskInput;;
                /* ) slash=${2:1}
                        #Convert slash notation to netmask
                        convertNetmask;;
                [0-9] | [0-3][0-9] | 30 ) slash=$netmaskInput
                        #Convert slash notation to netmask
                        convertNetmask;;
                [aAbBcC] ) case $netmaskInput in
                        [aA] ) slash=8;;
                        [bB] ) slash=16;;
                        [cC] ) slash=24;;
                        esac
                        convertNetmask;;
        esac
	IFS=$oldIFS
# The elif below needs error checking:
	# Did they give me an IP, netmask, IP/bits?
	# What do I do with what they gave me
elif [[ $# -eq 1 ]]; then
	case $1 in
		*.*.*.*/* ) IFS="./"
			read -a IP <<< $1 # gives five element array
			IFS=$oldIFS
			slash=${IP[4]}
			convertNetmask;;
		255.*.*.* ) read -a netmask <<< $1
			echo -n "Enter your IP address: "
			read -a IP;;
		*.*.*.* ) read -a IP <<< $1
			echo -n "Enter your Netmask: "
      			read netmaskInput
       			case $netmaskInput in
                		255.*.*.* ) read -a netmask <<< $netmaskInput;;
                		/* ) slash=${2:1}
                        		#Convert slash notation to netmask
                	        	convertNetmask;;
         	      	 	[0-9] | [0-3][0-9] | 30 ) slash=$netmaskInput
                       		 	#Convert slash notation to netmask
                       		 	convertNetmask;;
               		 	[aAbBcC] ) case $netmaskInput in
                	        	[aA] ) slash=8;;
	                        	[bB] ) slash=16;;
        	                	[cC] ) slash=24;;
                	        	esac
				        convertNetmask;;
			esac
	esac
	IFS=$oldIFS
elif [[ $# -eq 2 ]]; then
	IFS="."
	read -a IP <<< $1 # <<< redirects as input
	#read -a netmask <<< $2
	# Dr. Elliot's in-class example (that's probably better than mine)
		case $2 in
		255.*.*.* ) read -a netmask <<< $2;;
		/* ) slash=${2:1}
			#Convert slash notation to netmask
			convertNetmask;;
		[0-9] | [0-3][0-9] | 30 ) slash=$2
			#Convert slash notation to netmask
			convertNetmask;;
		[aAbBcC] ) case $2 in
			[aA] ) slash=8;;
			[bB] ) slash=16;;
			[cC] ) slash=24;;
			esac
			convertNetmask;;
	esac
	IFS=$oldIFS
fi # should now have two arrays with the info

# Calculate NetID from IP and netmask
for ((i=0;i<4;i++)); do
	octet=${IP[i]}
	mask=${netmask[i]}
	network[i]=$[octet & mask] #bitwise AND
	#if [[ $mask -eq 255 ]]; then
	#	slash=$[slash+8]
	#else

	#fi
	case $mask in
		255 ) slash=$[slash+8];;
		254 ) slash=$[slash+7];;
		252 ) slash=$[slash+6];;
		248 ) slash=$[slash+5];;
		240 ) slash=$[slash+4];;
		224 ) slash=$[slash+3];;
		192 ) slash=$[slash+2];;
		128 ) slash=$[slash+1];;
		0 ) slash=$[slash];;
		* ) echo "The  subnet mask was entered incorrectly. Please reload the program."
			exit;;
	esac
done

# origAddresses=$(bc -l <<< "l(32-$slash)/l(2)")
# Calculates number of IP addresses available under the original network
origAddresses=$[2**(32-slash)]

addFancyThings "-" "Calculating Network ID"

echo "Network ID: ${network[0]}.${network[1]}.${network[2]}.${network[3]}/$slash"
echo "Netmask: ${netmask[0]}.${netmask[1]}.${netmask[2]}.${netmask[3]}"
echo "# of available addresses on this network: $[origAddresses-2]" 

addFancyThings "-" ""

echo "Would you like to subnet this network based on networks (1) or devices (2) ?"
echo -n "(1/2): "
read option

if [[ $option -eq 1 ]]; then
	echo ""
elif [[ $option -eq 2 ]]; then
	echo -n "How many devices would you like each network to have: "
	read num
	bitsNeeded=$(bc -l <<< "(l($num)/l(2))")
	echo $bitsNeeded
fi

# echo "The Network ID of $1 is ${network[0]}.${network[1]}.${network[2]}.${network[3]}/$slash"