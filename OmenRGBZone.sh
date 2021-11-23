#!/bin/bash

: '
    HP-OMEN-Linux-RGBColour-ChangerScript

    Copyright (C) 2021  JesusXD88 & Luigi

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.
'   

# zone00 -> Left | zone01 -> Middle | zone02 -> Right | zone03 -> WASD

# This script will save log into log.txt in the same dir of this script
# Log File
LOG="log.txt"
# Config Dir
CONFIGDIR=./.config/OmenRGBZone
# Profiles Dir
PROFILESDIR=./profiles
# Color Presets Dir
COLORDIR=./colors
# Kernel Module Kir
MODULEDIR=/sys/devices/platform/hp-wmi/rgb_zones/
function log() { 
	echo -e $(date) " | " $@ >> $LOG 
}

ARGS=false

# Starting Log
echo "$(date)" > $LOG
log "Starting Logging"

#################################################################################
#	This script now supports language					#
#	It automatically detects your language by using ${LANG:0:2}		#
#	After that, it reads all variable from lang file (ex ./lang/en.sh)	#
#	and use for echo messages						#
#################################################################################

#Here are the lang files for this script
LANGUAGE=${LANG:0:2}

if [[ -f ./lang/$LANGUAGE.sh ]]; then
	log "Language Found! Using $LANGUAGE"
	source ./lang/$LANGUAGE.sh
else
	#Using Default Eng en
	log "Language not Found! Using default eng"
	source ./lang/en.sh
fi

#################################
# Main function of the script	#
# It will show all you can do	#
# with this script, will prompt	#
# a read so you can choose	#
# through all options.		#
#################################
function main() {
    clear
    log "Starting Main"
    echo -e $wellcomeMessage
    if [[ "$EUID" != 0 ]]; then
        echo -e $rootMessage
        log "No Root, will exit"
        exit 1
    fi 
    checker=true
    while [[ $checker != false ]]
    do
	log "Root detected, proceed to main"
	checkModuleInstalled
	if [[ ! moduleInstalled ]]; then echo -e '1.' $installModule; else echo -e '1.' $reinstallModule; fi
        echo -e '2.' $changeCurrentColours
        echo -e '3.' $saveCurrentColours
        echo -e '4.' $createNewConfig
        echo -e '5.' $applyExistingConfig
        echo -e '0.' $exit '\n\n'
        read -p "=> " option
        if  [[ "$option" =~ ^[0-5]+$ ]]; then checker=false; else echo -e $incorrectOptionMain; fi
    done

    case "$option" in
    	1)
    		driverInstaller
            	;;
        2)
        	zoneSelector
        	;;
        3)	
        	log 'save current choice'
		echo -e $doubleSpace
		read -p "$inputNameConfig" name
        	saveCurrent $name
        	;;
        4)
        	createProfile
        	;;
        5)
        	applyProfile
        	;;
        0)
        	echo -e $exiting
            	log 'exit choice, will exit'
            	sleep 0.3
            	exit 0
            	;;
        esac
}

#################################################################################
# This function will check if the Kernel Module (thanks to pelrun@github	#
# is installed. If the Module is installed, it will store a variable, else it	#
# will show the user that the Module isn't installed, and will promt a question	#
# do yoy want to install it?							#
#################################################################################

function checkModuleInstalled() {
	if [[ -d '/sys/devices/platform/hp-wmi/rgb_zones/' ]]; then
		log "Module Installed"
        	moduleInstalled=true
        	log 'will create default profile'
        	if [[ ! -f $PROFILESDIR/default ]]; then
        		echo -e $defaultProfileCreated './profiles/default'
        		saveCurrent default
        	fi
        else
        	log "Module not found!"
        	echo -e $moduleNotInstalled
        	read -p "$firstInstallModule: " install
        	case ${answer:0:1} in
		    	$y|${y^^}|y|Y )
			log 'Ok, your choice is yes, driver will be reinstalled'
			installDriver
	    		;;
	    	* )
			log "So we doesn't install driver, will exit"
			exit 0
	    		;;
		esac
        	moduleInstalled=false
        fi
}

#Function that will clone the Kernel module's repository, build and install it.
#Thanks to pelrun (https://github.com/pelrun/hp-omen-linux-module)

#########################################################################
# This function is called in main, after it checks the module		#
# If the module is installed yet, it will promt a request that		#
# ask the user if he want to install it again, else it will install 	#
#########################################################################

function driverInstaller() {
    	clear
    	log 'Driver Install Selection'
    	checkInstallation
}

