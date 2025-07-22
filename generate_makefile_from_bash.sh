#!/bin/bash 

#global variable to store the directory path
PROJECT_PATH=""  
COMPILE_FILE=""

while [[ $# -gt 0 ]] ; do 
  case "$1" in 
   --path)        
   PROJECT_PATH="$2"
   shift 2  ;;  # the shift reduces the value $# by 2 so as the loop continues it decreases by 2 ($#-2)
                # ;; or ‘;&’, or ‘;;&’ is to break the case option after it is being executed 
   --compile_file)
   COMPILE_FILE="$2"
   shift 2 ;;
   --help|-h)
   echo "The aim of this script is to generate a makefile for compilation of c/c++ code "
   echo "In the --path option please provide an absolute path for the directory to be used"
   echo " In the --compile_file flag you should either provide c or cpp "
   shift 2
   exit 1  ;;
   
   *) 
   echo "Error"
   echo "please do $0 --help for more info" #$0 is to get the name of the script being executed 
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
 
 elif [ $COMPILE_FILE == "cpp" ] ; then 
  CC=g++ 
  else 
      echo "error in the source code to compile "
      fi 

#we need to create an Array of string to store all the c files  path    
array=()
while IFS= read -r -d $'\0'  ; do 
      array+=("$REPLY")
done < <(find $PROJECT_PATH -name "*$COMPILE_FILE" -print0) 


# Checking  if there exist c files
if [ ${#array[@]} -eq 0 ]; then
    echo "No $COMPILE_FILE files found, please provide a folder that contains $COMPILE_FILE"
    exit 1
fi
########################################################################################
#faced a lot of problem here due to synthax with dirname and realpath
# NB: use " " when dealing with string variables 
#we need to loop through each file path to do a comparaison if there are from thesame directory or not
#let's create two variables 
#one variable to store a count and one to store the reference
count=0     #initialise the variable to 0 
reference=$(dirname "$(realpath "${array[0]}")")
 # calculate the reference using the first element of the array i.e the absolute path of the directory of the first c file 
# dirname and realpath enables us to obtain the directory in which the code is found  
for file in "${array[@]}" ;
do 
   actual=$(dirname "$(realpath "$file")")

   if [ "$reference" != "$actual" ] ; then 
    count=$(expr $count + 1) # we can also write count=$((count+1))
    fi    
done 
# verify wether there are from thesame source or are from different sources 
if [ $count -eq 0 ] ; then 
   echo $count "All the files are from thesame repository"
else 
   echo "There are $count sub folders containing the C files"   
fi 

