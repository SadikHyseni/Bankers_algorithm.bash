#!/bin/bash
#bankers algorith deadlock

# Function to check if the system is in a safe state
function is_safe_state {
    # Copy available resources to a work array
    local work=("${available[@]}")
    local finish=()

    # Initialize finish array
    for ((i = 0; i < $num_processes; i++)); do
        finish[$i]=false
    done

    local count=0
    while ((count < $num_processes)); do
        local found=false

        # Iterate through processes
        for ((i = 0; i < $num_processes; i++)); do
            if [[ ${finish[$i]} == false ]]; then
                local j

                # Check if resources for the process are available
                for ((j = 0; j < $num_resources; j++)); do
                    if (( ${need[$i,$j]} <= ${work[$j]} )); then
                        continue
                    else
                        break
                    fi
                done

                # If resources are available, mark the process as finished
                if ((j == $num_resources)); then
                    # Process can complete
                    for ((j = 0; j < $num_resources; j++)); do
                        work[$j]=$(( ${work[$j]} + ${allocation[$i,$j]} ))
                    done
                    finish[$i]=true
                    found=true
                    ((count++))
                fi
            fi
        done

        # If no process can complete, the system is not in a safe state
        if [[ $found == false ]]; then
            echo "System is not in a safe state."
            exit 1
        fi
    done

    echo "System is in a safe state."
}

# Function to simulate a resource request
function simulate_request {
    local process=$1
    local request=("${@:2}")

    # Check if the request is valid
    for ((i = 0; i < $num_resources; i++)); do
        if ((request[$i] > ${need[$process,$i]} || request[$i] > ${available[$i]})); then
            echo "Invalid request. Request exceeds maximum or available resources."
            exit 1
        fi
    done

    # Temporarily allocate resources and check if the system remains in a safe state
    for ((i = 0; i < $num_resources; i++)); do
        allocation[$process,$i]=$(( ${allocation[$process,$i]} + ${request[$i]} ))
        need[$process,$i]=$(( ${need[$process,$i]} - ${request[$i]} ))
        available[$i]=$(( ${available[$i]} - ${request[$i]} ))
    done

    # Check if the system is still in a safe state after the allocation
    is_safe_state

    # If safe, grant the request
    for ((i = 0; i < $num_resources; i++)); do
        allocation[$process,$i]=$(( ${allocation[$process,$i]} - ${request[$i]} ))
        need[$process,$i]=$(( ${need[$process,$i]} + ${request[$i]} ))
        available[$i]=$(( ${available[$i]} + ${request[$i]} ))
    done

    echo "Request can be granted. System remains in a safe state."
}

# Input
read -p "Enter the number of processes: " num_processes
read -p "Enter the number of resources: " num_resources

# Initialize matrices
declare -A max
declare -A allocation
declare -A need

# Input allocation matrix
echo "Enter the allocation matrix:"
for ((i = 0; i < $num_processes; i++)); do
    for ((j = 0; j < $num_resources; j++)); do
        read -p "Allocation[$i,$j]: " allocation[$i,$j]
    done
done

# Input max matrix
echo "Enter the max matrix:"
for ((i = 0; i < $num_processes; i++)); do
    for ((j = 0; j < $num_resources; j++)); do
        read -p "Max[$i,$j]: " max[$i,$j]
        need[$i,$j]=$(( ${max[$i,$j]} - ${allocation[$i,$j]} ))
    done
done

# Input available resources
echo "Enter the available resources:"
for ((i = 0; i < $num_resources; i++)); do
    read -p "Available[$i]: " available[$i]
done

# Check if the system is in a safe state
is_safe_state

# Simulate a resource request
read -p "Enter the process making the request: " requesting_process
read -a request_array -p "Enter the resource request: "
simulate_request $requesting_process "${request_array[@]}"

