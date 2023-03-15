#!/bin/bash 

# Syntan for CASE 
# case  $var in 
#     opt1) command1 ;; 
     
#     opt2) command2 ;;

# esac

ACTION=$1

case $ACTION in 
    start) 
        echo -e "\e[32m Starting Payment Service \e[0m" 
        exit 0 
        ;; 
    stop)
        echo -e "\e[31m Stopping Payment Service \e[0m"
        exit 2
        ;;
    restart)
        echo "Restarting Payment Service"      
        exit 3  
        ;;
    *) 
        echo -e "Valid Options are \e[32m start  or stop  or restart \e[0m "
        exit 4
        ;;
esac 