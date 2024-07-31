#!/bin/bash

while true; do
    clear

    # Command to get the stats
    output=$(/usr/bin/ton/validator-engine-console/validator-engine-console -k /var/ton-work/db/client -p /var/ton-work/db/server.pub -a 127.0.0.1:43678 -v 1 -c getstats)

    # Extract unixtime and masterchainblocktime
    unixtime=$(echo "$output" | grep -oP 'unixtime\s+\K\d+')
    masterchainblocktime=$(echo "$output" | grep -oP 'masterchainblocktime\s+\K\d+')

    # Convert to UTC+8 and format
    converted_unixtime=$(date -d @$unixtime -u "+%Y-%m-%d %H:%M:%S UTC+8")
    converted_masterchainblocktime=$(date -d @$masterchainblocktime -u "+%Y-%m-%d %H:%M:%S UTC+8")

    # Calculate the difference in seconds
    time_difference=$((unixtime - masterchainblocktime))
    masterchain=$(echo "$output" | grep -oP '\bmasterchainblock\s+\(-\d+,\d+,\K\d+')

    # Display the results
    echo "Unixtime (UTC+8): $converted_unixtime"
    echo "Masterchainblocktime (UTC+8): $converted_masterchainblocktime"
    echo "Current Block: $masterchain"
    echo "剩下秒數: $time_difference" 秒

    # Refresh interval (e.g., 5 seconds)
    sleep 1
done