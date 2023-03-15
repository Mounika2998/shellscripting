#!/bin/bash 

# When to use double quotes and when to use single quotes 

# "" : They don't effect the power of special variables 
# '' : They will effect the power of special variables 

a=10 
echo "Printing the value of a : $a" 

echo 'Printing the value of a : $a with single quores' 

echo $? 

echo '$?'