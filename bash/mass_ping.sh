#!/bin/bash
# Easy mass pinging

function control_c(){
    echo -en "\nExiting\n"
    exit 1
}

function mass_ping(){
    local network=${1}
    local from=${2}
    local to=${3}
    local pingable=()
    echo "Pingable IPs ${network}.${from} - ${network}.${to}"

    for i in $(seq ${from} ${to}); do
        echo -ne "Pinging ${network}.${i} ...\033[0K\r"
        if  ping -c 2 ${network}.${i} &> /dev/null; then
            pingable+=("${network}.${i}")
        fi
    done
    echo -e "\033[2K"
    for i in "${pingable[@]}"; do
        echo ${i}
    done
}

# Main
trap control_c SIGINT

mass_ping 10.22.18 2 254
mass_ping 172.16.106 2 254
mass_ping 192.168.30 2 254
