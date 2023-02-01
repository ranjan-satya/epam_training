#!/bin/bash

odd(){
		num=$1
		if [ $(( $num%2 )) == 1 ]
		then
				echo "Odd number"
		else
				echo "Invalid Input"
		fi
}
odd 5
