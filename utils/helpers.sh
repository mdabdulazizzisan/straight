#!/bin/bash

# Helper functions for the Straight package installer

# Check if running with sudo/root privileges
check_root() {
    if [ "$EUID" -ne 0 ]; then
        log_error "This script must be run as root or with sudo"
        return 1
    fi
    return 0
}

# Check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check if a package is installed (generic)
is_package_installed() {
    local package=$1
    
    case $PACKAGE_MANAGER in
        "apt")
            dpkg -l "$package" >/dev/null 2>&1
            ;;
        "dnf"|"yum")
            rpm -q "$package" >/dev/null 2>&1
            ;;
        "pacman")
            pacman -Qi "$package" >/dev/null 2>&1
            ;;
        "zypper")
            rpm -q "$package" >/dev/null 2>&1
            ;;
        *)
            log_error "Unknown package manager: $PACKAGE_MANAGER"
            return 2
            ;;
    esac
    return $?
}

# Check if flatpak package is installed
is_flatpak_installed() {
    local package=$1
    flatpak list | grep -q "^$package"
    return $?
}

# Check if snap package is installed
is_snap_installed() {
    local package=$1
    snap list | grep -q "^$package"
    return $?
}

# Print a spinner while a command is running
show_spinner() {
    local pid=$1
    local delay=0.1
    local spinstr='|/-\'
    
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        local temp=${spinstr#?}
        printf " [%c]  " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    printf "    \b\b\b\b"
}

# Print progress bar
print_progress() {
    local current=$1
    local total=$2
    local width=50
    local percentage=$((current * 100 / total))
    local completed=$((width * current / total))
    local remaining=$((width - completed))
    
    printf "\rProgress: ["
    printf "%${completed}s" | tr ' ' '#'
    printf "%${remaining}s" | tr ' ' '-'
    printf "] %d%%" $percentage
}

# Convert size in bytes to human readable format
human_readable_size() {
    local size=$1
    local units=('B' 'KB' 'MB' 'GB' 'TB')
    local unit_index=0
    
    while [ $size -ge 1024 ] && [ $unit_index -lt 4 ]; do
        size=$((size / 1024))
        unit_index=$((unit_index + 1))
    done
    
    echo "$size${units[$unit_index]}"
}

# Check internet connectivity
check_internet() {
    if ping -c 1 8.8.8.8 >/dev/null 2>&1; then
        return 0
    else
        log_error "No internet connection available"
        return 1
    fi
}

# Create temporary directory
create_temp_dir() {
    local temp_dir=$(mktemp -d)
    if [ ! -d "$temp_dir" ]; then
        log_error "Failed to create temporary directory"
        return 1
    fi
    echo "$temp_dir"
}

# Clean up temporary directory
cleanup_temp_dir() {
    local temp_dir=$1
    if [ -d "$temp_dir" ]; then
        rm -rf "$temp_dir"
    fi
}

# Get system memory info in MB
get_system_memory() {
    local mem_total=$(free -m | awk '/^Mem:/{print $2}')
    echo "$mem_total"
}

# Get available disk space in MB
get_available_disk_space() {
    local mount_point=${1:-"/"}
    local space=$(df -m "$mount_point" | awk 'NR==2 {print $4}')
    echo "$space"
}

# Check if system has enough resources for installation
check_system_resources() {
    local required_mem=$1  # in MB
    local required_space=$2  # in MB
    
    local available_mem=$(get_system_memory)
    local available_space=$(get_available_disk_space)
    
    if [ "$available_mem" -lt "$required_mem" ]; then
        log_error "Insufficient memory. Required: ${required_mem}MB, Available: ${available_mem}MB"
        return 1
    fi
    
    if [ "$available_space" -lt "$required_space" ]; then
        log_error "Insufficient disk space. Required: ${required_space}MB, Available: ${available_space}MB"
        return 1
    fi
    
    return 0
}

# Backup a file before modifying it
backup_file() {
    local file=$1
    local backup="${file}.bak"
    
    if [ -f "$file" ]; then
        cp "$file" "$backup"
        log_info "Created backup: $backup"
        return 0
    else
        log_error "File not found: $file"
        return 1
    fi
}

# Restore a backup file
restore_backup() {
    local file=$1
    local backup="${file}.bak"
    
    if [ -f "$backup" ]; then
        mv "$backup" "$file"
        log_info "Restored backup: $file"
        return 0
    else
        log_error "Backup not found: $backup"
        return 1
    fi
} 