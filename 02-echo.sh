#!/bin/bash
echo line1
echo line2
echo line3

# How to print multiple lines using a single echo command ? 
    # To do so, we need to use escape sequenece characters
#  \n : It tells the system to move the cursor to the next like 
#  \t : It moves the cussor to a tab space and the prints the next like


echo lineX\nlineY

# To use escape sequence characters, you need to enable the escape sequence using an option called `-e`

echo -e "lineX\nlineY"

# " : Double Quote 
# ' : Single Quote

echo -e "lineA\n\tlineB"