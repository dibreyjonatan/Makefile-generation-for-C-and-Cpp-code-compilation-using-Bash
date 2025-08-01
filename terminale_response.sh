#!/bin/bash

#message code color :

#pass : green 
#warning : yellow
#fail or error : red
#info : blue 

BOLD=$(tput bold)
GREEN=$(tput setaf 2)
CYAN=$(tput setaf 6)
RESET=$(tput sgr0)
RED=$(tput setaf 1)

start(){
echo "${BOLD}${CYAN}╔══════════════════════════════════════════════════════════════════════════════════════════════════╗"
echo "║     🚀 Welcome, please follow the instructions below to generate your Makefile                   ║"
echo "╚══════════════════════════════════════════════════════════════════════════════════════════════════╝${RESET}"
}
success_msg() {
    BOLD=$(tput bold)
    RESET=$(tput sgr0)
    BLACK=$(tput setaf 0)
    BG_GREEN=$(tput setab 2)
    echo "${BOLD}${BG_GREEN}${BLACK} SUCCESS :${RESET} $1"
}
warn_msg() {
    BOLD=$(tput bold)
    RESET=$(tput sgr0)
    BLACK=$(tput setaf 0)
    YELLOW=$(tput setaf 3)
    BG_YELLOW=$(tput setab 3)
    echo  "${BOLD}${BG_YELLOW}${BLACK} WARNING :${RESET} $1"
}

fail_msg() {
    BOLD=$(tput bold)
    RESET=$(tput sgr0)
    BLACK=$(tput setaf 0)
    RED=$(tput setaf 1)
    BG_RED=$(tput setab 1)
    echo  "${BOLD}${BG_RED}${BLACK} FAIL :${RESET} $1"
}

info_msg() {
    BOLD=$(tput bold)
    RESET=$(tput sgr0)
    BLACK=$(tput setaf 0)
    BLUE=$(tput setaf 4)
    BG_BLUE=$(tput setab 4)
    echo "${BOLD}${BG_BLUE}${BLACK}INFO :${RESET} $0"
}

final_statement(){
BOLD=$(tput bold)
    RESET=$(tput sgr0)
    BLACK=$(tput setaf 0)
    BG_GREEN=$(tput setab 2)
    echo "${BOLD}${BG_GREEN}${BLACK} Your Makefile was successfully generated, please open your project directory ${RESET}"
}


