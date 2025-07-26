#!/bin/bash 

#Author : KAMDA TEZEBO DIBREY JONATAN
#Description : Generation of Makefile for compilation
#version : 1.0 
 
#global variable to store the directory path
PROJECT_PATH=""  
COMPILE_FILE=""
COVERAGE_OPTION=""
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
   echo " In the --coverage flag you should provide yes or YES or Y or y, if you wish to use coverage "
   shift 2
   exit 1  ;;
   --coverage )
   COVERAGE_OPTION="$2"
   shift 2 ;;
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
  echo "generating a new Makefile............................"
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

if [ -z $COVERAGE_OPTION ] ; then 
    echo -n ""   # it means nothing was passed but this echo is present here since we need at least one instruction for if conditional
else
if [ $COVERAGE_OPTION == yes  -o $COVERAGE_OPTION == y -o $COVERAGE_OPTION == Y -o $COVERAGE_OPTION == YES ] ; then 
    value=yes 
    condition_flag="-fprofile-arcs -ftest-coverage"

else 
 condition_flag=""
  echo "wrong coverage option, run $0 --help for more info  "
 fi  
 fi
############################################################################################################
# Generation of Makefile 
############################################################################################################
# compiler 
echo "#This Makefile was automatically generated using $0" >> $Makefile
echo "#For any problem report bug by opening an issue in the github project">> $Makefile
echo "CC=$CC" >> $Makefile
# cflags
echo "CFLAG=$c_flag $condition_flag" >> $Makefile 
#build path
build="$PROJECT_PATH/build"
#checks if the repo exists using the -d flag 
 if [[  -d $build ]] ; then 
   echo "the repository $build exists no need of creating one "
   listing=$(ls $build ) # to get the output of list
   if [  ${#listing} -eq 0 ] ; then  #did corrections as string was too large,so i did comparaison of length to 0 by auto calculating the length
                                     # but in the previous commits, the string length was compared to 0 which cause bugs as build list increases in size.
   echo "repo is empty no no need of cleaning"
   else
   echo " The following files of $build will be deleted : $listing "
   echo "cleaning of it content............"
   rm $build/* 
   echo "cleaning done, $build is empty"
   fi
 else 
   mkdir $build
fi     
   
echo "COVERAGE=$value" >> $Makefile 
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
echo -e "\trm build/* ||:" >> $Makefile
echo -e "\trm -r coverage_report ||:" >> $Makefile
echo "run :bin " >> $Makefile 
echo -e "\t./$^ " >> $Makefile 
echo "ifeq (\$(COVERAGE),yes)" >> $Makefile
echo -e "\tlcov --directory . --capture --output-file coverage.info" >>$Makefile
echo -e "\tgenhtml coverage.info --output-directory coverage_report" >>$Makefile
echo -e "\t@mv *.info \$(BUILD_DIR)" >>$Makefile
echo -e "\t@mv *.gcda \$(BUILD_DIR)" >>$Makefile
echo -e "\t@mv *.gcno \$(BUILD_DIR)" >>$Makefile
echo "endif" >> $Makefile
echo -e "\t@mv \$^ \$(BUILD_DIR)" >> $Makefile
echo "bin : \$(OBJS)" >> $Makefile
echo -e "\t\$(CC) \$(CFLAG) $^ -o \$@" >> $Makefile
echo -e "\t@mv \$^ \$(BUILD_DIR)" >> $Makefile 
echo "%.o : %.c" >> $Makefile
echo -e "\t\$(CC) -c \$(CFLAG)  $^ -o \$@" >> $Makefile 
echo "generation done.................................."
echo -n "To run the makefile use this command "
echo  "make -C $PROJECT_PATH clean run"
