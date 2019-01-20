#!/bin/bash

CONFIG_PATH=/Users/${USER}/.sudoking
CONFIG_FILE=${CONFIG_PATH}/config
DEBUG_ENABLED=false

main() {
    while test $# -gt 0; do
        case "$1" in
        -h|--help)
            usage
            exit 0
            ;;
        -d|--debug)
            shift
            DEBUG_ENABLED=true
            ;;
        -c|--configure)
            shift
            local configure=true
            ;;
        *)
            break
            ;;
        esac
    done
    if [[ ${configure} == "true" ]]; then
        debug "creating configuration file"
        create_op_config_file
    else
        debug "checking for configuration file at ${CONFIG_FILE}"
        check_for_config
        debug "executing Sudo King application"
        execute_app
    fi
}

usage() {
    echo "Sudo King - easily use 1Password from iTerm"
    echo " "
    echo "usage: sudoking [options]"
    echo " "
    echo "options:"
    echo "-h, --help                show brief help"
    echo "-d, --debug               enable debug information"
    echo "-c, --configure           create/update password manager config"
}

check_for_config(){
    if [[ ! -f ${CONFIG_FILE} ]]; then
        error "No configuration file exists. Please run with '--configure' or create a config file: ${CONFIG_FILE} \n"
        usage
        exit 1
    fi
}

create_op_config_file() {
    prompt "Setting up your 1Password Account:"
    prompt "Enter your sub-domain and press [ENTER]: "
    echo "Use 'my' for my.1password.com"
    read -p "[Default: my]: " sub_domain
    sub_domain=${sub_domain:-my}

    prompt "Enter your email address and press [ENTER]: "
    read email_address

    prompt "Enter your secret-key and press [ENTER]: "
    echo "Get this from your 1password account, should look like XX-XXXXXX-XXXXXX-XXXXX-XXXXX-XXXXX-XXXXX"
    read secret_key

    prompt "Enter the path to your 'op' binary [ENTER]: "
    read -p "[Default: /usr/local/bin/op]: " op_binary
    op_binary=${op_binary:-/usr/local/bin/op}

    prompt "Enter your desired session length in minutes [ENTER]: "
    echo "Set this from 0-30. This is the amount of time before you need to sign in again with your master password"
    read -p "[Default: 5]: " session_length
    session_length=${session_length:-"5"}

    debug "Creating config folder: ${CONFIG_PATH}"
    mkdir -p ${CONFIG_PATH}

    debug "Building json string:"
read -r -d '' json_str <<EOF
{\n
    \t"subdomain":"${sub_domain}",\n
    \t"email":"${email_address}",\n
    \t"secretKey":"${secret_key}",\n
    \t"pathToOPBinary":"${op_binary}",\n
    \t"sessionExpirationMinutes":${session_length}\n
}
EOF
    debug "${json_str}"

    echo -e ${json_str} > ${CONFIG_FILE}
    debug "wrote config to ${CONFIG_FILE}"
}

execute_app() {
    CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
    local app=${CURRENT_DIR}/SudoKing.app/Contents/MacOS/SudoKing
    debug "Launching ${app}"
    ${app}
}

prompt() {
    echo -e "\n\x1B[32m${1}\x1B[0m"
}

error() {
    echo -e "\n\x1B[31m${1}\x1B[0m"
}

debug() {
    if [[ ${DEBUG_ENABLED} == "true" ]]; then
        echo -e "\x1B[34m${1}\x1B[0m"
    fi
}

main $@;
