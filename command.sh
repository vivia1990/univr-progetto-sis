#!/bin/bash

RED='\033[1;31m'
BLUE='\033[1;34m'
PURP='\033[1;35m'
CYAN='\033[1;36m'
NC='\033[0m'

copy_files() {
    cp ./non_ottimizzato/*.blif ./
    echo -e "${PURP}File copiati${NC}"
}

del_files() {
    echo -e "${RED}Stai per eliminare tutti i .blif della directory corrente${NC}"
    read -p "Continuare? (Y/N): " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 1
    rm *.blif
}

minimization() {
    echo -e "${PURP}Inizio ottimizzazione${BLUE}\n"
    sis <<SIS 
source scripts/minimize.s
quit
SIS
    echo -e "\n"
    echo -e "${PURP}Fine ottimizzazione ${NC}"
}

deploy_project() {
    echo -e "${CYAN}Deploy... ${NC}\n"
    copy_files
    minimization

    echo -e "${CYAN}Deploy completato! ${NC}\n"
}

parse_test() {
    local expArr=()
    local outArr=()
    local text=$1
    local outPuts=$(echo $text| grep -oE ': ([0-1]\s)+')
    local expected=$(echo "$text" | grep -oE '[\-\>]+ ([0-1]\s)+')
    local retFlag=1    
    
    local counter=0
    local value=''
    printf "Expected: \n"
    while IFS='>' read -ra temp; do
        for i in "${temp[@]}"; do
            if [[ -n "${i}" ]]; then
                value=$(echo $i | xargs)
                echo "${value} Numero ${counter}"
                expArr[$counter]=$value
                let "counter++"
            fi            
        done
    done <<< "$expected"

    counter=0
    value=''
    printf "Outputs: \n"
    while IFS=':' read -ra temp; do
        for i in "${temp[@]}"; do
            if [[ -n "${i}" ]]; then
                value=$(echo $i | xargs)
                echo "${value} Numero ${counter}"
                outArr[$counter]=$value
                let "counter++"
            fi            
        done
    done <<< "$outPuts"    
    
    printf "\n"
    for ((idx=0; idx < ${#expArr[@]}; ++idx)); do                     
        if [[ "${outArr[$idx]}" != "${expArr[$idx]}" ]]; then
            echo -e "${RED}Test ${idx} fallito${NC}"
            retFlag=0
        fi
    done

    return $retFlag        
}

test_project() {
    local text=""
    local sisPath=$(which sis)
    echo -e "${CYAN}Inizio test${BLUE}\n"

    text="$($sisPath <<EOF  
source tests/istanze.test
quit
EOF
)"     
    parse_test "$text"
    local result=$?    
    if [[ $result == 1 ]]; then
        echo -e "${CYAN}Passato!${NC}"
    else
        echo -e "${RED}Test fallito!${NC}"
    fi

    echo -e "${CYAN}\nFine test!${NC}"
}

declare -A options
options[copy]=copy_files
options[delete]=del_files
options[minimize]=minimization
options[deploy]=deploy_project
options[test]=test_project

name_command=$1
flag=0
for key in "${!options[@]}"; do
    if [[ $key == $name_command ]]; then
        flag=1
        break;
    fi
done

if [[ $flag == 0 ]]; then
    echo -e "${RED} Comando non valido! Vedi documentazione${NC}"
    exit 1
fi

${options[$name_command]}

