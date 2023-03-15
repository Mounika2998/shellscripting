#!/bin/bash 

# What is a Variable ??? A variable is something which holds some value dynamically.

a=10
b=20
c=30

# No data types are available in Bash by defailt 
# Everything is considered as a STRING.

# How do you print a variable ?
# We use a special character, called $ to print 
# echo $a 

echo $a 
echo ${a} 
echo "$c"

echo "I am pritning the value of d $d" 

# When you try to print a variable which is not declared, bash is going to consider that as Null or empty

# rm -rf /data/${DATA_DIR}   # /data/test  ---> rm -rf /data/

# How do you supply variables from the command line 
# export varName =  value 