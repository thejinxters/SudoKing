#!/bin/bash

CONFIG_PATH=/Users/${USER}/.sudoking
CONFIG_FILE=${CONFIG_PATH}/config

checkForConfig(){
if [[ ! -f ${CONFIG_FILE} ]]; then
    echo "Config file was not detected at ${configFile} \n";
    create_op_config_file;
fi
}

create_op_config_file() {
    echo "Setting up your 1Password Account:";
    prompt "Enter your sub-domain and press [ENTER]: ";
    echo "Use 'my' for my.1password.com";
    read -p "[Default: my]: " sub_domain;
    sub_domain=${sub_domain:-my};

    prompt "Enter your email address and press [ENTER]: ";
    read email_address;

    prompt "Enter your secret-key and press [ENTER]: ";
    echo "Get this from your 1password account, should look like XX-XXXXXX-XXXXXX-XXXXX-XXXXX-XXXXX-XXXXX";
    read secret_key;

    prompt "Enter the path to your 'op' binary [ENTER]: ";
    read -p "[Default: /usr/local/bin/op]: " op_binary;
    op_binary=${op_binary:-/usr/local/bin/op};

    prompt "Enter your desired session length in minutes [ENTER]: "
    echo "Set this from 0-30. This is the amount of time before you need to sign in again with your master password";
    read -p "[Default: 5]: " session_length;
    session_length=${session_length:-"5"};

    mkdir -p ${CONFIG_PATH};

    local json_str="{\"subdomain\":\"${sub_domain}\",\"email\":\"${email_address}\",\"secretKey\":\"${secret_key}\",\"pathToOPBinary\":\"${op_binary}\",\"sessionExpirationMinutes\":${session_length}}"

    echo $json_str > $CONFIG_FILE;
}

prompt() {
    echo -e "\n\x1B[32m${1}\x1B[0m";
}

execute() {
    CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )";
    ${CURRENT_DIR}/SudoKing.app/Contents/MacOS/SudoKing;
}

checkForConfig;
execute;
