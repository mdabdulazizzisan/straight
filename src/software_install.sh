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
    
    # Check if software is supported
    if ! is_software_supported "$normalized_name"; then
        echo "Error: $software is not supported"
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

# Function to check if software is supported
is_software_supported() {
    local normalized_name=$1
    # Check if package map variable exists
    if [ -n "$(declare -p "PACKAGE_MAP_${normalized_name}" 2>/dev/null)" ]; then
        return 0
    fi
    return 1
}

# Function to list all supported software
list_supported_software() {
    echo "Supported Software:"
    echo "=================="
    # This will be populated from package_names.sh
    for var in $(compgen -A variable | grep ^PACKAGE_MAP_); do
        local software_name=${var#PACKAGE_MAP_}
        echo "- $software_name"
    done
} 