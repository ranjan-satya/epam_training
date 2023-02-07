#!/bin/bash

func(){
		if [ -d $1 ]
		then
        	echo "The given argument is the directory."
			file_count `ls $1`
			ls -l $1
		elif [ -f $1 ]
		then
       		 echo "The given argument is the file."
		else
    	     echo "The given argument is some another type of file"
		fi
}

file_count(){
		files=$#
		echo "The number of files in the directory is $files"
}

func test_dir 
