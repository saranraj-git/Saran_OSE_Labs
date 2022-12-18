#!/bin/bash

# Author: SARANRAJ V

# To run this file 
# bash <(curl -s https://raw.githubusercontent.com/saranraj-git/Saran_OSE_Labs/main/RHCSA_asmt/asmt_validation_script.sh)
#    or
# curl -s https://raw.githubusercontent.com/saranraj-git/Saran_OSE_Labs/main/RHCSA_asmt/asmt_validation_script.sh | bash

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'
BBlue='\033[1;34m'
totalscore=0
# logfile="Assessment_out_$(date +%d-%m-%Y_%H%M%S)"

function one(){
    onea=$(cat /etc/group | grep cricket)
    onebc=$(cat /etc/passwd | egrep 'rohit|kohli')
    oned=$(cat /etc/passwd | grep 'hardik') 
    echo -e "Validating Question 1: \n"
    [[ ! -z ${onea} ]] && [[ ${onea} == *"cricket"* ]] && echo -e "1a) ${GREEN}PASSED${NC} (cricket group exists)" || echo -e "1a) ${RED}FAILED${NC} (cricket group does not exists)"
    [[ ! -z ${onebc} ]] && [[ ${onea} == *"rohit"* ]] && echo -e "1b) ${GREEN}PASSED${NC} (User rohit belongs to the secondary group cricket)" || echo -e "1b) ${RED}FAILED${NC} (User rohit does not belongs to the secondary group cricket)"
    [[ ! -z ${onebc} ]] && [[ ${onea} == *"kohli"* ]] && echo -e "1c) ${GREEN}PASSED${NC} (User kohli belongs to the secondary group cricket)" || echo -e "1c) ${RED}FAILED${NC} (User kohli does not belongs to the secondary group cricket)"
    [[ ! -z ${oned} ]] && [[ ${oned} == *"nologin"* ]] && [[ ${onea} != *"hardik"* ]] && echo -e "1d) ${GREEN}PASSED${NC} (User hardik does not interactive shell access and non-member of cricket group)" || echo "1d) ${RED}FAILED${NC} (User hardik does not exists or the user does have shell acces or user might be member of cricket)"
    echo "Secret123" | /bin/su --command true - "rohit" 2>/dev/null
    [[ $? -eq 0 ]] && echo -e "1e) ${GREEN}PASSED${NC} (rohit password set to Secret123)" || echo -e "1e) ${RED}FAILED${NC} (rohit password set incorrect)"
    echo "Secret123" | /bin/su --command true - "kohli" 2>/dev/null
    [[ $? -eq 0 ]] && echo -e "1e) ${GREEN}PASSED${NC} (kohli password set to Secret123)" || echo -e "1e) ${RED}FAILED${NC} (kohli password set incorrect)"
    hardikshell=$(grep 'hardik' /etc/passwd | cut -d: -f7)
    [[ $hardikshell == *"nologin"* ]] && sudo usermod hardik -s /bin/bash
    echo "Secret123" | /bin/su --command true - "hardik" 2>/dev/null
    [[ $? -eq 0 ]] && echo -e "1e) ${GREEN}PASSED${NC} (hardik password set to Secret123)" || echo -e "1e) ${RED}FAILED${NC} (hardik password set incorrect)"
    hardikshell=$(grep 'hardik' /etc/passwd | cut -d: -f7)
    [[ $hardikshell == *"bash"* ]] && sudo usermod hardik -s /sbin/nologin
}

function two(){
    echo -e "\nValidating Question 2: \n"
    [[ -f /mnt/hosts ]] && echo -e "2a) ${GREEN}PASSED${NC} (file exists - /mnt/hosts)" || echo -e "2a) ${RED}FAILED${NC} (file does not exists - /mnt/hosts)"
    twob=$(find /mnt -name hosts -type f -user root)
    [[ ! -z $twob ]] && echo -e "2b) ${GREEN}PASSED${NC} (/mnt/hosts owned by root user)" || echo -e "2b) ${RED}FAILED${NC} (/mnt/hosts NOT owned by root user)"
    twoc=$(find /mnt -name hosts -type f -group root)
    [[ ! -z $twoc ]] && echo -e "2c) ${GREEN}PASSED${NC} (/mnt/hosts owned by root group)" || echo -e "2c) ${RED}FAILED${NC} (/mnt/hosts NOT owned by root group)"
    twod=$(stat -L -c "%a" /mnt/hosts)
    [[ $twod -eq 0 ]] &&  echo -e "2d) ${GREEN}PASSED${NC} (No user can rwx /mnt/hosts)" || echo -e "2d) ${RED}FAILED${NC} (someone can access /mnt/hosts)"
}

