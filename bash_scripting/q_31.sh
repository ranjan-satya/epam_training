#!/bin/bash

function1(){
		sum=0
		num_list=$@
		for i in $num_list
		do
				sum=$(( $sum + $i ))
		done

		function2 $sum $#
		avg=$?
		echo " Sum : $sum  Average : $avg"
}

function2(){
		sum=$1
		count=$2
		avg=$(( $sum/$count ))
		return $avg
}

function1 1 3
