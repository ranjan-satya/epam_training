#!/bin/bash

#reading data from user
read -p 'Enter the file name: ' Filename

if [ -e $Filename ]
then
		echo File exist
else
		echo File does not exist
fi

if [ -s $Filename ]
then
		echo File is not empty
else
		echo File is empty
fi
