#!/bin/bash

# Double space for spacing: don't edit
doubleSpace="\n\n"

# Wellcome Message - The initial message of th script
wellcomeMessage="\nHP Omen RGB colour chooser by JesusXD88 & Luigi\n\n"
# Root Message - This will appear if there aren't root permissions
rootMessage="To use this script you need elevated privileges, as we're messing with system configs.\n"
moduleNotInstalled="Seems that you don't have Kernel Module Installed, you must install it first!"
# Main Message - Make a choice in a nutshell
mainMessage="\nPlease select an option:\n\n"

installModule="Install RGB control driver (Kernel Module)"
reinstallModule="Re-Install RGB control driver (Kernel Module)"
changeCurrentColours="Change current Keyboard colours"
saveCurrentColours="Save current Keyboard colours Profile"
createNewConfig="Create new Keryboard Colours Profile (For apply a config in a second time)"
applyExistingConfig="Apply an existing Keyboard Coulors Profile"
deleteProfiles="Delete profiles..."
exit="Exit"
exiting="Exiting..."
incorrectOptionMain="\n\nIncorrect option!\n\n"
defaultProfileCreated="\nDefault profile created!\n"

# All String into driverInstaller()
y='y'
n='n'
moduleInstalledYet="Module already installed, do you want to reinstall?($y/$n): "
firstInstallModule="Do you want to install kernel module?($y/$n): "
installingDriver="Installing Driver..."
gitNotInstalled="Error! Git isn't installed! First install it!"
noInternet="You don't have Internet Connection! Driver couldn't be installed!"
driverInstalled="The driver has been built and installed succesfully!\nYou will need to reboot so the module can be loaded"
driverError="An error has ocurred"

# Zone Selector
# zone00 -> Left | zone01 -> Middle | zone02 -> Right | zone03 -> WASD
selectZone="Please enter number of the RGB zone to change:"
zone1="Left zone\t\t(zone00)"
zone2="WASD\t\t\t(zone03)"
zone3="Mid zone\t\t(zone01)"
zone4="Right zone\t\t(zone02)"
allZones="Change all zone with the same colour"
allZonesSelected="You selected all zones same colour"
invalidInput="Please input a valid number:"
zone00Color="zone00 (Left) color:"
zone01Color="zone01 (Mid) color:"
zone02Color="zone02 (Right) color:"
zone03Color="zone03 (WASD) color:"

# Color Input Chooser
chooseWay="Choose the way the colour will be entered:"
presetsWay="Choose colour from built-in presets."
manualWay="Choose colour manually by hex code input."
comeBackProfile="Come back to profile creation"
returnToMain="Go back to main menu."

# Color Presets
red="Red"
green="Green"
brown="Brown"
blue="Blue"
purple="Purble"
cyan="Cyan"
lightGray="Light Gray"
darkGray="Dark Gray"
lightRed="Light Red"
lightGreen="Light Green"
yellow="Yellow"
lightBlue="Light Blue"
lightPurple="Light Purple"
lightCyan="Light Cyan"
white="White"

# Manually Color
inputCustomColorHex="\n\nPlease input the RGB zone colour you want to change (like this: 0000ff):\n\n"
# Save Current Config
inputNameConfig="Set a name for your current profile: "
existingProfile="Seems that this profile exists. Do you want to overwrite?($y/$n): "
profileSaved="Profile correcly saved"
leftZone="Left Zone" # zone 00
middleZone="Middle Zone" # zone 01
rightZone="Right Zone" # zone 02
wasdZone="WASD Zone" #zone 03

# Create Profile
createForAllZones="Do you want to create this profile for each zone?($y/$n)
If not, the color will apply for all keyboar zones"
setCustomizedProfileName="Set custom profile name: "
customProfileExists="Seems that this profile already exists."
overwriteProfile="Do you want to overwrite this profile?($y/$n)"
profileCorrectlySaved="\nProfile correctly saved!"
provileCorrectlyOverwritten="\nProfile correclty overwritten!'"
saveNewProfile="\nSave new Profile\n"

# Apply Profile 
selectProfileToApply="\nSelect a profile to apply:"
profileDirNotExists="Profile directory not exists! You must create a profile first!"
profileFileNotExists="Selected profile doesn't exists! You must create it first!"
noProfilesCreated="You haven't created any profile yet!"

# Profiles strings
profilesString="\nProfiles:\n"
noColorPreset="There aren't color profiles saved, you must save first a color preset!"

# Args String
helpMessage="OmenRGBZone.sh - This script will help you to set a color to your's omen laptop.\nThis script can run with args (like this) or executing it as ./OmenRGBZone.sh"
listMessage="list will list all stored profiles"
zMessage="-z or --zone can be used to set a zone for changing color:"
invalidZMessage="Insered an invalid number! Check help if you don't know!"
colorArgMessage="Set a color when using -c or --color argument!"
installArgMessage="This can be used for installing Kernel Module Driver, it allows to change colors"
saveCurrentArgMessage="Will save current profile in ./profiles/ with name selected (no spaces)"
helpArgMessage="Will show this message"
errorCurrentNameSet="Error! You must set a name for the profile! (without spaces)"
errorColorSet="Error! You must set hex color!"
errorSetZone="Error! You must set zone!"
commandNotFount="Command not found!\nUse --help!"
defaultArgMessage="Apply default profile, if exists"

changingRGBColor="\nChanging RGB color, please wait..."
succesfullyChangedColor="\n\nColor changed succesfully!\n"
