#!/bin/bash

#############################################
# DEFAULTS
#############################################
interactive_mode=false

# url
vpn_url=https://vpn.vub.be
vpn_certfile=$(dirname $0)/"vpn.vub.be.crt"

# credentials
vpn_username=$USER
vpn_password=""

#############################################
# USAGE
#############################################
function display_usage()
{
    echo 'Usage:' $0 ' [-c {certfile}] [-e] [-h] [-i] [-p {password}] [-u {username}]'
    echo
    echo 'Options:'
    echo -e "-c {certfile} \t\t Specify certfile"
    echo -e "-e \t\t\t Use external partner authentication"
    echo -e "-h \t\t\t Show this summary"
    echo -e "-i \t\t\t Use interactive mode"
    echo -e "-p {password} \t\t Specify vpn password"
    echo -e "-u {username} \t\t Specify vpn username"
    exit
}

if [ "$1" == "" ]
then
    display_usage
fi

#####################################
# ARGUMENTS
#####################################
while getopts c:ehip:u: opt; do
  case $opt in
      #####################################
      # option "external"
      #####################################
      c)
        vpn_certfile=${OPTARG}
      ;;
      #####################################
      # option "external"
      #####################################
      e)
        vpn_url="https://vpn.vub.be/partners/"
      ;;
      #####################################
      # option "help"
      #####################################
      h)
        display_usage
        exit 0
      ;;
      #####################################
      # option "interactive"
      #####################################
      i)
        interactive_mode=true
      ;;
      #####################################
      # option "password"
      #####################################
      p)
        vpn_password=${OPTARG}
      ;;
      #####################################
      # option "user"
      #####################################
      u)
        vpn_username=${OPTARG}
      ;;
      #####################################
      # illegal options
      #####################################
      \?)
	       echo "Invalid option: -$OPTARG" >&2
	       exit 1
	    ;;
      #####################################
      # required options
      #####################################
      :)
      	echo "Option -$OPTARG requires an argument." >&2
      	exit 1
	    ;;
  esac
done

#####################################
# SETUP VPN CONFIG
#####################################
# Add your credentials
declare -r vpn_user="$vpn_username"
declare -r connect_url="$vpn_url"
declare -r certfile="$vpn_certfile"

echo
echo 'This script must be run by root. Please enter your (sudo) password.'
echo

# command line example:
#sudo openconnect --juniper --user="brdooms" --passwd-on-stdin ssl.vub.ac.be

#####################################
# OPENCONNECT
#####################################
# check if openconnect installed
openconnect --version
echo
if [ ! $? -eq 0 ]
then
    echo Abort. Package openconnect not installed on your system!
    echo
    exit 1
fi

#####################################
# CONNECT TO VUB VPN
#####################################
if [[ $vpn_password == "" || $interactive_mode == "true" ]]
# interactive mode
then
  sudo openconnect \
    --juniper \
    --user="${vpn_user}" \
	--cafile "${certfile}" \
    "${connect_url}"
# non interctive mode, vpn_password is known
else
  echo -n $vpn_password |
  sudo openconnect \
   --juniper \
   --user="${vpn_user}" \
   --passwd-on-stdin \
   --cafile "${certfile}" \
   "${connect_url}"
fi

if [ ! $? -eq 0 ]
then
    echo
    echo Connection failed!
fi
echo
