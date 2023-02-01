read -p 'Enter a: ' a
read -p 'Enter b: ' b


if (( $a!=$b ))
then 
	if (( $a<$b ))
	then
		echo a is smaller than b.
	elif (( $a>$b ))
	then
		echo a is greater than b.
	fi
fi

if (( $a==$b ))
then
	echo a is equal to b.
fi
