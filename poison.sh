#!/bin/bash
# SOMEBODY POISONED THE WATER HOLE

# define vars
domcount=$(wc -l subdom | cut -d' ' -f1)
wordcount=$(wc -l dictfile | cut -d' ' -f1)
agentcount=$(wc -l usemeagent | cut -d' ' -f1)
permute=$((domcount*wordcount*agentcount))
iteration=1

while [ "$iteration" -le "$permute" ]; do
	# randomize tld
	tld=$(python randyline.py subdom)

	# randomize domain word
	dictword=$(python randyline.py dictfile)
	
	# randomize user agent
	imthisguy=$(python randyline.py usemeagent)

	# test for domain presence
	testhost="$dictword.$tld"
	@@ -24,15 +24,14 @@ while [ "$iteration" -le "$permute" ]; do
	hostout=$(host $testhost | grep "has address")

	# if DNS record returned, curl www, else ignore
	now=$(date +"%x %X")
	@@ -28,12 +28,7 @@ while [ "$iteration" -le "$permute" ]; d
	if [[ $hostout == *"has address"* ]]; then
		echo "domain $testhost found at $now." >> foundit.log
		curl -s -A "$imthisguy" www.$testhost >> /dev/null
		sleep 30
  	else
  		sleep 5
	fi

	iteration=$((iteration + 1))
done

#resist
