#!/bin/bash

LOG_FILE="/var/log/devopsfetch/devopsfetch.log"

display_usage() {
    echo "Usage: $0 [options]"
    echo "Options:"
    echo "  -p, --port [PORT]      Display all active ports and services or details of a specific port"
    echo "  -d, --docker [NAME]    List all Docker images and containers or details of a specific container"
    echo "  -n, --nginx [DOMAIN]   Display all Nginx domains and their ports or details of a specific domain"
    echo "  -u, --users [USERNAME] List all users and their last login times or details of a specific user"
    echo "  -t, --time [RANGE]     Display activities within a specified time range"
    echo "  -h, --help             Display this help message"
}


get_active_ports() {
    if [ -z "$1" ]; then
        output=$(sudo lsof -i -P -n | awk 'BEGIN {print "PORT\tSERVICE\tUSER"} NR>1 {split($9, a, ":"); port=a[length(a)]; if (port != "*") port=a[2]; print port "\t" $1 "\t" $3}' | column -t)
    else
        output=$(sudo lsof -i -P -n | awk -v port="$1" 'BEGIN {print "PORT\tSERVICE\tUSER"} NR>1 {split($9, a, ":"); p=a[length(a)]; if (p != "*" && p == port) {print p "\t" $1 "\t" $3}}' | column -t
)
    fi

    if [ -z "$output" ]; then
        echo "Error: No matching ports found"
        return 1
    else
        echo "$output"
    fi
}

get_docker_info() {
    if [ -z "$1" ]; then
        echo "Images:"
        sudo docker images
        echo
        echo "Containers:"
        sudo docker ps -l
    else
        sudo docker ps --filter name="$1"
    fi
}

get_nginx_info() {
    if [ -z "$1" ]; then
        sudo grep -r -E '^\s*server_name|^\s*listen' /etc/nginx/ | awk -F'[ :]+' '/listen/ {port=$NF} /server_name/ {print $NF " " port}' | sort | column -t -N "SERVER_NAME,PORT"| tr -d ';'
    else
        sudo grep -r -E '^\s*server_name|^\s*listen' /etc/nginx/ | awk -F'[ :]+' '/listen/ {port=$NF} /server_name/ {print $NF " " port}' | grep $1 | column -t -N "SERVER_NAME,PORT"| tr -d ';'

    fi
}


get_user_info() {
    if [ -z "$1" ]; then
        (last -w |grep -vE '^(reboot|wtmp) '| awk '!seen[$1]++ {print $1, $4, $5, $6, $7}'; 
        awk -F: '$3 >= 1000 && $3 != 65534 {print $1}' /etc/passwd | 
        while read user; do 
        if ! last -w | grep -q "^$user "; then 
            echo "$user Never"
        fi
        done) | sort | column -t -N "USER,LAST_LOGIN"
    else
        (last -w | grep -vE '^(reboot|wtmp)' | awk -v user="$1" '$1 == user {print $1, $4, $5, $6, $7}'; 
        if ! last -w | grep -q "^$1 "; then 
            echo "$1 Never"
        fi) | sort | column -t -N "USER,LAST_LOGIN"
    fi
}


get_time_range_info() {
    if [ -z "$2" ]; then
        journalctl --since=$1 --until="$1 23:59:59"
    else
        journalctl --since="$1" --until="$2"
    fi
}


while [[ "$#" -gt 0 ]]; do
    case $1 in
        -p|--port)
            PORT=$2
            shift "$#" # shift according to the number of arguement passed
            get_active_ports $PORT
            ;;
        -d|--docker)
            DOCKER=$2
            shift "$#"
            get_docker_info $DOCKER
            ;;
        -n|--nginx)
            DOMAIN=$2
            shift "$#"
            get_nginx_info $DOMAIN
            ;;
        -u|--users)
            USER=$2
            shift "$#" 
            get_user_info $USER
            ;;
        -t|--time)
            TIME_FROM=$2
            TIME_TO=$3
            shift "$#"
            get_time_range_info $TIME_FROM $TIME_TO
            ;;
        -h|--help)
            display_usage
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            display_usage
            exit 1
            ;;
    esac
done
