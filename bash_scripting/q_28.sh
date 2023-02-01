#!/bin/bash

function1(){
		first_arg=$1
		echo "First argument is : $first_arg"

		arg_count=$#
		echo "Number of argument passed is : $arg_count"

		all_arg=$@
		echo "All arguments : $all_arg"

		return 4
}
function1 satya ranjan
ret=$?
echo "Value returned by funtion1() : $ret"
