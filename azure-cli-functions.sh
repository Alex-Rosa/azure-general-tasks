#!/bin/bash

# Example usage in bash terminal:
# source azure-cli-functions.sh
# or
# . azure-cli-functions.sh
# then call the function az_login (or other functions defined in this script)

# Function to log in to Azure using the Azure CLI
az_login() {
  echo "Logging in to Azure..."  # Inform the user that login is starting
  az login                      # Run the Azure CLI login command (opens browser for authentication)
  if [ $? -eq 0 ]; then         # $? holds the exit status of the previous command (0 means success, non-zero means failure)
    echo "Azure login successful."  # Success message
  else
    echo "Azure login failed." >&2  # Error message to stderr if login failed
    exit 1                          # Exit the script with error code 1
  fi
}

# Function to connect to Azure SQL Database using Entra ID (Azure AD) authentication
az_sql_entraconnect() {
  # Usage: az_sql_entraconnect <server-name> <database-name> <user@domain.com>
  local server_name="$1"      # Azure SQL server name (without .database.windows.net)
  local database_name="$2"    # Azure SQL database name
  local user_name="$3"        # Entra ID (Azure AD) user (e.g., user@domain.com)

  if [[ -z "$server_name" || -z "$database_name" || -z "$user_name" ]]; then
    echo "Usage: az_sql_entraconnect <server-name> <database-name> <user@domain.com>"
    return 1
  fi

  echo "Connecting to Azure SQL Database '$database_name' on server '$server_name' as Entra ID user '$user_name'..."
  az sql db connect \
    --server "$server_name" \
    --database "$database_name" \
    --auth-type aad-password \
    --user "$user_name"
}
# Example usage:
# az_login  # Call the function to log in to Azure
# az_sql_entraconnect myserver mydatabase user@domain.com


# Function to connect to Azure PostgreSQL using Entra ID (Azure AD) authentication
az_postgres_entraconnect() {
  # Usage: az_postgres_entraconnect <server-name> <database-name> <user@domain.com>
  local server_name="$1"      # Azure PostgreSQL server name (without .postgres.database.azure.com)
  local database_name="$2"    # Azure PostgreSQL database name
  local user_name="$3"        # Entra ID (Azure AD) user (e.g., user@domain.com)

  if [[ -z "$server_name" || -z "$database_name" || -z "$user_name" ]]; then
    echo "Usage: az_postgres_entraconnect <server-name> <database-name> <user@domain.com>"
    return 1
  fi

  echo "Connecting to Azure PostgreSQL database '$database_name' on server '$server_name' as Entra ID user '$user_name'..."
  az postgres flexible-server connect \
    --name "$server_name" \
    --database-name "$database_name" \
    --auth aad \
    --user "$user_name"
}
# Example usage:
# az_login  # Call the function to log in to Azure
# az_postgres_entraconnect mypgserver mypgdb user@domain.com