#!/bin/bash

sum(){
		num_list=$@
		s=0
		arg_count=$#
		for i in $num_list
		do
				s=$(( $s+$i ))
		done
		avg=$(( $s/$arg_count ))
		return $avg
}
sum $@
echo "Average : $?"
