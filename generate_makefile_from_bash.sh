#!/bin/bash 

#global variable to store the directory path
PROJECT_PATH=""  
 COMPILE_FILE=""

while [[ $# -gt 0 ]] ; do
  case "$1" in 
   --path)
   PROJECT_PATH="$2"
   shift 2  ;;
  
   --compile_file)
   COMPILE_FILE="$2"
   shift 2 ;;
   
   *) 
   echo "Error" 
   shift 2 
   exit 1 ;;
  esac
done 
# to check wether a path was passed or not
if [ -z $PROJECT_PATH ] ; then  # the -z option means that the length of string is equal to zero
 echo "provide a path please"
 exit 1 
fi

if [ $COMPILE_FILE == "c" ] ; then 
 CC=gcc 
 
 elif [ $COMPILE_FILE == "c++" ] ; then 
  CC=g++ 
  else 
      echo "error in the source code to compile "
      fi 
      

