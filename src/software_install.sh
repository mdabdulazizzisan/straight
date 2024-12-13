#!/bin/bash

# Software installation and package mapping utilities

# Load software package mappings
source ./data/package_names.sh

# Function to normalize software name
normalize_software_name() {
    local input=$1
    # Convert to lowercase and remove special characters
    echo "$input" | tr '[:upper:]' '[:lower:]' | tr -d '[:punct:]' | tr -d ' '
}

# Function to get package name for current distribution
get_package_name() {
    local software=$1
    local normalized_name=$(normalize_software_name "$software")
    
    # Get the package mapping array for this software
    local -n package_map="PACKAGE_MAP_${normalized_name}"
    
    # Try to get package name for primary package manager
    if [ -n "${package_map[$PACKAGE_MANAGER]}" ]; then
        echo "${package_map[$PACKAGE_MANAGER]}"
        return 0
    fi
    
    # Try Flatpak if available
    if [[ " ${AVAILABLE_PACKAGE_MANAGERS[@]} " =~ " flatpak " ]] && [ -n "${package_map[flatpak]}" ]; then
        echo "${package_map[flatpak]}"
        return 0
    fi
    
    # Try Snap if available
    if [[ " ${AVAILABLE_PACKAGE_MANAGERS[@]} " =~ " snap " ]] && [ -n "${package_map[snap]}" ]; then
        echo "${package_map[snap]}"
        return 0
    fi
    
    return 1
}

# Function to get preferred package manager for software
get_preferred_package_manager() {
    local software=$1
    local normalized_name=$(normalize_software_name "$software")
    
    # Get the package mapping array for this software
    local -n package_map="PACKAGE_MAP_${normalized_name}"
    
    # Check primary package manager first
    if [ -n "${package_map[$PACKAGE_MANAGER]}" ]; then
        echo "$PACKAGE_MANAGER"
        return 0
    fi
    
    # Check Flatpak
    if [ -n "${package_map[flatpak]}" ]; then
        echo "flatpak"
        return 0
    fi
    
    # Check Snap
    if [ -n "${package_map[snap]}" ]; then
        echo "snap"
        return 0
    fi
    
    return 1
}

# Function to install software
install_software() {
    local software=$1
    local normalized_name=$(normalize_software_name "$software")
    
    echo "Processing installation request for $software..."
    
    # Check if software is supported using binary search
    if ! is_software_supported "$normalized_name"; then
        echo "Error: $software is not supported"
        suggest_similar_software "$normalized_name"
        return 1
    fi
    
    # Get package name and preferred package manager
    local package_name=$(get_package_name "$software")
    local preferred_pm=$(get_preferred_package_manager "$software")
    
    if [ -z "$package_name" ] || [ -z "$preferred_pm" ]; then
        echo "Error: Could not find package information for $software"
        return 1
    fi
    
    # Install based on package manager
    case $preferred_pm in
        "apt")
            install_with_apt "$package_name"
            ;;
        "dnf")
            install_with_dnf "$package_name"
            ;;
        "yum")
            install_with_yum "$package_name"
            ;;
        "pacman")
            install_with_pacman "$package_name"
            ;;
        "zypper")
            install_with_zypper "$package_name"
            ;;
        "flatpak")
            if [[ " ${AVAILABLE_PACKAGE_MANAGERS[@]} " =~ " flatpak " ]]; then
                install_with_flatpak "$package_name"
            else
                add_to_waiting_queue "$package_name" "flatpak"
            fi
            ;;
        "snap")
            if [[ " ${AVAILABLE_PACKAGE_MANAGERS[@]} " =~ " snap " ]]; then
                install_with_snap "$package_name"
            else
                add_to_waiting_queue "$package_name" "snap"
            fi
            ;;
        *)
            echo "Error: Unsupported package manager $preferred_pm"
            return 1
            ;;
    esac
}

# Function to check if software is supported using binary search
is_software_supported() {
    local normalized_name=$1
    if binary_search_software "$normalized_name"; then
        return 0
    fi
    return 1
}

