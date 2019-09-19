#!/bin/bash

# set defaults
interactive_mode=false
# domain
vpn_url=https://vpn.vub.be
vpn_certfile=$(dirname $0)/"vpn.vub.be.crt"
# credentials
vpn_username=$USER
vpn_password=""

#############################################
# CHECK IF OPTIONS ARE SET
#############################################
if [ "$1" == "" ]
then
    echo 'Usage:' $0 ' [-i] [-p {password}] [-u] [-e] [-c]'
    echo "-c Certfile [optional]"
    echo "-i Interactive Mode [optional]"
    echo "-e External User [optional]"
    echo "-u VPN Username [optional]"
    echo "-p VPN Password [optional]"
    exit
fi

#####################################
# ARGUMENTS
#####################################
# c,s,e expect parameters, v does not
while getopts c:eip:u: opt; do
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

# Add your credentials
declare -r vpn_user="$vpn_username"
declare -r connect_url="$vpn_url"
declare -r certfile="$vpn_certfile"

echo
echo 'This script must be run by root. Please enter your (sudo) password.'
echo

# command line example:
#sudo openconnect --juniper --user="brdooms" --passwd-on-stdin ssl.vub.ac.be

# check if openconnect installed
openconnect --version
echo
if [ ! $? -eq 0 ]
then
    echo Abort. Package openconnect not installed on your system!
    echo
    exit 1
fi

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