function checkInstallation() {
	log 'Check Installation'
	if [[ moduleInstalled ]]; then
		read -p "$moduleInstalledYet: " answer
		case ${answer:0:1} in
		    	$y|${y^^}|y|Y )
			log 'Ok, your choice is yes, driver will be reinstalled'
			installDriver
	    		;;
	    	* )
			log "So we doesn't install driver"
			main
	    		;;
		esac
	else installDriver; fi
}

#################################################
# This function serve as installer		#
# Will check if git command is installed	#
# then will clone pelrun git repo and install	#
#################################################

function installDriver() {
	log 'Install Driver'
	echo -e $installingDriver
	if [[ -d "hp-omen-linux-module" ]]; then rm -rf hp-omen-linux-module; fi
	if checkCommandExists git ; then
		git clone https://github.com/pelrun/hp-omen-linux-module.git
	else echo -e $gitNotInstalled; fi
	cd hp-omen-linux-module
	make install
	if [ $? -eq 0 ]; then echo -e $driverInstalled; sleep 3; main
	else echo -e $driverError; main; fi
    	
}

function checkCommandExists() {
	if ! [ -x "$(command -v $1)" ]; then
	    log "$1 could not be found"
	    return false
	else return true; fi

}

#################################################
# This function serve as a zone selector	#
# It is called in main				# 
#################################################
function zoneSelector() {
    echo -e $selectZone
    echo -e '1.' $zone1
    echo -e '2.' $zone2
    echo -e '3.' $zone3
    echo -e '4.' $zone4
    echo -e '5.' $allZones
    
    echo -e "\n\n"
    read -p "=> " zona
    zoneSwitchRecursive
    clear
}

#Function that will stablish the RGB zone

function zoneSwitchRecursive() {
	case "$zona" in
		"1")
			zone="zone02"
			colourInputChooser
			;;
		"2")
			zone="zone03"
			colourInputChooser
			;;
		"3")	
			zone="zone01"
			colourInputChooser
			;;
		"4")
			zone="zone00"
			colourInputChooser
			;;
		"5"|'all')
			zone="all"
			echo -e $allZonesSelected
			colourInputChooser
			;;
		*)
			echo -e $invalidInput
			read -p "=> " zona
			zoneSwitchRecursive
			;;
	esac

}	




function colourInputChooser() {
	checker=true
	while [[ $checker != false ]]
	do
		echo -e $chooseWay
        	echo -e '1.' $presetsWay
       		echo -e '2.' $manualWay
       		if [[ $PROFILECREATION == true ]]; then echo -e '3.' $comeBackProfile
       		else
	       		echo -e '3.' $returnToMain
	       	fi
	        read -p "=> " option
	        [[ "$option" =~ ^[1-3]+$ ]]; checker=false
    	done
	
	case "$option" in
		"1")
			colourChangerPresets
			;;
		"2")
			colourChangerManually
			;;
		"3")
			if [[ $PROFILECREATION == true ]]; then createProfile; else main; fi
			;;
    		esac
}

function show_colour() {
    perl -e '$i = 1;
    		foreach $a(@ARGV){
    			print "$i. \e[48:2::".join(":",unpack("C*",pack("H*",$a)))."m   \e[49m";
    			if (($i%10)!=0) {
			    print " | "
			} else {
			    print "\n\n"
			}
    			$i++;
    		};
    		print "\n"' "$@"
}

function colourChangerPresets() {
	#	Red - Candy Apple - Ferrari-Coral   -Orange- dark org- chrome y- 
	echo -e ''
	
	colors=("FF0000" "FF0800" "FF1C00" "FF7F50" "FF7F00" "FF8C00" "FFA700" "FF6700" "00FF00" "1256E2" 
		"800000" "A52A2A" "FF4500" "FF8C00" "FFA500" "FFD700" "B8860B" "FFFF00" "9ACD32" "7CFC00"
		"006400" "008000" "00FF00" "98FB98" "00FA9A" "3CB371" "008080" "00FFFF" "40E0D0" "4682B4"
		"1E90FF" "000080" "0000CD" "0000FF" "8A2BE2" "8B008B" "9400D3" "800080" "FF00FF" "C71585"
		"8B4513" "A0522D" "D2691E" "CD853F" "708090")
	show_colour ${colors[*]}
	read -p "=> " opt
	if [[ $PROFILECREATION == true ]]; then saveCustomizedProfile ${colors[opt-1]}; else colourChanger ${colors[opt-1]}; fi
}


#Function that will let you to manually enter the desired colour

function colourChangerManually() {
    echo -e $inputCustomColorHex
    read -p "=> " colorRGB
    
    clear
    if [[ $PROFILECREATION == true ]]; then saveCustomizedProfile $colorRGB; else colourChanger $colorRGB; fi
}

