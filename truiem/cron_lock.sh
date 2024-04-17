#!/bin/bash

operation="$1"
database_name="$2"
func_name="$3"
extra_args="$4"

# Paths to lock files
LOCK_FILE="/tmp/${operation}_${database_name}_${func_name}.lock"

# Function to refresh a materialized view
refresh_view() {
  local database_name="$1"
  local view_name="$2"
  local lock_file="$3"
  local concurrently="$4"

  # Check if lock file exists
  if [ -f "$lock_file" ]; then
    logger -s -t cron_lock.sh "Previous job for $database_name $view_name is still running. Exiting..."
    exit 1
  fi

  # Create a lock file
  touch "$lock_file"

  # Refresh the materialized view
  if [ "$concurrently" == "--concurrently" ]; then
    psql -d "$database_name" -c "REFRESH MATERIALIZED VIEW CONCURRENTLY $view_name"
  else
    psql -d "$database_name" -c "REFRESH MATERIALIZED VIEW $view_name"
  fi

  # Remove the lock file
  rm -f "$lock_file"
}

# Function to call a procedure
run_procedure() {
  local database_name="$1"
  local func_name="$2"
  local lock_file="$3"
  local extra_args="$4"

  # Check if lock file exists
  if [ -f "$lock_file" ]; then
    logger -s -t cron_lock.sh "Previous job for $database_name $func_name is still running. Exiting..."
    exit 1
  fi

  # Create a lock file
  touch "$lock_file"
  # Call the procedure
  psql -d "$database_name" -c "CALL $func_name(${extra_args})"
  # Remove the lock file
  rm -f "$lock_file"
}

# Check operation flag and call the appropriate function
if [ "$operation" == "view" ]; then
  refresh_view "${database_name}" "${func_name}" "$LOCK_FILE" "${extra_args}"
elif [ "$operation" == "procedure" ]; then
  run_procedure "${database_name}" "${func_name}" "$LOCK_FILE" "${extra_args}"
else
  logger -s -t cron_lock.sh "Invalid operation: $operation. Please specify 'view' or 'procedure'."
  exit 1
fi
