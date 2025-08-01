#!/bin/bash 

#Author : KAMDA TEZEBO DIBREY JONATAN
#Description : Generation of Makefile for compilation
#version : 1.0 
#Adding color variables and output to beautify the user interactions
source ./terminale_response.sh
start 
 BOLD=$(tput bold)
 RESET=$(tput sgr0)
 BLACK=$(tput setaf 0)
 BG_GREEN=$(tput setab 2) 
 YELLOW=$(tput setaf 3)
 BG_YELLOW=$(tput setab 3)
 RED=$(tput setaf 1)
 BG_RED=$(tput setab 1)
 BLUE=$(tput setaf 4)
 BG_BLUE=$(tput setab 4)
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
   echo "${BOLD}${BG_BLUE}${BLACK}INFO :${RESET} The aim of this script is to generate a makefile for compilation of c/c++ code "
   echo "${BOLD}${BG_BLUE}${BLACK}INFO :${RESET} In the --path option please provide an absolute path for the directory to be used"
   echo "${BOLD}${BG_BLUE}${BLACK}INFO :${RESET} In the --compile_file flag you should either provide c or cpp "
   echo "${BOLD}${BG_BLUE}${BLACK}INFO :${RESET} In the --coverage flag you should provide yes or YES or Y or y, if you wish to use coverage "
   shift 2
   exit 1  ;;
   --coverage )
   COVERAGE_OPTION="$2"
   shift 2 ;;
   *) 
   echo "${BOLD}${BG_RED}${BLACK} ERROR :${RESET} please do $0 --help for more info" #$0 is to get the name of the script being executed 
   shift 2 
   exit 1 ;;
  esac
done 
# to check wether a path was passed or not
if [ -z $PROJECT_PATH ] ; then  # the -z option means that the length of string is equal to zero
 echo "${BOLD}${BG_RED}${BLACK} ERROR :${RESET} provide a path please"
 exit 1 
fi

if [ "$COMPILE_FILE" == "c" ] ; then 
 CC=gcc 
 
 elif [ "$COMPILE_FILE" == "cpp" ] ; then 
  CC=g++ 
  else 
      echo "${BOLD}${BG_RED}${BLACK} ERROR :${RESET} the source code to compile must be c or cpp"
      fi 

#we need to create an Array of string to store all the c files  path    
array=()
while IFS= read -r -d $'\0'  ; do 
      array+=("$REPLY")
done < <(find $PROJECT_PATH -name "*.$COMPILE_FILE" -print0) 


