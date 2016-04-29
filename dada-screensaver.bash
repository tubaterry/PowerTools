#!/bin/bash

# Chris Terry / GPL v3
# Gibberish message generator
# Using your provided URLs, this uses dadadodo to generate and abuse markov chains
# for fun and profit, but mostly fun.  
# It pipes the output into the Messages screensaver for the current user.
# 
# USAGE:
# Run as your personal user account! 
# Edit the DADADODO_LOCATION and give it a URL to retreive text from, then run:
# ./dada-screensaver.bash

# SETUP:
# Download and compile https://www.jwz.org/dadadodo/
# You'll need xcode installed.  (Detailed instructions at the bottom)
# Set the two variables below, and off you go

# Only need to set the location of dadadodo and give a URL you want text from 
# (also can get URL as an argument)
# URL can also be a local text or HTML file
# Change MESSAGE_LENGTH if you would like the message to be at least a certain length
# (It will give up after 10 tries though)
DADADODO_LOCATION=~/Downloads/dadadodo-1.04
MESSAGE_LENGTH=400
URL="http://www.gutenberg.org/cache/epub/4280/pg4280.txt"

#Use the URL passed in
if [ $1 ]; then
	URL=$1
fi

if [ ! -f $DADADODO_LOCATION/dadadodo ]; then
	echo dadadodo executable not found!
	echo Download and compile from https://www.jwz.org/dadadodo/
	echo You will need XCode installed.
	exit 1
fi

HASH=`echo $URL | shasum | cut -d " " -f 1`
DADA_FILE=$DADADODO_LOCATION/$HASH.dada

if [ -f "$DADA_FILE" ]; then
	if [ `find $DADA_FILE -mtime 1 | wc -l` -gt 0 ]; then
		echo Getting new copy of $URL
		rm $DADA_FILE
	fi
fi

if [ ! -f "$DADA_FILE" ]; then
	echo Generating $HASH.dada ...
	if [ -f $URL ]; then
		echo using local file at $URL
		cp $URL $DADADODO_LOCATION/temp.curl
	else
		#Grab the URL, hash it to give it a unique name
		curl --progress -o $DADADODO_LOCATION/temp.curl $URL
	fi
	$DADADODO_LOCATION/dadadodo -o $DADA_FILE -c 1 $DADADODO_LOCATION/temp.curl > /dev/null
	rm $DADADODO_LOCATION/temp.curl
else
	echo $URL already retrieved recently.
fi

#Automatically Generated
UUID=`ioreg -rd1 -c IOPlatformExpertDevice | grep -i "UUID" | cut -d "=" -f 2 | tr -d " \""`
PLIST_LOCATION=~/Library/Preferences/ByHost/com.apple.Screensaver.Basic.$UUID.plist

echo Generating message.
ATTEMPT_COUNT=0
DADA_LENGTH=0
while [ $DADA_LENGTH -lt $MESSAGE_LENGTH ]; do
	DADAMESSAGE=`$DADADODO_LOCATION/dadadodo -l $DADA_FILE -c 1 | tr -d '\n' | tr -Cd [A-Za-z.\;\-\ ]| sed -e s/\ \ /\ /g`
	let DADA_LENGTH=`echo $DADAMESSAGE | wc -m | sed -e s/\ //g`
	if [ $ATTEMPT_COUNT -lt 10 ]; then
		let ATTEMPT_COUNT=$ATTEMPT_COUNT+1
	else
		let DADA_LENGTH=$MESSAGE_LENGTH
	fi
done

/usr/libexec/PlistBuddy -c "Set :MESSAGE $DADAMESSAGE" $PLIST_LOCATION

echo Screensaver setting is now: $DADAMESSAGE
killall cfprefsd > /dev/null

#Detailed install instructions:
# 1. Get XCode from the app store
# 2. Download the dadadodo.tar.gz file from the site above.
# 3. Open Term
# 4. cd to the location you downloaded dadadodo
# 5. dadadodo setup:
#   5a. tar xzf dadadodo-1.04.tar.gz
#   5b. cd dadadodo-1.04
#   5c. make
# 6. Script setup
#   6a. Open dada-screensaver.bash in an editor
#   6b. Specify the location you extracted everything (probably ~/Downloads/dadadodo-1.04)
#   6c. Give it a URL (the default is The Critique of Pure Reason from PRoject Gutenberg)
#   6d. run: chmod +x ~/Downloads/dada-screensaver.bash
#   6e. run the script: ~/Downloads/dada-screensaver.bash
