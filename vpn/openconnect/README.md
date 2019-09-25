# VUB Pulse Secure VPN on Linux

Connect with VUB Pulse Secure VPN on Linux. Tested on (K)Ubuntu.

## Getting Started

### Prerequisites

You need the package openconnect installed on your system. In Ubuntu, do:

```
sudo apt install openconnect
```

## Run the script

## Options

```
[-c {certfile}] [-e] [-h] [-i] [-p {password}] [-u {username}]

Options:
-c {certfile} Specify certfile
-e Use external partner authentication
-h Show this summary
-i Use interactive mode
-p {password} Specify vpn password
-u {username} Specify vpn username
```

All options are optional. If no username is supplied, the local system username is assumed. For security reasons, you may use the interactive mode.

Example:

```
./connect.sh -u mickey -p letmein
```

## Optional: Read the password on stdin with kde wallet (Kubuntu)

Name your password entry in KDE wallet as you wish, e.g. "sso".

```
~/Code/vub/vub-scripts/vpn/openconnect/connect.sh -p $(
    kwallet-query -r sso kdewallet)'
```

## Optional: Add the command to KDE menu (Kubuntu)

Install xterm package first.

Right click on the KDE menu > Edit Applications > New Item > Name + Command:

```
xterm -hold -e 'sudo /sbin/resolvconf --disable-updates; ~/Code/vub/vub-scripts/vpn/openconnect/connect.sh -p $(kwallet-query -r sso kdewallet)'
```
