#!/bin/sh

project=`pwd` 
 
grep -rnI --exclude-dir=.git "\b$1\b" ${project} | while read line; 
do
 
	file=`echo $line|cut -d: -f1`
	linen=`echo $line|cut -d: -f2`
	text=`echo $line|cut -d: -f3`

	gitblamestr=`echo $file| xargs git blame -L$linen,+1 -e`
	email=`echo $gitblamestr|cut -d'<' -f2`
	email=`echo $email|cut -d'>' -f1`
 
	file=$( basename $file )

	ignore=`grep $file .gitignore`
 
	if [ "$file" != ".gitignore" ] && [ -z "${ignore// }" ]
	then 
		echo $email:$file:$linen:$text  
	fi

done 
