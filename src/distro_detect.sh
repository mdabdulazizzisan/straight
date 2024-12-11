#!/bin/bash

# Distribution detection and system information gathering script

# Global variables to store system information
DISTRO_NAME=""
DISTRO_VERSION=""
PACKAGE_MANAGER=""
AVAILABLE_PACKAGE_MANAGERS=()

# Function to detect the Linux distribution
detect_distro() {
    # First try to use /etc/os-release file
    if [ -f /etc/os-release ]; then
        # Source the os-release file to get variables
        . /etc/os-release
        DISTRO_NAME=$NAME
        DISTRO_VERSION=$VERSION_ID
    
    # Fallback to legacy methods if os-release doesn't exist
    elif [ -f /etc/lsb-release ]; then
        . /etc/lsb-release
        DISTRO_NAME=$DISTRIB_ID
        DISTRO_VERSION=$DISTRIB_RELEASE
    
    # Try to detect using release files
    elif [ -f /etc/debian_version ]; then
        DISTRO_NAME="Debian"
        DISTRO_VERSION=$(cat /etc/debian_version)
    elif [ -f /etc/redhat-release ]; then
        DISTRO_NAME=$(cat /etc/redhat-release | cut -d' ' -f1)
        DISTRO_VERSION=$(cat /etc/redhat-release | grep -o '[0-9.]*')
    else
        DISTRO_NAME="Unknown"
        DISTRO_VERSION="Unknown"
    fi

    detect_package_managers
}

# Function to detect available package managers
detect_package_managers() {
    # Check for APT (Debian-based)
    if command -v apt-get >/dev/null 2>&1; then
        AVAILABLE_PACKAGE_MANAGERS+=("apt")
        [ -z "$PACKAGE_MANAGER" ] && PACKAGE_MANAGER="apt"
    fi

    # Check for DNF/YUM (RedHat-based)
    if command -v dnf >/dev/null 2>&1; then
        AVAILABLE_PACKAGE_MANAGERS+=("dnf")
        [ -z "$PACKAGE_MANAGER" ] && PACKAGE_MANAGER="dnf"
    elif command -v yum >/dev/null 2>&1; then
        AVAILABLE_PACKAGE_MANAGERS+=("yum")
        [ -z "$PACKAGE_MANAGER" ] && PACKAGE_MANAGER="yum"
    fi

    # Check for Pacman (Arch-based)
    if command -v pacman >/dev/null 2>&1; then
        AVAILABLE_PACKAGE_MANAGERS+=("pacman")
        [ -z "$PACKAGE_MANAGER" ] && PACKAGE_MANAGER="pacman"
    fi

    # Check for Zypper (OpenSUSE)
    if command -v zypper >/dev/null 2>&1; then
        AVAILABLE_PACKAGE_MANAGERS+=("zypper")
        [ -z "$PACKAGE_MANAGER" ] && PACKAGE_MANAGER="zypper"
    fi

    # Check for Flatpak
    if command -v flatpak >/dev/null 2>&1; then
        AVAILABLE_PACKAGE_MANAGERS+=("flatpak")
    fi

    # Check for Snap
    if command -v snap >/dev/null 2>&1; then
        AVAILABLE_PACKAGE_MANAGERS+=("snap")
    fi
}

# Function to print system information
print_system_info() {
    echo "System Information:"
    echo "==================="
    echo "Distribution: $DISTRO_NAME"
    echo "Version: $DISTRO_VERSION"
    echo "Primary Package Manager: $PACKAGE_MANAGER"
    echo "Available Package Managers: ${AVAILABLE_PACKAGE_MANAGERS[*]}"
    echo ""
} 