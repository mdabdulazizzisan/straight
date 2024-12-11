#!/bin/bash

# Package manager operations and utilities

# Queue for packages that couldn't be installed with primary package manager
WAITING_QUEUE=()

# Function to install package using APT
install_with_apt() {
    local package_name=$1
    echo "Installing $package_name using APT..."
    sudo apt-get update -qq
    sudo apt-get install -y "$package_name"
    return $?
}

# Function to install package using DNF
install_with_dnf() {
    local package_name=$1
    echo "Installing $package_name using DNF..."
    sudo dnf install -y "$package_name"
    return $?
}

# Function to install package using YUM
install_with_yum() {
    local package_name=$1
    echo "Installing $package_name using YUM..."
    sudo yum install -y "$package_name"
    return $?
}

# Function to install package using Pacman
install_with_pacman() {
    local package_name=$1
    echo "Installing $package_name using Pacman..."
    sudo pacman -S --noconfirm "$package_name"
    return $?
}

# Function to install package using Zypper
install_with_zypper() {
    local package_name=$1
    echo "Installing $package_name using Zypper..."
    sudo zypper install -y "$package_name"
    return $?
}

# Function to install package using Flatpak
install_with_flatpak() {
    local package_name=$1
    echo "Installing $package_name using Flatpak..."
    flatpak install -y "$package_name"
    return $?
}

# Function to install package using Snap
install_with_snap() {
    local package_name=$1
    echo "Installing $package_name using Snap..."
    sudo snap install "$package_name"
    return $?
}

# Function to add package to waiting queue
add_to_waiting_queue() {
    local package_name=$1
    local package_manager=$2
    WAITING_QUEUE+=("$package_name:$package_manager")
    echo "Added $package_name to waiting queue (requires $package_manager)"
}

# Function to process waiting queue
process_waiting_queue() {
    if [ ${#WAITING_QUEUE[@]} -eq 0 ]; then
        return 0
    fi

    echo "Processing waiting queue..."
    echo "The following packages require additional package managers:"
    
    # Display all queued packages
    for item in "${WAITING_QUEUE[@]}"; do
        local package_name=$(echo "$item" | cut -d':' -f1)
        local required_pm=$(echo "$item" | cut -d':' -f2)
        echo "- $package_name (requires $required_pm)"
    done

    # Ask user if they want to install required package managers
    read -p "Would you like to install the required package managers? (y/n) " answer
    if [[ $answer =~ ^[Yy]$ ]]; then
        install_required_package_managers
        install_queued_packages
    else
        echo "Skipping queued packages."
    fi
}

# Function to install required package managers
install_required_package_managers() {
    local required_pms=()
    
    # Get unique package managers from waiting queue
    for item in "${WAITING_QUEUE[@]}"; do
        local pm=$(echo "$item" | cut -d':' -f2)
        if [[ ! " ${required_pms[@]} " =~ " ${pm} " ]]; then
            required_pms+=("$pm")
        fi
    done

    # Install each required package manager
    for pm in "${required_pms[@]}"; do
        case $PACKAGE_MANAGER in
            "apt")
                case $pm in
                    "flatpak")
                        sudo apt-get install -y flatpak
                        ;;
                    "snap")
                        sudo apt-get install -y snapd
                        ;;
                esac
                ;;
            "dnf"|"yum")
                case $pm in
                    "flatpak")
                        sudo dnf install -y flatpak
                        ;;
                    "snap")
                        sudo dnf install -y snapd
                        ;;
                esac
                ;;
            "pacman")
                case $pm in
                    "flatpak")
                        sudo pacman -S --noconfirm flatpak
                        ;;
                    "snap")
                        # For Arch, snap needs to be installed from AUR
                        echo "Please install snap from AUR manually"
                        ;;
                esac
                ;;
        esac
    done
}

# Function to install queued packages
install_queued_packages() {
    for item in "${WAITING_QUEUE[@]}"; do
        local package_name=$(echo "$item" | cut -d':' -f1)
        local pm=$(echo "$item" | cut -d':' -f2)
        
        case $pm in
            "flatpak")
                install_with_flatpak "$package_name"
                ;;
            "snap")
                install_with_snap "$package_name"
                ;;
        esac
    done
    
    # Clear the queue after processing
    WAITING_QUEUE=()
} 