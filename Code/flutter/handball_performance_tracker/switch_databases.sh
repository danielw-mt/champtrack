#!/usr/bin/env sh

# take argument -d <<live>> or -d <<dev>>
while getopts "d:" arg; do
  case $arg in
    d) Database=$OPTARG;;
  esac
done

if [ "$Database" == "dev" ]; then
    echo "Switching to dev"
    flutter clean
    # firebase commands
    firebase use dev
    # if windows
    if [ "$OSTYPE"  == "msys" ]; then
      flutterfire.bat configure --project handball-tracker-dev -y
    else
      flutterfire configure --project handball-tracker-dev -y
    fi
    # replace database name in main.dart
    sed -i 's/handball-performance-tracker/handball-tracker-dev/' lib/main.dart
    echo "Switched to dev"
elif [ "$Database" == "live" ]; then
    echo "Switching to live"
    flutter clean
    # firebase command
    firebase use live
    # if windows
    if [ "$OSTYPE"  == "msys" ]; then
      flutterfire.bat configure --project handball-performance-tracker -y
    else
      flutterfire configure --project handball-performance-tracker -y
    fi
    # replace database name in main.dart
    sed -i 's/handball-tracker-dev/handball-performance-tracker/' lib/main.dart
    echo "Switched to live"
else
  echo "Invalid database"
fi
