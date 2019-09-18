#!/bin/bash

vpndomain=vpn.vub.be

#check NetID password
if [ $# -eq 0 ]
  then
    declare -r vpn_password=""
else
	  declare -r vpn_password=$1
fi

# Add your credentials
declare -r vpn_user="$USER"
declare -r connect_hostname="$vpndomain"
declare -r certfile=$(dirname $0)/"${vpndomain}.crt"

echo
echo 'This script must be run by root. Please enter your password.'
echo

if [[ $vpn_password == "" ]]
# interactive mode
then
  sudo /usr/sbin/openconnect \
    --juniper \
    --user="${vpn_user}" \
	  --cafile "${certfile}" \
    "${connect_hostname}"
# non interctive mode, vpn_password is known
else
  echo -n $vpn_password |
  sudo /usr/sbin/openconnect \
   --juniper \
   --user="${vpn_user}" \
   --passwd-on-stdin \
   --cafile "${certfile}" \
   "${connect_hostname}"

fi
# command line example:
#sudo openconnect --juniper --user="brdooms" --passwd-on-stdin ssl.vub.ac.be
