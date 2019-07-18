#!/bin/sh
#####################################################
# Function: config ssh
#
# Params:   1: user: user name for ssh login
#           2: host: host name for ssh login
#           3: password:  password for ssh-copy-id
#           4: sshpubkey: ssh publick key
#           5: sshkey:    ssh key
#           6: sshport:   ssh port
#
# Return:
#           0: ssh config succussfully
#           1: parameter number check failed
#           2: ssh public key does not exist
#           3: ssh key does not exist
#           4: command(ssh/ssh-copy-id/expect) not found
#           5: ssh config check failed
#
#####################################################
PARAM_USER=$1
PARAM_HOST=$2
PARAM_PASSWORD=$3
PARAM_SSH_KEY_PUB=$4
PARAM_SSH_KEY=$5
PARAM_SSH_PORT=$6

#RETURN STATE
RET_SSH_CONNECTED=0
RET_SSH_PARAM_FAILED=1
RET_SSH_PUBKEY_FAILED=2
RET_SSH_KEY_FAILED=3
RET_CMD_NOTFOUND=4
RET_SSH_CHECK_FAILED=5
#DISPLAY_MODE
DISPLAY_MODE_DEBUG="DEBUG"
DISPLAY_MODE_QUIET="QUIET"
#SSH CONFIG TIMEOUT
EXPECT_TIMEOUT=30

var_display_mode=${DISPLAY_MODE_DEBUG}
var_expect_timeout=${EXPECT_TIMEOUT}

# display output message
print_message(){
  if [ _"${var_display_mode}" != _"${DISPLAY_MODE_QUIET}" ]; then
    echo $*
  fi
}

# function usage 
usage(){
  print_message "usage: $0 user host password ssh-pub-key ssh-key port "
  print_message "   eg: $0 root host131 pass123 /root/.ssh/id_rsa.pub /root/.ssh/id_rsa 22"
  print_message ""
}

# check command existence
check_command_existence(){
  command_name="$1"

  which "${command_name}" >/dev/null 2>&1
  if [ $? -ne 0 ]; then
    print_message "command: ${command_name} does not exist"
    exit ${RET_CMD_NOTFOUND}
  fi
}

# check ssh connection
check_ssh_connection(){
  var_ssh_user="$1"
  var_ssh_host="$2"

  check_command_existence ssh

  # check connection
  ssh -p ${PARAM_SSH_PORT} ${var_ssh_user}@${var_ssh_host} hostname >/dev/null 2>&1
  if [ $? -eq 0 ]; then
    print_message "ssh connection to [$var_ssh_host] with user [$var_ssh_user] success configured."
    exit ${RET_SSH_CONNECTED}
  else
    print_message "ssh connection to [$var_ssh_host] with user [$var_ssh_user] failed."
    exit ${RET_SSH_CHECK_FAILED}
  fi
}

# config ssh by using ssh-copy-id & expect
config_ssh(){
  var_user="$1"
  var_host="$2"
  var_password="$3"
  var_key_pub="$4"
  var_key="$5"
  var_port="$6"

  check_command_existence ssh-copy-id
  check_command_existence expect

  expect <<-EOF
set time ${var_expect_timeout}
spawn ssh-copy-id -f -p ${var_port} -i  ${var_key_pub} -o "IdentityFile ${var_key}" ${var_user}@${var_host}
expect {
"*yes/no" { send "yes\r"; exp_continue }
"*password:" { send "${var_password}\r" }
}
expect eof
EOF
}

# check parameters
if [ $# -ne 6 ]; then
  usage
  exit ${RET_SSH_PARAM_FAILED}
fi

if [ ! -f "${PARAM_SSH_KEY_PUB}" ]; then
  print_message "ssh public key does not exist: ${PARAM_SSH_KEY_PUB}"
  usage
  exit ${RET_SSH_PUBKEY_FAILED}
fi

if [ ! -f "${PARAM_SSH_KEY}" ]; then
  print_message "ssh key does not exist: ${PARAM_SSH_PUB}"
  usage
  exit ${RET_SSH_KEY_FAILED}
fi

# config ssh
config_ssh ${PARAM_USER} ${PARAM_HOST} ${PARAM_PASSWORD} ${PARAM_SSH_KEY_PUB} ${PARAM_SSH_KEY} ${PARAM_SSH_PORT}

# check connection
check_ssh_connection ${PARAM_USER} ${PARAM_HOST}
