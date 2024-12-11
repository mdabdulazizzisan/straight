#!/bin/bash

# straight.sh - A cross-distribution package installer for Linux
# Author: [Your Name]
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

# Main execution starts here
main() {
    # Check if no arguments provided
    if [ $# -eq 0 ]; then
        print_banner
        print_usage
        exit 1
    fi

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