# Makefile-generation-for-C-and-Cpp-code-compilation-using-Bash
Generation of Makefile for the compilation of C or C++ code using Bourne again shell 
## Version of tools used 
```
gcc  11.4.0
g++  11.4.0
GNU Make 4.3
valgrind-3.18.1
```
## Installing dependencies
- Install lcov for report 
```
sudo apt update
sudo apt install -y lcov
```
- Install valgrind for dynamique analysis
```
sudo apt update
sudo apt install valgrind
```
## How to use this project ? 
Overview 
> * Look at the directory structure supported for now in the Test folder 
use the tree command 
1. Clone the project 
```
cd ~
git clone https://github.com/dibreyjonatan/Makefile-generation-for-C-and-Cpp-code-compilation-using-Bash.git

cd Makefile-generation-for-C-and-Cpp-code-compilation-using-Bash

```
2. Make the script executable
```
chmod +x generate_makefile_from_bash.sh
```
3. Copy the path of the folder where you want to generate the Makefile
> Please provide absolute path to the directory 
 ```
 export PATH=~/C/path_to_dir
 ./generate_makefile_from_bash.sh --path $(PATH) --compile_file c

 ```
 for more help do :
 > ./generate_makefile_from_bash.sh --help