function three(){
    echo -e "\nValidating Question 3: \n"
    [[ -d '/open/source' ]] && echo -e "3) ${GREEN}Directory exists${NC} /open/source" || echo -e "3) ${RED}Directory not exists${NC} /open/source"
    [[ $(sudo stat -L -c "%U" '/open/source') == "jadeja" ]] && echo -e "3a) ${GREEN}PASSED${NC} (/open/source owned by jadeja)" || echo -e "3a) ${RED}FAILED${NC} (/open/source NOT owned by jadeja)"
    [[ $(sudo stat -L -c "%G" '/open/source') == "cricket" ]] && echo -e "3b) ${GREEN}PASSED${NC} (/open/source owned by group cricket)" || echo -e "3b) ${RED}FAILED${NC} (/open/source NOT owned by group cricket)"
    if [[ $(sudo stat -L -c "%a" '/open/source') -eq 2070 ]] || [[ $(sudo stat -L -c "%a" '/open/source') -eq 70 ]]; then
        echo -e "3c) ${GREEN}PASSED${NC} (/open/source - accessible only to cricket group members)"
    else
        echo -e "3c) ${RED}FAILED${NC} (/open/source - accessible to users who are not member of cricket group)"
    fi
    sudo touch /open/source/threetest
    [[ $(sudo stat -L -c "%G" '/open/source/threetest') == "cricket" ]] && echo -e "3d) ${GREEN}PASSED${NC} (new files in /open/source owned by group cricket)" || echo -e "3d) ${RED}FAILED${NC} (new files in /open/source NOT owned by group cricket)"
    sudo rm -rf /open/source/threetest
}

function four(){
    echo -e "\nValidating Question 4: \n"
    [[ -f '/root/find.jadeja' ]] && echo -e "${GREEN}/root/find.jadeja exists${NC}" || echo -e "${RED}/root/find.jadeja not exists${NC}"
    if [[ $(sudo stat -L -c "%U" $(sudo cat /root/find.jadeja) | uniq) == "jadeja" ]] && [[  -r '/root/find.jadeja' ]]; then
        echo -e "4) ${GREEN}PASSED${NC} - FILE /root/find.jadeja contains files list owned by jadeja and readable by others" 
    else
        echo -e "4) ${RED}FAILED${NC} - FILE /root/find.jadeja contains file list not owned by jadeja or not readable by others" 
    fi
}

function five(){
    echo -e "\nValidating Question 5: \n"
    # userdefumask=$(su -c 'umask' -l 'userdef')
    # dravidumask=$(su -c 'umask' -l 'dravid')
    # udefmaskcheck=$(grep 'umask' /home/userdef/.bash_profile)
    [[ -f /home/userdef/file2 ]] && rm -rf /home/userdef/file2
    [[ -d /home/dravid/dir3 ]] && rm -rf /home/dravid/dir3
    filecheck=$(runuser -l userdef -c 'source /home/userdef/.bash_profile; touch /home/userdef/file2; stat -L -c "%a" /home/userdef/file2')
    dircheck=$(runuser -l dravid -c 'source /home/dravid/.bash_profile; mkdir /home/dravid/dir3; stat -L -c "%a" /home/dravid/dir3')
    [[ $filecheck -eq 440 ]] && echo -e "5) ${GREEN}PASSED${NC} - newly created file have –r--r----- permissions" || echo -e "5) ${RED}FAILED${NC} - newly created file does not have –r--r----- permissions"
    [[ $dircheck -eq 550 ]] && echo -e "5) ${GREEN}PASSED${NC} - newly created dir have dr-xr-x--- permissions" || echo -e "5) ${RED}FAILED${NC} - newly created dir does not have dr-xr-x--- permissions"
    
}

function six(){
    echo -e "\nValidating Question 6: \n"
    flag="true"
    if [[ -f /root/nologin-files ]]; then
        echo -e "${GREEN}File exists${NC} - /root/nologin-files"
        while read line; do
            if [[ $line != *"nologin"* ]]; then
                flag="false"
                break
            fi
        done</root/nologin-files
        [[ $flag == "true" ]] && echo -e "6) ${GREEN}PASSED${NC} - /root/nologin-files contains only nologin entries" || echo -e "6) ${RED}FAILED${NC} - /root/nologin-files contains entries other than nologin" 
    else
        echo -e "6) ${RED}FAILED${NC} File not exists - /root/nologin-files"  
    fi
}

