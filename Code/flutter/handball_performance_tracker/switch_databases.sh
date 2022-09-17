#!/bin/bash

# take argument -d <<live>> or -d <<dev>>
while getopts "d:" arg; do
  case $arg in
    d) Database=$OPTARG;;
  esac
done

if [ "$Database" == "dev" ]; then
    echo "Switching to dev"
    # firebase commands
    firebase use dev 
    flutterfire configure --project handball-tracker-dev -y
    # replace database name in main.dart
    sed -i 's/handball-performance-tracker/handball-tracker-dev/' lib/main.dart
    echo "Switched to dev"
elif [ "$Database" == "live" ]; then
    echo "Switching to live"
    # firebase command
    firebase use live
    flutterfire configure --project handball-performance-tracker -y
    # replace database name in main.dart
    sed -i 's/handball-tracker-dev/handball-performance-tracker/' lib/main.dart
    echo "Switched to live"
else
  echo "Invalid database"
fi
