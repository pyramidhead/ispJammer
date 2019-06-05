#!/bin/bash
# SOMEBODY POISONED THE WATER HOLE

# define vars
domcount=$(wc -l subdom | cut -d' ' -f1)
wordcount=$(wc -l dictfile | cut -d' ' -f1)
permute=$((domcount*wordcount))
iteration=1

while [ "$iteration" -le "$permute" ]; do
	# randomize tld
	tld=$(python randyline.py subdom)

	# randomize domain word
	dictword=$(python randyline.py dictfile)
	
	# randomize user agent - still TBD
	#imthisguy=$(python randyline.py usemeagent)

	# test for domain presence
	testhost="$dictword.$tld"
	read hostout <<< $(host $testhost)

	# if DNS record returned, curl www, else ignore
	now=$(date +"%r")
	if [[ $hostout == *"has address"* ]]; then
  		mycurl=("-s -A '"'Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.0) Opera 12.14'"' www.$testhost")
  		echo "domain "$testhost" found at "$now"." >> foundit.log
  		curl -s $mycurl >> /dev/null
  		sleep 30
	elif [[ $hostout == *"is an alias for"* ]]; then
   		mycurl=("-s -A '"'Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.0) Opera 12.14'"' www.$testhost")
  		echo "domain "$testhost" found at "$now"." >> foundit.log
  		curl -s $mycurl >> /dev/null
  		sleep 30
  	elif [[ $hostout == *"not found"* ]]; then
  		sleep 5
	fi

iteration=$((iteration + 1))
done

#resist