# Checking  if there exist c files
if [ ${#array[@]} -eq 0 ]; then
    echo "${BOLD}${BG_YELLOW}${BLACK} WARNING :${RESET} No $COMPILE_FILE files found, please provide a folder that contains $COMPILE_FILE"
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
   echo "${BOLD}${BG_BLUE}${BLACK}INFO : ${RESET} All the $count files are from thesame repository"
   #Precsing compilation flags with respect to code 
   if [ "$COMPILE_FILE" == "c" ] ; then 
  c_flag="-Wall  -Werror -Wextra -std=c11"
 elif [ "$COMPILE_FILE" == "cpp" ] ; then 
  c_flag="-Wall -Wextra -Werror -pedantic -std=c++20 "
      fi 
else 
   echo "${BOLD}${BG_BLUE}${BLACK}INFO :${RESET} There are $count sub folders containing the $COMPILE_FILE files"  
   include_folder=() 
   while IFS= read -r -d $'\0'  ; do 
      include_folder+=("$REPLY")
done < <(find $PROJECT_PATH -name "*.h" -print0) 
   #to obtain the name of the directory inwhich there are .h files
if [[ "$COMPILE_FILE" == "c" ]] ; then    
   unity=""
   i_path=""
   for i in "${include_folder[@]}";
do 
   if [[ "$i" =~ "Unity" ]] && [[ -z  "$unity"  ]]; then
  echo "${BOLD}${BG_BLUE}${BLACK}INFO :${RESET} Unity sub folder found"
  unity="Unity/src"
  else 
   i_path=$(basename $(dirname $(realpath "$i")))
fi
done
# The goal here is to do a second search where Unity is totally excluded
include_folder=() 
   while IFS= read -r -d $'\0'  ; do 
      include_folder+=("$REPLY")
done < <(find $PROJECT_PATH -type d -name 'Unity' -prune -false -o -name "*.h" -print0) 
fi

if [[ "$COMPILE_FILE" == "cpp" ]] ; then 
 googletest=""
   for i in "${include_folder[@]}";
do 
   if [[ "$i" =~ "googletest" ]] && [[ -z  "$googletest"  ]]; then
  echo "${BOLD}${BG_BLUE}${BLACK}INFO :${RESET} googletest folder found"
  googletest="true"
  else 
   i_path=$(basename $(dirname $(realpath "$i")))
fi
done 
# The goal here is to do a second search where Unity is totally excluded
include_folder=() 
   while IFS= read -r -d $'\0'  ; do 
      include_folder+=("$REPLY")
done < <(find $PROJECT_PATH -type d -name 'googletest' -prune -false -o -name "*.h" -print0) 

fi
   #creation of c_flag
     if [ "$COMPILE_FILE" == "c" ] ; then 
     if [[ -n "$unity" ]] ; then
      if [[ "${#include_folder[@]}" -eq "1" ]] ; then 
      i_path=$(basename $(dirname $(realpath "${include_folder[0]}")))
       c_flag="-Wall  -Werror -Wextra -std=c11 -I$i_path -I$unity"
      else 
        i_path=""
        for i in "${include_folder[@]}";
           do 
         i_path+="-I$(basename $(dirname $(realpath "$i")))"  
         i_path+=" "
         done 
	 c_flag="-Wall  -Werror -Wextra -std=c11 $i_path -I$unity"
       fi
     else
  c_flag="-Wall  -Werror -Wextra -std=c11 -I$i_path"
  fi
 elif [ "$COMPILE_FILE" == "cpp" ] ; then 
  c_flag="-Wall -Wextra -Werror -pedantic -std=c++20 -I$i_path"
  googletest="-I googletest/googletest/include "
  if [[ -n "$googletest" ]] ; then
      if [[ "${#include_folder[@]}" -eq "1" ]] ; then 
      i_path=$(basename $(dirname $(realpath "${include_folder[0]}")))
       c_flag=" -Wall -Wextra -Werror -pedantic -std=c++20 -I$i_path $googletest"
      else 
        i_path=""
        for i in "${include_folder[@]}";
           do 
         i_path+="-I$(basename $(dirname $(realpath "$i")))"  
         i_path+=" "
         done 
	 c_flag="-Wall -Wextra -Werror -pedantic -std=c++20  $i_path $googletest"
       fi
     else
  c_flag="-Wall -Wextra -Werror -pedantic -std=c++20  -I$i_path"
  fi
  
     fi 
fi 

### recherchons s'il existe un Makefile déjà présent et si oui on demande à l'utilisateur s'il desire généré un nouveau makefile ou le conserver
#search for makefile in the folder
Makefile="$PROJECT_PATH/Makefile"
makefile_file=() 
   while IFS= read -r -d $'\0'  ; do 
      makefile_file+=("$REPLY")
done < <(find $PROJECT_PATH -type d \( -name 'Unity' -o -name 'googletest' \) -prune -false -o -name  "Makefile" -print0) #because Unity contains Makefiles, the goal is to make a search everywhere except there
#test if a makefile exists
if [ ${#makefile_file[@]} -eq 0 ]  ; then 
echo " ${BOLD}${BG_BLUE}${BLACK}INFO : ${RESET} No Makefile exists we are going to generate one ........................"
touch $Makefile 
else 
  echo -n "${BOLD}${BG_YELLOW}${BLACK} WARNING : ${RESET} Would you like to generate a new  Makefile ? : " # -n prevents echo to print a new line  
  read  ans   #to read input from terminale
  case $ans in 
  [Yy] | [Yy][eE][sS] ) # to test either y or Y or yes or YES or Yes or yEs or yeS or YeS or yES or YEs
  echo "${BOLD}${BG_BLUE}${BLACK}INFO : ${RESET} generating a new Makefile............................"
  rm $Makefile
  touch $Makefile ;;
  [Nn] | [Nn][Oo] ) # to test either n or N or No or nO or NO or no 
  echo "${BOLD}${BG_BLUE}${BLACK}INFO : ${RESET} No generation done !"
  exit 1 ;;
  *) 
  echo "${BOLD}${BG_RED}${BLACK} FAIL : ${RESET} Please either put y/n or yes/no " 
   exit 1 ;;
   esac 
fi

if [ -z $COVERAGE_OPTION ] ; then 
    echo -n ""   # it means nothing was passed but this echo is present here since we need at least one instruction for if conditional
else
if [ "$COVERAGE_OPTION" == "yes"  -o "$COVERAGE_OPTION" == "y" -o "$COVERAGE_OPTION" == "Y" -o "$COVERAGE_OPTION" == "YES" ] ; then 
    value=yes 
    condition_flag="-fprofile-arcs -ftest-coverage"

else 
 condition_flag=""
  echo "wrong coverage option, run $0 --help for more info  "
 fi  
 fi
#####################################################################################################
# Adding Dynamique Analysis in  the Makefile
#####################################################################################################
VALGRIND_OPTION=""
SANITIZER_OPTION=""
 echo -n "${BOLD}${BG_BLUE}${BLACK}INFO :${RESET} Would you like to add dynamique analysis to your makefile ? (y/n ) : " 
  read  ans 
  case $ans in 
  [Yy] | [Yy][eE][sS] ) # to test either y or Y or yes or YES or Yes or yEs or yeS or YeS or yES or YEs
  echo " ${BOLD}${BG_BLUE}${BLACK}INFO :${RESET} You can choose either Valgrind or Sanitizer"
  echo -n "Will you add Valgrind to your makefile ? (y/n) : "
  read ans 
  if [ "$ans" == "y" -o "$ans" == "yes" -o "$ans" == "YES" ] ; then 
    VALGRIND_OPTION="y"
  else 
    echo -n "${BOLD}${BG_BLUE}${BLACK}INFO :${RESET} Will you add SANITIZER to your makefile ? (y/n) : "
    read ans 
    if [ "$ans" == "y" -o "$ans" == "yes" -o "$ans" == "YES" ] ; then 
      SANITIZER_OPTION="y"
    fi
  fi  
  ;;
  [Nn] | [Nn][Oo] ) 
  echo "${BOLD}${BG_BLUE}${BLACK}INFO :${RESET} No dynamique analysis will be added to the project"
  ;;
  *) 
  echo "${BOLD}${BG_RED}${BLACK} FAIL :${RESET} Please either put y/n or yes/no " 
   exit 1 ;;
   esac 
