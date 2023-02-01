#!/bin/bash

a=0

while [ $a<10 ]
do
	echo $(( a+1 ))
	a = $(( a+1 ))
done

