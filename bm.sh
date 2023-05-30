#!/bin/bash

# Backup Manager Script

show_help() {
  echo "Backup Manager - Help"
  echo "Usage: bm [options]"
  echo "Options:"
  echo "  --schedule|-s {crontab_format} {src_path} {des_path}  Setup a new backup"
  echo "  --list                  Show list of configured backups"
  echo "  --older-than {time_period} --housekeeping {backup_id}  Delete backups older than given period"
  echo "  --help|-h               Show help"
}

backup_dir="/var/backups"



function setup_backup() {
  local crontab_format=$1
  local src_path=$2
  local des_path=$3

  # Validate source and destination paths
  if [ ! -d "$src_path" ]; then
    echo "Error: Source path '$src_path' does not exist."
    exit 1
  fi

  # Create backup directory if it doesn't exist
  if [ ! -d "$backup_dir" ]; then
    mkdir -p "$backup_dir"
  fi

  # Add cron job to schedule the backup
  (crontab -l 2>/dev/null; echo "$crontab_format cp -r $src_path $backup_dir/$des_path") | crontab -

  echo "Backup scheduled successfully!"
}

function list-backups(){
  echo "List of configured backups:"
  crontab -l | grep -v '^#' | grep -o 'cp -r .*' | awk '{print $3}' 
}

function delete_old_backups(){
  local time_period = $1
  local backup_id = $2
  
  local cutoff_date=$(date -d "$time_period ago" +"%Y-%m-%d")
  find "$backup_dir" -maxdepth 1 -name  "$backup_id*" -type d -not -newermt "$cutoff_date" -exec rm -r {} \;

  echo "Old backups deleted successfully!"
}

function delete_old_backups() {
  local time_period=$1
  local backup_id=$2

  # Calculate the cutoff date
  local cutoff_date=$(date -d "$time_period ago" +'%Y-%m-%d')

  # Delete backups older than the cutoff date
  find "$backup_dir" -maxdepth 1 -name "$backup_id*" -type d -not -newermt "$cutoff_date" -exec rm -r {} \;

  echo "Old backups deleted successfully!"
}

    

# Parse command line arguments
while [[ $# -gt 0 ]]; do
  case "$1" in
    --schedule|-s)
      crontab_format="$2"
      src_path="$3"
      des_path="$4"
      setup_backup "$crontab_format" "$src_path" "$des_path"
      exit 0
      ;;
    --list)
      list_backups
      exit 0
      ;;
    --older-than)
      time_period="$2"
      backup_id="$4"
      delete_old_backups "$time_period" "$backup_id"
      exit 0
      ;;
    --help|-h)
      show_help
      exit 0
      ;;
    *)
      echo "Invalid argument: $1"
      show_help
      exit 1
      ;;
  esac
done

show_help