# Function to list all supported software with bubble sort
list_supported_software() {
    echo "Supported Software:"
    echo "=================="
    
    # Create an array to store software names
    local software_names=()
    
    # Collect all software names
    for var in $(compgen -A variable | grep ^PACKAGE_MAP_); do
        local name=${var#PACKAGE_MAP_}
        software_names+=("$name")
    done
    
    # Bubble Sort implementation
    local n=${#software_names[@]}
    for ((i = 0; i < n - 1; i++)); do
        for ((j = 0; j < n - i - 1; j++)); do
            # Compare adjacent elements
            if [[ "${software_names[j]}" > "${software_names[j+1]}" ]]; then
                # Swap them if they are in wrong order
                local temp=${software_names[j]}
                software_names[j]=${software_names[j+1]}
                software_names[j+1]=$temp
            fi
        done
    done
    
    # Print sorted software names
    for name in "${software_names[@]}"; do
        echo "- $name"
    done
}

# Binary Search implementation for software support check
binary_search_software() {
    local search_name=$1
    local software_names=()
    
    # Collect and sort software names
    for var in $(compgen -A variable | grep ^PACKAGE_MAP_); do
        local name=${var#PACKAGE_MAP_}
        software_names+=("$name")
    done
    
    # Sort the array (required for binary search)
    IFS=$'\n' sorted_names=($(sort <<<"${software_names[*]}"))
    unset IFS
    
    # Binary Search
    local left=0
    local right=$((${#sorted_names[@]} - 1))
    
    while [ $left -le $right ]; do
        local mid=$(( (left + right) / 2 ))
        
        if [ "${sorted_names[mid]}" = "$search_name" ]; then
            return 0  # Found
        elif [[ "${sorted_names[mid]}" < "$search_name" ]]; then
            left=$((mid + 1))
        else
            right=$((mid - 1))
        fi
    done
    
    return 1  # Not found
}

# Levenshtein Distance implementation for finding similar software names
calculate_levenshtein_distance() {
    local str1=$1
    local str2=$2
    local len1=${#str1}
    local len2=${#str2}
    
    # Create a matrix of zeros
    declare -A matrix
    for ((i = 0; i <= len1; i++)); do
        matrix[$i,0]=$i
    done
    for ((j = 0; j <= len2; j++)); do
        matrix[0,$j]=$j
    done
    
    # Fill the matrix
    for ((i = 1; i <= len1; i++)); do
        for ((j = 1; j <= len2; j++)); do
            if [ "${str1:i-1:1}" = "${str2:j-1:1}" ]; then
                matrix[$i,$j]=${matrix[$((i-1)),$((j-1))]}
            else
                local deletion=$((${matrix[$((i-1)),$j]} + 1))
                local insertion=$((${matrix[$i,$((j-1))]} + 1))
                local substitution=$((${matrix[$((i-1)),$((j-1))]} + 1))
                
                # Find minimum of the three operations
                matrix[$i,$j]=$deletion
                [ $insertion -lt ${matrix[$i,$j]} ] && matrix[$i,$j]=$insertion
                [ $substitution -lt ${matrix[$i,$j]} ] && matrix[$i,$j]=$substitution
            fi
        done
    done
    
    # Return the bottom-right cell of the matrix
    echo ${matrix[$len1,$len2]}
}

# Function to suggest similar software names when a typo is made
suggest_similar_software() {
    local input_name=$1
    local suggestions=()
    local max_suggestions=3
    local max_distance=3
    
    # Get all software names
    local software_names=()
    for var in $(compgen -A variable | grep ^PACKAGE_MAP_); do
        local name=${var#PACKAGE_MAP_}
        software_names+=("$name")
    done
    
    # Calculate distances and store valid suggestions
    declare -A distances
    for name in "${software_names[@]}"; do
        local distance=$(calculate_levenshtein_distance "$input_name" "$name")
        if [ $distance -le $max_distance ]; then
            distances[$name]=$distance
        fi
    done
    
    # Sort suggestions by distance
    IFS=$'\n' sorted_suggestions=($(
        for name in "${!distances[@]}"; do
            echo "${distances[$name]}:$name"
        done | sort -n | head -n $max_suggestions | cut -d':' -f2
    ))
    unset IFS
    
    # Return suggestions if any found
    if [ ${#sorted_suggestions[@]} -gt 0 ]; then
        echo "Did you mean one of these?"
        for suggestion in "${sorted_suggestions[@]}"; do
            echo "  - $suggestion"
        done
    fi
}
  