function seven(){
    echo -e "\nValidating Question 7: \n"
    sev=$(grep ^"rhcsa" /etc/passwd)
    if [[ ! -z $sev ]]; then 
        echo -e "${GREEN}rhcsa user exists${NC}" 
        seva=$(echo $sev | cut -d: -f3)
        sevb=$(echo $sev | cut -d: -f4)
        sevc=$(echo $sev | cut -d: -f7)
        sevd=$(echo $sev | cut -d: -f5)
        [[ ${seva} -eq 3030 ]] && echo -e "7a) ${GREEN}PASSED${NC} userid 3030 found for user rhcsa" || echo -e "7a) ${RED}FAILED${NC} userid 3030 NOT found for user rhcsa"
        [[ ${sevb} -eq 4040 ]] && echo -e "7b) ${GREEN}PASSED${NC} primary groupid 4040 found for user rhcsa" || echo -e "7b) ${RED}FAILED${NC} primary groupid 4040 NOT found for user rhcsa"
        [[ ${sevc} == "/bin/sh" ]] && echo -e "7c) ${GREEN}PASSED${NC} default shell /bin/sh found for user rhcsa" || echo -e "7c) ${RED}FAILED${NC} default shell /bin/sh NOT found for user rhcsa"
        [[ ${sevd} == "devops-engineer" ]] && echo -e "7d) ${GREEN}PASSED${NC} user comment 'devops-engineer' found for user rhcsa" || echo -e "7d) ${RED}FAILED${NC} user comment 'devops-engineer' found for user rhcsa"
    else
        echo -e "7) ${RED}FAILED${NC} rhcsa user does not exists"
    fi
}

function eight(){
    echo -e "\nValidating Question 8: \n"
    if [[ -f /tmp/localusers ]]; then
        echo -e "${GREEN}File exists - /tmp/localusers${NC}"
        sudo cat /etc/passwd | egrep -w '/bin/bash|/bin/sh|/bin/csh|/bin/ksh' | cut -d: -f1 > /tmp/validusers
             
        invaliduser="false"
        while read line; do
            if [[ -z `grep -w $line /tmp/validusers` ]] && [[ ! -z `echo $line | cut -d: -f2` ]]; then
                invaliduser="true"
                break
            fi
        done</tmp/localusers
        
        [[ $invaliduser == "false" ]] && echo -e "8a) ${GREEN}PASSED${NC} /tmp/localusers contains only valid usernames" || echo -e "8a) ${RED}FAILED${NC} /tmp/localusers contains invalid usernames/format"
        
    else
        echo -e "8) ${RED}FAILED${NC} File NOT exists - /tmp/localusers${NC}"
    fi
    
}

function nine(){
    echo -e "\nValidating Question 9: \n"
    if [[ -f /root/display.sh ]]; then
        echo -e "${GREEN}File exists /root/display.sh${NC}"
        runuser -l root -c 'cd /; display.sh'
        if [[ $? -eq 0 ]]; then
            echo -e "9) ${GREEN}PASSED${NC} display.sh can be executed from any path in this machine" 
            invalidcontent="false"
            display.sh > /tmp/nine
            if [[ $(cat /tmp/nine | wc -l) -eq 10 ]]; then
                echo "9) ${GREEN}PASSED${NC} display.sh prints exactly 10 lines"
                while read line; do
                    if [[ $line != "Good Learning Linux" ]]; then
                        invalidcontent="true"
                        break
                    fi
                done</tmp/nine
                [[ ${invalidcontent} == "false" ]] && echo "9) ${GREEN}PASSED${NC} display.sh printing 'Good Learning Linux' 10 times" || echo "9) ${RED}FAILED${NC} display.sh not printing 'Good Learning Linux' 10 times"
            else
                echo "9) ${RED}FAILED${NC} display.sh not printing 'Good Learning Linux' 10 times"  
            fi
        else 
            echo -e "9) ${RED}FAILED${NC} display.sh cannot be executed from any path in this machine"
        fi
    else
        echo -e "9) ${RED}FAILED${NC} File NOT exists /root/display.sh${NC}"
    fi
}

function ten(){
    echo -e "\nValidating Question 10: \n"
}

echo -e "\n*** ${BBlue}OSE LABS - RHCSA Course - Assessment 1 Validation${NC} ***\n"
one
two
three
four
five
six
seven
eight
nine
ten