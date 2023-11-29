#!/bin/bash

# ~/.my.cnf configuration file can be set like:
# [client]
# user=username
# password=password

# Set the database names to be deleted and recreated
DATABASES=("test" "test1" "test2" "test3" "test4")

# SQL query that will drop and recreate each database
SQL_QUERY=""

# Generate the SQL query
for DB in "${DATABASES[@]}"; do
    SQL_QUERY+="DROP DATABASE IF EXISTS \`${DB}\`; CREATE DATABASE \`${DB}\`;"
done

# Execute the SQL query
if mysql -e "$SQL_QUERY"; then
  echo "Databases have been dropped and recreated successfully."
else
  echo "An error occurred while processing databases." >&2
  exit 1
fi