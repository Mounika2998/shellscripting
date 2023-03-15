#!/bin/bash 

### Exit vs return 
### Exit will pull out from the script
### return, this will just take out of the function.
#

sample() {
    echo "I am a messaged called from sample function"
}

# This is how we call a function.
 stat() {
    echo -e "\t Total number of sessons : $(who | wc -l)"
    echo "Todays date is $(date +%F)"
    echo "Load Average On The system is $(uptime | awk -F : '{print $NF}' | awk -F , '{print $1}')"
    echo -e "\t stat function completed"

    echo "Calling sample function"

    # exit 2 
    return 

    sample 
 }

 stat  

 echo -e "\t\t  Stat and Sample functions are completed"