#!/bin/bash
#
# to get the lastest version of this script run the following command
# wget https://raw.githubusercontent.com/IBM/ibm-dte-openlab-samples/master/satellite/deployIBMSatL3.bash
# chmod +x ./satelliteSwapIPS.bash
#



# move to home directory if not already there
cd $HOME

# some variables we will need
export origIFS=$IFS
export AWSREGION="us-east-2"
export AWS_INSTALL="$HOME/awsinstall"        # directory for binary
export BIN="$HOME/bin"
export AWS_DESCRIBE_INSTANCES="$HOME/awsInstances.txt"




#---------------------------------------------------------------------------------------------
# cleanup temporary files
#
#---------------------------------------------------------------------------------------------


cleanup() {
#	rm $AWS_DESCRIBE_INSTANCES || echo "Unable to remove temporary file: $AWS_DESCRIBE_INSTANCES"
}

#---------------------------------------------------------------------------------------------
# Test an IP address for validity:
# Usage:
#      valid_ip IP_ADDRESS
#      if [[ $? -eq 0 ]]; then echo good; else echo bad; fi
#   OR
#      if valid_ip IP_ADDRESS; then echo good; else echo bad; fi
#---------------------------------------------------------------------------------------------
function valid_ip()
{
    local  ip=$1
    local  stat=1
# echo "valid_ip $ip"

    if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        OIFS=$IFS
        IFS='.'
        ip=($ip)
        IFS=$OIFS
        [[ ${ip[0]} -le 255 && ${ip[1]} -le 255 \
            && ${ip[2]} -le 255 && ${ip[3]} -le 255 ]]
        stat=$?
    fi
# echo "valid_ip stat = $stat"
    return $stat
}

#---------------------------------------------------------------------------------------------
# prompt utility
# usage:
#    yesno "prompt with all spaces and punctiation (y|n)? "
#    returns 0 for Yes|Y|y
#    returns 1 for No|N|n
#---------------------------------------------------------------------------------------------

yesno() {

	read -p "$@" -n 1 -r
	echo

	if [[ $REPLY =~ ^[Yy]$ ]]
	then
		return 0
	elif [[ $REPLY =~ ^[Nn]$ ]]
	then
		return 1
	else
		echo "Invalid response, please try again."
		# echo "\$@ = $@"
		# making recursive call and returning valid answer back... eventually
		yesno "$@"
		return $?
	fi
}

#---------------------------------------------------------------------------------------------
# Main flow
# currently prompting before we take any action
#---------------------------------------------------------------------------------------------


# install AWS CLI
# yesno "Do you want to download and install the AWS CLI (y|n)? " && installAWSCLI || echo "Skipping AWS CLI install."



echo
# cleanup
yesno "Do you want to remove temporary files (y|n)? " && cleanup || echo "Skipping removal of temporary files."
