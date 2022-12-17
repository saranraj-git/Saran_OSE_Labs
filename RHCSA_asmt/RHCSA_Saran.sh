#!/bin/bash

# To run this file 
# bash <(curl -s https://raw.githubusercontent.com/saranraj-git/Saran_OSE_Labs/main/RHCSA_asmt/RHCSA_Saran.sh)
# curl -s https://raw.githubusercontent.com/saranraj-git/Saran_OSE_Labs/main/RHCSA_asmt/RHCSA_Saran.sh | bash

onea=$(cat /etc/group | grep cricket)
onebc=$(cat /etc/passwd | egrep 'rohit|kohli')
oned=$(cat /etc/passwd | grep 'hardik') 

logfile="Assessment_out_$(date +%d-%m-%Y_%H%M%S)"

function one(){
    if [[ ! -z ${onea} ]] && [[ ${onea} == *"cricket"* ]]; then
        echo "1a) PASSED (cricket group exists)"
    else
        echo "1a) FAILED (cricket group does not exists)"
    fi
    
    if [[ ! -z ${onebc} ]] && [[ ${onea} == *"rohit"* ]]; then
        echo "1b) PASSED (User rohit belongs to the secondary group cricket)"
        
    else
        echo "1b) FAILED (User rohit does not belongs to the secondary group cricket)"
    fi
    
    if [[ ! -z ${onebc} ]] && [[ ${onea} == *"kohli"* ]]; then
        echo "1c) PASSED (User kohli belongs to the secondary group cricket)"
    else
        echo "1c) FAILED (User kohli does not belongs to the secondary group cricket)"
    fi
    
    if [[ ! -z ${oned} ]] && [[ ${oned} == *"nologin"* ]] && [[ ${onea} != *"hardik"* ]]; then
        echo "1d) PASSED (User hardik does not interactive shell access and non-member of cricket group)"
    else
        echo "1d) FAILED (User hardik does not exists or the user does have shell acces or user might be member of cricket)"
    fi
    
    echo "Secret123" | /bin/su --command true - "rohit"
    [[ $? -eq 0 ]] && echo "1e) PASSED (rohit password set to Secret123)" || echo "1e) FAILED (rohit password set incorrect)"
    echo "Secret123" | /bin/su --command true - "kohli"
    [[ $? -eq 0 ]] && echo "1e) PASSED (kohli password set to Secret123)" || echo "1e) FAILED (kohli password set incorrect)"
    echo "Secret123" | /bin/su --command true - "hardik"
    [[ $? -eq 0 ]] && echo "1e) PASSED (hardik password set to Secret123)" || echo "1e) FAILED (hardik password set incorrect)"
}

function two(){
    [[ -f /mnt/hosts ]] && echo "2a) PASSED (file exists - /mnt/hosts)" || echo "2a) FAILED (file does not exists - /mnt/hosts)"
    twob=$(find /mnt -name hosts -type f -user root)
    [[ ! -z $twob ]] && echo "2b) PASSED (/mnt/hosts owned by root user)" || echo "2b) FAILED (/mnt/hosts NOT owned by root user)"
    twoc=$(find /mnt -name hosts -type f -group root)
    [[ ! -z $twoc ]] && echo "2c) PASSED (/mnt/hosts owned by root group)" || echo "2c) FAILED (/mnt/hosts NOT owned by root group)"
    twod=$(stat -L -c "%a %G %U" /mnt/hosts)
    [[ $twod -eq 0 ]] &&  echo "2d) PASSED (No user can rwx /mnt/hosts)" || echo "2d) FAILED (someone can access /mnt/hosts)"
}

one
two