function manageUserPresets() {
	if [[ -d $PROFILESDIR/ ]]; then
		echo ''
	fi
}

function colourChanger() {
	echo -e $changingRGBColor
    	if [[ $zone == "all" ]]; then
	    	for file in /sys/devices/platform/hp-wmi/rgb_zones/*; do
  			sudo bash -c " echo '$1' > $file"
		done
	else 
		if [[ $zone == "1" ]]; then zone="zone02"
		elif [[ $zone == "2" ]]; then zone="zone03"
		elif [[ $zone == "3" ]]; then zone="zone01"
		elif [[ $zone == "4" ]]; then zone="zone00"
		fi
		sudo bash -c " echo '$1' > /sys/devices/platform/hp-wmi/rgb_zones/$zone"
	fi
    	sleep 1
    	echo -e $succesfullyChangedColor
    	if [[ $ARGS == false ]]; then main; else exit 0; fi
}

function readAndConvert() {
	log 'start read and convert'
	touch "$PROFILESDIR/$1"
	for fzone in $MODULEDIR/*; do
		IFS=',' read -a color <<< $(cat ${fzone})
		RED=$(echo ${color[0]} | sed 's/[^0-9]*//g')
		GREEN=$(echo ${color[1]} | sed 's/[^0-9]*//g')
		BLUE=$(echo ${color[2]} | sed 's/[^0-9]*//g')
		echo $(basename $fzone)'='$(printf %02X%02X%02X $RED $GREEN $BLUE) >> $PROFILESDIR/$1
	done
	log 'profile saved'
	echo -e $profileSaved
	if [[ $ARGS == false ]]; then main; else exit 0; fi
}

function saveCurrent() {
	if [[ ! -d $PROFILESDIR/ ]]; then mkdir $PROFILESDIR; log 'profiles dir absent, creating'; fi
	if [[ -d $MODULEDIR && ! -f $PROFILESDIR/$1 ]]; then readAndConvert $1;
	elif [[ -f  $PROFILESDIR/$1 ]]; then
		echo -e $doubleSpace
		read -p "$existingProfile" opt
		case ${opt:0:1} in
		    	$y|${y^^}|y|Y )
		    	rm -rf $PROFILESDIR/$1
			readAndConvert $1
	    		;;
	    	* )
			echo -e $exiting
			sleep 3
			if [[ $ARGS == false ]]; then main; else exit 0; fi
	    		;;
		esac 
	fi
}

#########################################################
# This function search profiles stored in ./profiles	#
# then prinf all profiles stored with name and values	#
# for each zone. After you can choose a profile, then	#
# the script cut the first element as zone file and the	#
# second element as hex color stored then apply hex	#
# color to file readed.					#
#########################################################

function applyProfile() {
	log 'apply profile choice'
	if [[ ! -n $1 ]]; then
		if [[ -d $PROFILESDIR/ ]]; then
			check=true
			while [[ $check != false ]]; do
				echo -e $selectProfileToApply
				NUM=1
				printProfiles
				read -p "=> " option
			if  [[ -f ${FILES[option]} ]]; then check=false; else echo -e '\n\nIncorrect option!\n\n'; fi
    			done
			while IFS= read -r line; do
				FIL=$(echo $line | sed 's/=.*//')		# Read the file, before = char
				COL=$(echo $line | sed 's#.*=\(\)#\1#')		# Read hex, after = char
				echo $COL > /sys/devices/platform/hp-wmi/rgb_zones/$FIL
			done < "${FILES[option]}"
			echo -e $(basename ${FILES[option]}) 'APPLIED'
			sleep 5
			if [[ $ARGS == false ]]; then main; else exit 0; fi
		else echo -e $profileDirNotExists; sleep 5; main; fi
	else
		if [[ -d $PROFILESDIR/ && -f $PROFILESDIR/$1 ]]; then
			while IFS= read -r line; do
				FIL=$(echo $line | sed 's/=.*//')		# Read the file, before = char
				COL=$(echo $line | sed 's#.*=\(\)#\1#')		# Read hex, after = char
				echo $COL > /sys/devices/platform/hp-wmi/rgb_zones/$FIL
			done < "$PROFILESDIR/$1"
		elif [[ -d $PROFILESDIR/ && ! -f $PROFILESDIR/$1 ]]; then
			echo -e $profileFileNotExists
		else echo -e $profileDirNotExists; fi
	fi
}

###########################################
# This function prints all saved profiles #
# so we call this under apply profile so  #
# we can run both with and without args   #
###########################################

