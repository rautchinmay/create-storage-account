function check_or_create_storage_account() {
    # 1=name
    # 2=Resource Group Name
    echo "Checking if storage account $1 for resource group $2 already exist"
    STORAGE_ACCOUNT=`${AZ_CLI} storage account show --name $1 --resource-group $2 2>/dev/null`
    if [ -z "${STORAGE_ACCOUNT}" ]; then
        echo "  Storage account with name $1 could not be found. Creating new storage account.."
        ${AZ_CLI} storage account create --name $1 --resource-group $2 --sku "Standard_ZRS" --encryption-services "blob" 1> /dev/null
	${AZ_CLI} storage account blob-service-properties update --resource-group $2 --account-name $1 --enable-versioning true --enable-delete-retention true -delete-retention-days 7 --enable-container-delete-retention true --container-delete-retention-days 7
    else
        echo "  Using existing storage account..."
    fi
    echo ""
}

function check_or_create_blob_container() {
    # 1=name
    # 2=storage account name
    # 3=storage account key
    echo "Checking if blob container $1 for storage account $2 already exist"
    CONTAINER=`${AZ_CLI} storage container show --name $1 --account-name $2 --account-key $3 2>/dev/null`
    if [ -z "${CONTAINER}" ]; then
        echo "  Blob container with name $1 could not be found. Creating new container.."
        ${AZ_CLI} storage container create --name $1 --account-name $2 --account-key $3 1> /dev/null
    else
        echo "  Using existing container..."
    fi
    echo ""
}
