#!/bin/ash

# Define the target hosts to ping
target1="104.18.214.235"
target2="ava.game.naver.com"
target3="104.17.3.81"

# Define the interval between pings in seconds
interval=1

# Consecutive failed
consecutive_failed=3

# Initialize variables to count consecutive failed pings for each target
failed_count_target1=0
failed_count_target2=0
failed_count_target3=0

# Loop indefinitely
while :
do
    # Get current date and time
    current_time=$(date "+%Y-%m-%d %H:%M:%S")

    # Get IP address obtained by usb0 interface
    usb0_ip=$(ip -4 addr show usb0 | awk '/inet / {print $2}' | cut -d "/" -f 1)

    if [ -z "$usb0_ip" ]; then
        echo "$current_time - USB0 IP not available. Checking again..."
    else
        all_failed=1

        # Perform ping for target 1
        ping_result=$(ping -c 1 -W 1 $target1 2>/dev/null)
        if [ $? -eq 0 ]; then
            response_time=$(echo "$ping_result" | awk -F'=' '/time=/ {print $4}' | cut -d " " -f 1)
            echo "$current_time - USB0 IP: $usb0_ip: Ping to $target1 OK (Response time: $response_time ms)"
            failed_count_target1=0
            all_failed=0
        else
            echo "$current_time - USB0 IP: $usb0_ip: Ping to $target1 failed"
            failed_count_target1=$((failed_count_target1 + 1))
        fi

        # Perform ping for target 2
        ping_result=$(ping -c 1 -W 1 $target2 2>/dev/null)
        if [ $? -eq 0 ]; then
            response_time=$(echo "$ping_result" | awk -F'=' '/time=/ {print $4}' | cut -d " " -f 1)
            echo "$current_time - USB0 IP: $usb0_ip: Ping to $target2 OK (Response time: $response_time ms)"
            failed_count_target2=0
            all_failed=0
        else
            echo "$current_time - USB0 IP: $usb0_ip: Ping to $target2 failed"
            failed_count_target2=$((failed_count_target2 + 1))
        fi

        # Perform ping for target 3
        ping_result=$(ping -c 1 -W 1 $target3 2>/dev/null)
        if [ $? -eq 0 ]; then
            response_time=$(echo "$ping_result" | awk -F'=' '/time=/ {print $4}' | cut -d " " -f 1)
            echo "$current_time - USB0 IP: $usb0_ip: Ping to $target3 OK (Response time: $response_time ms)"
            failed_count_target3=0
            all_failed=0
        else
            echo "$current_time - USB0 IP: $usb0_ip: Ping to $target3 failed"
            failed_count_target3=$((failed_count_target3 + 1))
        fi

        # Check if all targets encountered consecutive failed pings
        if [ $all_failed -eq 1 ] && [ $failed_count_target1 -ge $consecutive_failed ] && [ $failed_count_target2 -ge $consecutive_failed ] && [ $failed_count_target3 -ge $consecutive_failed ]; then
            echo "$current_time - USB0 IP: $usb0_ip: All targets encountered $consecutive_failed consecutive failed pings. Running activate_airplane.sh..."
            /root/activate_airplane.sh && echo "$current_time - USB0 IP: $usb0_ip: activate_airplane.sh executed successfully" || echo "$current_time - USB0 IP: $usb0_ip: activate_airplane.sh execution failed"
            echo "$current_time - USB0 IP: $usb0_ip: Waiting for USB0 IP before resuming pinging..."
            failed_count_target1=0
            failed_count_target2=0
            failed_count_target3=0
        fi
    fi

    # Wait for the specified interval before pinging again
    sleep $interval
done
