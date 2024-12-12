#!/bin/bash

# straight.sh - A cross-distribution package installer for Linux
# Author: [Md Abdul Aziz Zisan, Fahim Faisal Talha, Md Nafiul Islam]
# Version: 1.0.0

# Source all utility functions
source ./src/distro_detect.sh
source ./src/package_managers.sh
source ./src/software_install.sh
source ./utils/logger.sh
source ./utils/helpers.sh

# Print banner and usage information
print_banner() {
    echo "================================================"
    echo "           STRAIGHT PACKAGE INSTALLER            "
    echo "================================================"
    echo "A cross-distribution package installer for Linux"
    echo ""
}

print_usage() {
    echo "Usage: $0 [software_names...]"
    echo "Example: $0 libreoffice gparted wine"
    echo ""
    echo "For a list of available software, use: $0 --list"
    echo "For help, use: $0 --help"
}

print_help() {
    print_banner
    echo "Usage: $0 [OPTIONS] [software_names...]"
    echo ""
    echo "Options:"
    echo "  --help     Show this help message"
    echo "  --list     List all available software"
    echo ""
    echo "Examples:"
    echo "  $0 firefox vlc gimp        # Install multiple applications"
    echo "  $0 --list                  # Show available software"
    echo ""
    echo "Supported package managers:"
    echo "  - apt (Debian/Ubuntu)"
    echo "  - dnf (Fedora)"
    echo "  - pacman (Arch Linux)"
    echo "  - zypper (OpenSUSE)"
    echo "  - flatpak"
    echo "  - snap"
    echo ""
    echo "For more information, visit: https://github.com/yourusername/straight"
}

# Main execution starts here
main() {
    # Check if no arguments provided
    if [ $# -eq 0 ]; then
        print_banner
        print_usage
        exit 1
    fi

    # Handle command line arguments
    case "$1" in
        --help)
            print_help
            exit 0
            ;;
        --list)
            print_banner
            list_supported_software
            exit 0
            ;;
    esac

    # Initialize logging
    init_logger

    # Detect Linux distribution and package manager
    detect_distro
    print_system_info

    # Process each software argument
    for software in "$@"; do
        install_software "$software"
    done

    # Process waiting queue if any
    process_waiting_queue
}

# Call main function with all script arguments
main "$@" 