function printProfiles() {
	log 'printing profiles'
	if [[ -d $PROFILESDIR/ ]]; then
		echo -e $profilesString
		NUM=1
		for f in $PROFILESDIR/*; do
			echo  $NUM'. ' $(basename $f)
			echo $(cat $f | sed "s/zone00/$leftZone/g" | sed "s/zone01/$middleZone/g" | sed "s/zone02/$rightZone/g" | sed "s/zone03/$wasdZone/g" )
			echo '-------------------'
			FILES[NUM]=$f
			NUM=$(expr $NUM + 1)
		done
	else
		echo -e $noProfilesCreated
	fi
}

#################################################
# Function that will create custom profile	#
# Asks first if you want to do a 4zone color	#
# else can create a single zone profile		#
#################################################

function createProfile() {
	log 'create profile choice'
	unset PROFILECREATION
	read -p "$createForAllZones: " answer
		case ${answer:0:1} in
		$y|${y^^}|y|Y )
			log 'Ok, all zones'
			PROFILECREATION=true
			profiloZona="all"
			colourInputChooser
	    		;;
	    	* )
			log "for each zone"
			PROFILECREATION=true
			read -p "$zone00Color" z1
			read -p "$zone01Color" z2
			read -p "$zone02Color" z3
			read -p "$zone03Color" z4
			read -p 'set name:' name
			if [[ -d $PROFILESDIR && ! -f $PROFILESDIR/$name ]]; then
	      			echo 'zone00='$z1 $'\nzone01='$z2 $'\nzone02='$z3 $'\nzone03='$z4 > $PROFILESDIR/$name
	      			echo -e $profileCorrectlySaved
	      		elif [[ -d $PROFILESDIR && -f $PROFILESDIR/$name ]]; then
	      			read -p "$existingProfile" opt
				case ${opt:0:1} in
				    	$y|${y^^}|y|Y )
				    	rm -rf $PROFILESDIR/$name
					echo 'zone00='$z1 $'\nzone01='$z2 $'\nzone02='$z3 $'\nzone03='$z4 > $PROFILESDIR/$name
					echo -e $provileCorrectlyOverwritten
			    		;;
			    	* )
					echo -e $exiting
					sleep 1
			    		;;
				esac 
	      		fi
	    		;;
		esac
}

#########################################################
# Function that allow saving customized profiles	#
# This create profile when choosed 4zone		#
#########################################################

function saveCustomizedProfile() {
	read -p "$setCustomizedProfileName" profName
	if [[ ! -d $PROFILESDIR/ ]]; then mkdir $PROFILESDIR
	else
		if [[ -f $PROFILESDIR/$profName ]]; then
			echo -e $customProfileExists
			echo $(cat $PROFILESDIR/$profName | sed "s/zone00/$leftZone/g" | sed "s/zone01/$middleZone/g" | sed "s/zone02/$rightZone/g" | sed "s/zone03/$wasdZone/g" )
			echo '-------------------'
			read -p "$overwriteProfile" overwrite
			case ${overwrite:0:1} in
			$y|${y^^}|y|Y)
				rm -rf "$PROFILESDIR/$profName"
				for fzone in $MODULEDIR/*; do
					IFS=',' read -a color <<< $(cat ${fzone})
					echo $(basename $fzone)'='$1 >> $PROFILESDIR/$profName
				done
				;;
			* )
				log 'so what are u doing??????'
				saveCustomizedProfile
				;;
			esac
		else
			for fzone in $MODULEDIR/*; do
				IFS=',' read -a color <<< $(cat ${fzone})
				echo $(basename $fzone)'='$1 >> $PROFILESDIR/$profName
			done
			[[ ! ARGS ]]; main
		fi
	fi
	
}

#########################################
# This function give the ability to	#
# the script that it can parse args	#
# and make something for all args	#
#########################################

function checkArgs() {
	checkModuleInstalled
	if [[ ! moduleInstalled ]]; then echo -e $moduleNotInstalled; exit 0; fi
	POSITIONAL=()
	unset zone
	unset colorRGB
	while [[ $# -gt 0 ]]; do
		key="$1"
		  	case $key in
	    		list) # list all profiles
		      		printProfiles
		      		shift
	      			;;
	    		-z|--zone) # zone check
	    			if [[ "$2" =~ ^[1-4]+$|all ]]; then zone=$2; else echo $invalidZMessage; fi
	      			shift # past argument
	      			shift # past value
	      			;;
	      		-c|--color) # color check
	      			if [[ -n $2 ]]; then colorRGB=$2; else echo -e $errorColorSet; fi
	      			shift
	      			shift
	      			;;
	    		install) # will install driver
	    			log 'install driver'
		      		driverInstaller
		      		shift
	      			;;
	      		default)
	      			applyProfile default
	      			shift
	      			;;
	      		-sc|--save-current)
	      			if [[ -n $2 && $2 =~ [A-Za-z] ]]; then saveCurrent $2; else echo -e $errorCurrentNameSet; fi
	      			shift
	      			shift
	      			;;
	      		-sn | --save-new)
	      			echo -e $saveNewProfile		
	      			if [[ -n $2 && -n $3 && -n $4 && -n $5 ]]; then
	      				# zone00 -> Left | zone01 -> Middle | zone02 -> Right | zone03 -> WASD
	      				if [[ -n $6 && -d $PROFILESDIR && ! -f $PROFILESDIR/$6 ]]; then
	      					echo 'zone00='$2 $'\nzone01='$3 $'\nzone02='$4 $'\nzone03='$5 > $PROFILESDIR/$6
	      				elif [[ -d $PROFILESDIR && -f $PROFILESDIR/$6 ]]; then
	      					read -p "$existingProfile" opt
						case ${opt:0:1} in
						    	$y|${y^^}|y|Y )
						    	rm -rf $PROFILESDIR/$6
							echo 'zone00='$2 $'\nzone01='$3 $'\nzone02='$4 $'\nzone03='$5 > $PROFILESDIR/$6
							echo -e $provileCorrectlyOverwritten
					    		;;
					    	* )
							echo -e $exiting
							sleep 1
					    		;;
						esac 
	      				fi
	      				shift 5
	      			elif [[ -n $2 && ! -n $4 ]]; then
	      				if [[ -n $3 && -d $PROFILESDIR && ! -f $PROFILESDIR/$3 ]]; then
	      					echo 'zone00='$2 $'\nzone01='$2 $'\nzone02='$2 $'\nzone03='$2 > $PROFILESDIR/$3
	      					echo -e $profileCorrectlySaved
	      				elif [[ -d $PROFILESDIR && -f $PROFILESDIR/$3 ]]; then
	      					read -p "$existingProfile" opt
						case ${opt:0:1} in
						    	$y|${y^^}|y|Y )
						    	rm -rf $PROFILESDIR/$6
							echo 'zone00='$2 $'\nzone01='$2 $'\nzone02='$2 $'\nzone03='$2 > $PROFILESDIR/$3
					    		echo -e $provileCorrectlyOverwritten
					    		;;
					    	* )
							echo -e $exiting
							sleep 1
					    		;;
						esac 
	      				fi
	      				
	      				shift 3
	      			elif [[ -n $2 && ! -n $3 ]]; then echo -e $errorCurrentNameSet; shift 2;
	      			elif [[ ! -n $2 ]]; then echo -e $errorColorSet; shift;
	      			fi
	      			shift
	      			;;
	      		apply)
	      			applyProfile $2
	      			shift 2
	      			;;
	      		--help)
	      			echo -e $helpMessage
	      			echo -e 'list\t\t\t\t' $listMessage
	      			echo -e '-z | --zone <n zone>\t\t' $zMessage
	      			echo -e '1' $zone1
				echo -e '2' $zone2
				echo -e '3' $zone3
				echo -e '4' $zone4
				echo -e '5 | all\t\t\t' $allZones
				echo -e '-c | --color <hex color>\t\t\t' $colorArgMessage
				echo -e 'install\t\t\t' $installArgMessage
				echo -e '-sc | --save-current <name>' $saveCurrentArgMessage
				echo -e '-sn | --save-new <hex1> <hex2> <hex3> <hex4> or <hex for all> <name>'
				echo -e '\t\t<hex1>' $zone1 '\n\t\t<hex2>' $zone2 '\n\t\t<hex3>' $zone3 '\n\t\t<hex4>' $zone4
				echo -e 'default\t\t' $defaultArgMessage 
				echo -e '--help\t\t\t' $helpArgMessage
	      			shift
	      			;;
	    		*)    # unknown option
	    			echo -e $commandNotFount $1
		      		POSITIONAL+=("$1") # save it in an array for later
	      			shift # past argument
	      			;;
		  	esac
	done
	set -- "${POSITIONAL[@]}" # restore positional parameters
	if [[ -n $zone && -n $colorRGB ]]; then colourChanger $colorRGB
	elif [[ -n $zone && ! -n $colorRGB ]]; then colourInputChooser
	elif [[ ! -n $zone && -n $colorRGB ]]; then echo -e $errorSetZone
	fi
		
	
}

#####################################
# Here we will check if this script #
# is called alone or with arguments #
#####################################

if [[  $# -eq 0 ]]; then ARGS=false; main; else ARGS=true; checkArgs $@; fi 
