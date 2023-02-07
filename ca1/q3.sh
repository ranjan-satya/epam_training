#!/bin/bash

mkdir folder1
cd folder1
touch f_{1..3}

for file in `ls`
do
		chmod g-r $file
		chmod g-w $file
		chmod g-x $file
		chmod o-r $file
		chmod o-w $file
		chmod o-x $file
done


