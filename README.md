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
use the tree command. You can run script on the Test example provided to have a better idea of the project before implementing it in your project.
1. Clone the project 
```
cd ~
git clone --recurse-submodules https://github.com/dibreyjonatan/Makefile-generation-for-C-and-Cpp-code-compilation-using-Bash.git

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

 ### Project structure where Automation can be done 
This project structure holds for c or cpp.
> You only need to respect the tree structure 
 
 1.
 ```
 project 
 └── hello.c
 ```
 2. 
 ```
project 
├── header.c 
├── include.h 
└── program.c
```
 3. 
 ```
project 
├── include
│   ├── math_utils.h
│   └── message.h
├── main.cpp
├── src
│   └── math_utils.cpp
└── utils
    └── message.cpp
```
4.
```
project 
.
├── googletest
│   ├── BUILD.bazel
│   ├── ci
│   ├── CMakeLists.txt
│   ├── CONTRIBUTING.md
│   ├── CONTRIBUTORS
│   ├── docs
│   ├── fake_fuchsia_sdk.bzl
│   ├── googlemock
│   ├── googletest
│   ├── googletest_deps.bzl
│   ├── LICENSE
│   ├── MODULE.bazel
│   ├── README.md
│   ├── WORKSPACE
│   └── WORKSPACE.bzlmod
├── include
│   └── math_utils.h
├── src
│   ├── math_functions.cpp
│   └── math_utils.cpp
├── test
│   └── test_math_utils.cpp
└── utils
    └── math_functions.h

```