############################################################################################################
# Generation of Makefile 
############################################################################################################
# compiler 
# a valgrind variable that will take yes if it is used
echo "#This Makefile was automatically generated using $0" >> $Makefile
echo "#For any problem report bug by opening an issue in the github project">> $Makefile
echo "CC=$CC" >> $Makefile
echo "VALGRIND_OPTION=$VALGRIND_OPTION">> $Makefile 
# cflags
if [  ${#VALGRIND_OPTION} -ne 0 ] ; then 
echo "CFLAG=$c_flag $condition_flag -g" >> $Makefile 
else 
 if [ ${#SANITIZER_OPTION} -ne 0 ] ; then 
echo "CFLAG=$c_flag $condition_flag -fsanitize=address,undefined -fno-omit-frame-pointer -g" >> $Makefile  
 else 
 echo "CFLAG=$c_flag $condition_flag" >> $Makefile 
fi
fi
#build path
build="$PROJECT_PATH/build"
#checks if the repo exists using the -d flag 
 if [[  -d $build ]] ; then 
   echo "the repository $build exists no need of creating one "
   listing=$(ls $build ) # to get the output of list
   if [  ${#listing} -eq 0 ] ; then  #did corrections as string was too large,so i did comparaison of length to 0 by auto calculating the length
                                     # but in the previous commits, the string length was compared to 0 which cause bugs as build list increases in size.
   echo "${BOLD}${BG_BLUE}${BLACK}INFO :${RESET} $build is empty no need of cleaning"
   else
   echo "${BOLD}${BG_BLUE}${BLACK}INFO :${RESET} The following files of $build will be deleted : $listing "
   echo "cleaning of it content............"
   if [ -z "$googletest" ] ; then 
   rm $build/* 
   else
    rm -r $build/*
   fi
   echo "${BOLD}${BG_GREEN}${BLACK} SUCCESS :${RESET} cleaning done, $build is empty"
   fi
 else 
   mkdir $build
fi     
   
echo "COVERAGE=$value" >> $Makefile 
echo "BUILD_DIR=build" >> $Makefile
echo "BIN = bin" >> $Makefile
#object sources 
# To take only that desired file
OBJ_SRC=()
 for i in "${array[@]}" ;
 do
  if [[ "$i" =~ "Unity/src/unity.c" ]] ; then  # =~ is to search for correspondance or Unity/src/unity.c in "$i" 
  OBJ_SRC+=("$i")
  fi
 done
 #echo "${OBJ_SRC[@]}"
 #to search all C files except those found in unity folder
 # I am searching again c files but this time i am excluding Unity folder"
 while IFS= read -r -d $'\0'  ; do 
      OBJ_SRC+=("$REPLY") 
done < <(find $PROJECT_PATH -type d \( -name 'Unity' -o -name 'googletest' \) -prune -false -o -name "*.$COMPILE_FILE" -print0) 

#echo "${OBJ_SRC[@]}"
# This line was modify in order to have the relative path of the c files with respect to the parent directory 
# So as to enable CI 
# tr is a linux command that stands for transform , it will transform '\n' to ' ' so that all c files will be on thesame line
echo "OBJS_SRC=$(realpath --relative-to="$PROJECT_PATH" "${OBJ_SRC[@]}" | tr '\n' ' ')" >> $Makefile

 if [ "$COMPILE_FILE" == "c" ] ; then
echo "OBJS=\$(patsubst %.c, %.o , \$(OBJS_SRC))" >> $Makefile 
#put \ before $ enables us to suppress it and echo it in the file 
##check wether a target is passed or not
elif [ "$COMPILE_FILE" == "cpp" ] ; then
echo "OBJS=\$(patsubst %.cpp, %.o , \$(OBJS_SRC))" >> $Makefile
fi
echo "ifeq (\$(MAKECMDGOALS),)" >> $Makefile
echo "\$(error \"error please pass a target, either clean or and run\")" >> $Makefile

echo "endif" >> $Makefile
echo ".PHONY: clean run" >> $Makefile 

echo "clean :" >> $Makefile 
if [ -z "$googletest" ] ; then
echo -e "\trm build/* ||:" >> $Makefile
else 
echo -e "\trm -r build/* ||:" >> $Makefile
fi
if [  ${#value} -ne 0 ] ; then 
 
echo -e "\trm -r coverage_report ||:" >> $Makefile
fi
if [  ${#VALGRIND_OPTION} -ne 0 ] ; then
echo -e "\trm valgrind.log ||:" >> $Makefile
fi

echo "run :bin " >> $Makefile 
if [ ${#VALGRIND_OPTION} -ne 0 ] ; then 
echo -e "\t@if [ \$(VALGRIND_OPTION) = y ] ; then \\" >> $Makefile
# the \\ in the line below is to enable \ in the makefile 
echo -e "\tvalgrind --leak-check=full --show-leak-kinds=all  --track-origins=yes --log-file=valgrind.log  ./\$(BIN); \\" >>$Makefile
echo -e "\telse \\" >> $Makefile
echo -e "\t\t./\$(BIN); \\" >> $Makefile  
echo -e "\tfi" >> $Makefile
else 
echo -e "\t./\$(BIN)" >> $Makefile 
fi

if [  ${#value} -ne 0 ] ; then 
echo  -e "\t@if [ \$(COVERAGE) = yes ] ; then \\" >> $Makefile
echo -e "\tlcov --directory . --capture --output-file coverage.info; \\" >>$Makefile
echo -e "\tgenhtml coverage.info --output-directory coverage_report; \\" >>$Makefile
echo -e "\tmv coverage.info \$(BUILD_DIR); \\" >> $Makefile
echo -e "\tfi" >> $Makefile
echo -e "\t@mv *.gcda \$(BUILD_DIR) || :" >>$Makefile
echo -e "\t@mv *.gcno \$(BUILD_DIR) || :" >>$Makefile
#i added this two lines because previously, the .gcda and .gcno files were present with c files, so the cleanning was not effective
echo -e "\t@find . -path \$(BUILD_DIR) -prune -o -name "*.gcda" -type f -exec mv -t \$(BUILD_DIR) -- {} + > /dev/null 2>&1 || :" >>$Makefile
echo -e "\t@find . -path \$(BUILD_DIR) -prune -o -name "*.gcno" -type f -exec mv -t \$(BUILD_DIR) -- {} + > /dev/null 2>&1 || : " >> $Makefile
# Explanations 
# The -path is to provide a target directory for the prune option
# The -prune option is to exclude files present in BUILD_DIR since we are making a search in the parent directory
# The -type f ensures the output is a file and not a directory 
# The -exec option is to use the shell to do an operation on the result of find
#let's break down mv -t $(BUILD_DIR) -- {} +
# -t is to specify the destination of move command 
# -- is to tell mv that all the following arguements are files 
# {} it contains the ouput of the find command 
# +  it means find can accumulate several files before executing mv 
# > /dev/null 2>&1 To suppress standard outputs and error messages
# ||: To avoid make to stop if it the command fails

fi
echo -e "\t@mv \$^ \$(BUILD_DIR)" >> $Makefile
echo "bin : \$(OBJS)" >> $Makefile
if [ "$COMPILE_FILE"=="cpp" ] && [ -n "$googletest" ] ; then   # this is to link all the objects created
LINK_LIBS=" -Lgoogletest/build/lib -lgtest_main -lgtest -lpthread"
 echo -e "\t\$(CC) \$(CFLAG) $^ -o  \$(BIN) $LINK_LIBS" >> $Makefile
else
echo -e "\t\$(CC) \$(CFLAG) $^ -o \$(BIN)" >> $Makefile
fi
# if [ "$COMPILE_FILE" == "c" ] ; then
echo -e "\t@mv \$^ \$(BUILD_DIR)" >> $Makefile 
#fi
 if [ "$COMPILE_FILE" == "c" ] ; then
echo "%.o : %.c" >> $Makefile
elif [ "$COMPILE_FILE" == "cpp" ] ; then 
echo "%.o : %.cpp" >> $Makefile
fi
echo -e "\t\$(CC) -c \$(CFLAG)  $^ -o \$@" >> $Makefile 
final_statement
echo -n "${BOLD}${BG_BLUE}${BLACK} INFO :${RESET} To run the makefile use this command "
echo  "make -C $PROJECT_PATH clean run"
