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
done < <(find $PROJECT_PATH -name "*.$COMPILE_FILE" -print0) 


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
   c_flag="-Wall  -g -Werror -Wextra -std=c11"
else 
   echo "There are $count sub folders containing the C files"  
   include_folder=() 
   while IFS= read -r -d $'\0'  ; do 
      include_folder+=("$REPLY")
done < <(find $PROJECT_PATH -name "*.h" -print0) 
   #to obtain the name of the directory inwhich there are .h files
    i_path=$(basename $(dirname $(realpath "${include_folder[@]}")))
    echo $i_path
    c_flag="-Wall -g -Werror -Wextra -std=c11 -I$i_path"
fi 

### recherchons s'il existe un Makefile déjà présent et si oui on demande à l'utilisateur s'il desire généré un nouveau makefile ou le conserver
#search for makefile in the folder
Makefile="$PROJECT_PATH/Makefile"
makefile_file=() 
   while IFS= read -r -d $'\0'  ; do 
      makefile_file+=("$REPLY")
done < <(find $PROJECT_PATH -name "Makefile" -print0) 
#test if a makefile exists
if [ ${#makefile_file[@]} -eq 0 ]  ; then 
echo " No Makefile exists we are going to generate on.............."
touch $Makefile 
else 
  echo -n "Would you like to generate a new  Makefile ? : " # -n prevents echo to print a new line  
  read  ans   #to read input from terminale
  case $ans in 
  [Yy] | [Yy][eE][sS] ) # to test either y or Y or yes or YES or Yes or yEs or yeS or YeS or yES or YEs
  echo "generating a new file............................"
  rm $Makefile
  touch $Makefile ;;
  [Nn] | [Nn][Oo] ) # to test either n or N or No or nO or NO or no 
  echo "No generation done !"
  exit 1 ;;
  *) 
  echo "Please either put y/n or yes/no " 
   exit 1 ;;
   esac 
fi

############################################################################################################
# Generation of Makefile 
############################################################################################################
# compiler 
echo "CC=$CC" >> $Makefile
# cflags
echo "CFLAG=$c_flag" >> $Makefile 
#build path
build="$PROJECT_PATH/build"
#checks if the repo exists using the -d flag 
 if [[  -d $build ]] ; then 
   echo "the repository $build exists no need of creating one "
   listing=$(ls $build ) # to get the output of list
   if [ -z $listing ] ; then  #checking if the list if empty i.e comparing length of string to null
   echo "repo is empty no no need of cleaning"
   else
   echo " following files $listing of $build will be deleted"
   echo "cleaning of it content............"
   rm $build/* 
   echo "cleaning done, $build is empty"
   fi
 else 
   mkdir $build
fi     
 
echo "BUILD_DIR=build" >> $Makefile
#object sources 
OBJ_SRC="${array[@]}"
echo "OBJS_SRC=$OBJ_SRC" >> $Makefile
echo "OBJS=\$(patsubst %.c, %.o , \$(OBJS_SRC))" >> $Makefile #put \ before $ enables us to suppress it and echo it in the file 
##check wether a target is passed or not
echo "ifeq (\$(MAKECMDGOALS),)" >> $Makefile
echo "\$(error \"error please pass a target, either clean or and run\")" >> $Makefile

echo "endif" >> $Makefile
echo ".PHONY: clean run" >> $Makefile 

echo "clean :" >> $Makefile 
echo -e "\trm build/*" >> $Makefile
echo "run :bin " >> $Makefile 
echo -e "\t./$^ " >> $Makefile 
echo -e "\t@mv \$^ \$(BUILD_DIR)" >> $Makefile
echo "bin : \$(OBJS)" >> $Makefile
echo -e "\t\$(CC) \$(CFLAG) $^ -o \$@" >> $Makefile
echo -e "\t@mv \$^ \$(BUILD_DIR)" >> $Makefile 
echo "%.o : %.c" >> $Makefile
echo -e "\t\$(CC) -c \$(CFLAG)  $^ -o \$@" >> $Makefile 
 

