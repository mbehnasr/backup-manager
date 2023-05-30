#!/bin/bash

# Backup Manager Script

show_help() {
  echo "Usage: ./backup_manager.sh [options]"
  echo "Options:"
  echo "  --schedule|-s {crontab_format} {src_path} {des_path}  Setup a new backup"
  echo "  --older-than {time_period} --housekeeping {backup_id}  Delete backups older than given period"
  echo "  --help|-h  Show help"
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
  case "$1" in
    --schedule|-s)
      crontab_format="$2"
      source_dir="$3"
      destination_dir="$4"
      shift 4
      ;;
    --older-than)
      time_period="$2"
      backup_id="$4"
      shift 4
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

# Rest of the script...



#!/bin/bash

# Backup Manager Script

# Parse command line arguments
while [[ $# -gt 0 ]]; do
  case "$1" in
    --schedule|-s)
      crontab_format="$2"
      shift 2
      ;;
    *)
      echo "Invalid argument: $1"
      exit 1
      ;;
  esac
done

# Validate and set up the backup schedule using crontab
if [[ -n $crontab_format ]]; then
  # Get the script's absolute path
  script_path=$(readlink -f "$0")

  # Generate the command to execute the script with the backup parameters
  command_to_execute="/bin/bash $script_path --backup"

  # Add the command to crontab
  (crontab -l 2>/dev/null; echo "$crontab_format $command_to_execute") | crontab -
  echo "Backup scheduled with crontab format: $crontab_format"
  exit 0
fi

# Perform the backup operation
if [[ $1 == "--backup" ]]; then
  # Set the source and destination directories
  source_dir="$2"
  backup_dir="$3"

  # Create a backup directory with current timestamp
  timestamp=$(date +%Y-%m-%d_%H-%M-%S)
  backup_path="${backup_dir}/backup_${timestamp}"
  mkdir -p "$backup_path"

  # Copy files from source to backup directory
  cp -R "$source_dir" "$backup_path"

  # Display success message
  echo "Backup created successfully at: $backup_path"
  exit 0
fi

echo "Invalid or missing options. Please use --schedule|-s to set up a backup schedule."
exit 1

