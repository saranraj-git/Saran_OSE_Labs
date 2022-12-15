#!/bin/bash

# To run this file 
# bash <(curl -s https://raw.githubusercontent.com/saranraj-git/Saran_OSE_Labs/main/RHCSA_asmt/RHCSA_Saran.sh)
# curl -s https://raw.githubusercontent.com/saranraj-git/Saran_OSE_Labs/main/RHCSA_asmt/RHCSA_Saran.sh | bash

onea=$(cat /etc/group | grep cricket)
oneb=$(cat /etc/passwd | egrep 'rohit|kohli|hardik')
onec=$(cat /etc/shadow | egrep 'rohit|kohli|hardik')
logfile="Assessment_out_$(date +%d-%m-%Y_%H%M%S)"

if [[! -z $onea] && ["$onea" == *"cricket"*]]; then 
    echo "1a) PASSED (cricket group exists)" >> 
else
    echo "1a) FAILED (cricket group does not exists)"
fi

if [[ ! -z $oneb ] && [ "$onea" == *"rohit"* ] && [ "$oneb" == *"kohli"* ] && [ "$oneb" == *"hardik"* ] ]; then 
    echo "1b) PASSED (User rohit,kohli,hardik exists)"
else
    echo "1b) FAILED (User rohit,kohli,hardik does not exists)"
fi

if [[ ! -z $onec ] && [ "$onec" == *"rohit"* ] && [ "$onec" == *"kohli"* ] && [ "$onec" == *"hardik"* ] ]; then 
    echo "1b) PASSED (User rohit,kohli,hardik exists in shadow file)"
else
    echo "1b) FAILED (User rohit,kohli,hardik does not exists in shadow file)"
fi



