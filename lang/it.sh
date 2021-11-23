#!/bin/bash

# Double space for spacing: don't edit
doubleSpace="\n\n"

# Wellcome Message - The initial message of th script
wellcomeMessage="\nHP Omen RGB colour chooser by Luigi, based on @JesusXD88\n\n"
# Root Message - This will appear if there aren't root permissions
rootMessage="Per usare questo script sono necessari i diritti di root.\n"
moduleNotInstalled="Sembra che non sia installato il Modulo Kernel, per cambiare i colori della tastiera devi installarlo!"
# Main Message - Make a choice in a nutshell
mainMessage="\nSeleziona un'opzione:\n\n"

installModule="Installa il Modulo Kernel per il controllo RGB"
reinstallModule="Re-installa il Modulo Kernel per il controllo RGB"
changeCurrentColours="Cambia i colori attuali della tastiera"
saveCurrentColours="Salva il profilo attuale dei colori"
createNewConfig="Crea un nuovo Profilo Colore (cosi' da applicarlo in qualsiasi momento dopo)"
applyExistingConfig="Applica un Profilo Colore (solo se l'hai creato in precedenza)"
deleteProfiles="Cancella profili..."
exit="Esci"
exiting="Uscita..."
incorrectOptionMain="\n\nScelta non valida!\n\n"
defaultProfileCreated="\nProfilo predefinito creato!\n"

# All String into driverInstaller()
y='s'
n='n'
moduleInstalledYet="Modulo già installato, vuoi reinstallarlo?($y/$n): "
firstInstallModule="Vuoi installare il Modulo Kernel?($y/$n): "
installingDriver="Installazione Modulo Kernel..."
gitNotInstalled="Errore! Git non è installato, installalo prima!"
noInternet="Non hai una connessione internet! Il modulo non può essere installato!"
driverInstalled="Il Modulo Kernel è stato compilato e installato con successo!\nAffinchè tutto possa funzionare, è necessario un riavvio"
driverError="Errore"

# Zone Selector
# zone00 -> Left | zone01 -> Middle | zone02 -> Right | zone03 -> WASD
selectZone="Inserisci il numero per la zona corrispondente:"
zone1="Zona sinistra\t(zone00)"
zone2="WASD\t\t\t(zone03)"
zone3="Zona media\t\t(zone01)"
zone4="Zona destra\t\t(zone02)"
allZones="Tutte contemporaneamente"
allZonesSelected="Hai selezionato lo stesso colore per tutte le zone"
invalidInput="Inserisci un numero valido:"
zone00Color="zone00 (Sinistra) colore:"
zone01Color="zone01 (Media) colore:"
zone02Color="zone02 (Destra) colore:"
zone03Color="zone03 (WASD) colore:"

# Color Input Chooser
chooseWay="Seleziona il modo preferito per inserire il colore:"
presetsWay="Scegli il colore da presets."
manualWay="Seleziona il colore manualmente inserendo l'hex."
comeBackProfile="Torna alla creazione del profilo"
returnToMain="Torna all'inizio."

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
inputCustomColorHex="\n\nInserisci il colore in hex senza # (ad esempio: 0000ff):\n\n"
# Save Current Config
inputNameConfig="Imposta un nome per il profilo corrente: "
existingProfile="Sembra che questo profilo esista. Vuoi sovrascriverlo?($y/$n): "
profileSaved="Profilo salvato correttamente"
leftZone="Zona Sinistra" # zone 00
middleZone="Zona Media" # zone 01
rightZone="Zona Destra" # zone 02
wasdZone="WASD" #zone 03

# Create Profile
createForAllZones="Vuoi creare il profilo per-zona?($y/$n)
Se no, il colore sarà applicato a tutte le zone"
setCustomizedProfileName="Nome Profilo: "
customProfileExists="Sembra che questo profilo già esista."
overwriteProfile="Vuoi sovrascriverlo?($y/$n)"
profileCorrectlySaved="\nProfilo salvato correttamente!"
provileCorrectlyOverwritten="\nProfilo sovrascritto correttamente!"
saveNewProfile="\nSalva nuovo Profilo\n"

# Apply Profile 
selectProfileToApply="\nSeleziona un profilo da applicare:"
profileDirNotExists="La Directory dei profili non esiste! Devi creare prima un profilo per questo!"
profileFileNotExists="Il profilo selezionato non esiste! Creane uno prima!"
noProfilesCreated="Non hai creato ancora nessun profilo!"

# Profiles strings
profilesString="\nProfili:\n"
noColorPreset="There aren't color profiles saved, you must save first a color preset!"

# Args String
helpMessage="OmenRGBZone.sh - This script will help you to set a color to your's omen laptop.\nThis script can run with args (like this) or executing it as ./OmenRGBZone.sh"
listMessage="list mostrerà tutti i profili salvati"
zMessage="-z o --zone serve ad impostare una zona per il cambio colore:"
invalidZMessage="Inserito numero non valido! Controlla l'aiuto!"
colorArgMessage="Imposta un colore usando -c or --color seguito dall'hex!"
installArgMessage="Può essere usato per installare il Modulo Kernel (se non presente), quello che permette di cambiare i colori"
saveCurrentArgMessage="Salva il profilo corrente in ./profiles/ con nome selezionato (senza spazi)"
helpArgMessage="Mostra questo messagio"
errorCurrentNameSet="Errore! Devi inserire un nome per il profilo! (senza spazi)"
errorColorSet="Errore! Devi impostare un colore hex!"
errorSetZone="Errore! Devi impostare la zona!"
commandNotFount="Comando non trovato!\nUsa --help!"
defaultArgMessage="Applica profilo predefinito, se esiste"

changingRGBColor="\nCambio il colore, attendere..."
succesfullyChangedColor="\n\nColore cambiato correttamente!\n"
