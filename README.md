# HP-OMEN-Linux-RGBColour-ChangerScript

## Description
This is a fork of [JesusXD88's Project](https://github.com/JesusXD88/HP-OMEN-Linux-RGBColour-ChangerScript).
This script allow to change the color of the 4 Zones for HP Omen Laptop since for linux there isn't any Omen Command Center (or Omen Gaming Hub).
This script can be used 'as it' or with arguments.

## Acknowledgements
Thanks [pelrun](https://github.com/pelrun) for the [Kernel module](https://github.com/pelrun/hp-omen-linux-module) that allow us to achieve this! 

## Usage
Download this repo ( /lang files are really important, since there is all message contained in script!) or
```
git clone https://github.com/DHD2280/HP-OMEN-Linux-RGBColour-ChangerScript
```
cd into downloaded dir then you can call this script by simply (require sudo!)
```
# sh ./OmenRGBZone.sh
```
or 
```
$ sudo ./OmenRGBZone.sh
```
You will be guided by script.

## Usage with args
This script now 'supports' args.
For help just
```
./OmenRGBZone.sh --help
```
You can change color for all zones in the some moment or a color for every zone with:
```
./OmenRGBZone.sh -z all -c <hex_color>
```


## TODO's list
* Make the script go back to menu to select other zones/colours.
* Improve the code quality.
* Improve this README
