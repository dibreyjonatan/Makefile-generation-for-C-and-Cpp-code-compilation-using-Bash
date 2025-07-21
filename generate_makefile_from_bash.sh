#!/bin/bash 

PROJECT_PATH=""  #global variable to store the directory path


while [[ $# -gt 0 ]] ; do
  case "$1" in 
   --path)
   PROJECT_PATH="$2"
   shift 2  ;;
  
   *) 
   echo "Error" ;;
  esac
done 
# to check wether a path was passed or not
if [ -z $PROJECT_PATH ] ; then 
 echo "provide a path please"
 exit 1 
fi

