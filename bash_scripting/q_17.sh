a=`wc -w <$1`
if (( $a <200 ))
then
		echo "less"
else
		echo "greater"
fi
