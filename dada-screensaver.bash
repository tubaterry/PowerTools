#!/bin/bash

# Chris Terry / GPL v3
# Gibberish message generator
# Using your provided URLs, this uses dadadodo to generate and abuse markov chains
# for fun and profit, but mostly fun.  
# It pipes the output into the Messages screensaver for the current user.
# 
# USAGE:
# Run as your personal user account! 

# SETUP:
# Download and compile https://www.jwz.org/dadadodo/
# You'll need xcode installed.
# Set the variables below, and off you go

# Only need to set the location of dadadodo and give a URL you want text from 
# (also can get URL as an argument)
DADADODO_LOCATION=~/Downloads/dadadodo-1.04
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
	#Grab the URL, hash it to give it a unique name
	curl --progress -o $DADADODO_LOCATION/temp.curl $URL
	$DADADODO_LOCATION/dadadodo -o $DADA_FILE -c 1 $DADADODO_LOCATION/temp.curl > /dev/null
	rm $DADADODO_LOCATION/temp.curl
else
	echo $URL already retrieved recently.
fi

#Automatically Generated
UUID=`ioreg -rd1 -c IOPlatformExpertDevice | grep -i "UUID" | cut -d "=" -f 2 | tr -d " \""`
PLIST_LOCATION=~/Library/Preferences/ByHost/com.apple.Screensaver.Basic.$UUID.plist

echo Generating message.
DADAMESSAGE=`$DADADODO_LOCATION/dadadodo -l $DADA_FILE -c 1 | tr -d '\n' | sed -e s/\ \ /\ /g`
/usr/libexec/PlistBuddy -c "Set :MESSAGE $DADAMESSAGE" $PLIST_LOCATION

echo Screensaver setting is now: $DADAMESSAGE
killall cfprefsd > /dev/null