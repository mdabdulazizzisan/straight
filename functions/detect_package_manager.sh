#!/bin/bash

# detect installed package managers

detect_package_managers() {
    echo "Detecting installed package managers..."
    PACKAGE_MANAGERS=()

    # check for apt (Debian/Ubuntu)
    if command -v apt >/dev/null 2>&1; then
        PACKAGE_MANAGERS+=("apt")
    fi

    # check for dnf (Fedora/RHEL)
    if command -v dnf >/dev/null 2>&1; then
        PACKAGE_MANAGERS+=("dnf")
    fi

    # Check for pacman (Arch)
    if command -v pacman >/dev/null 2>&1; then
        PACKAGE_MANAGERS+=("pacman")
    fi

    # Check for flatpak (Cross-platform)
    if command -v flatpak >/dev/null 2>&1; then
        PACKAGE_MANAGERS+=("flatpak")
    fi

    if [ ${#PACKAGE_MANAGERS[@]} -eq 0 ]; then
        echo "No package managers detected! Please install one to proceed."
        exit 1
    else
        echo "Detected package managers: ${PACKAGE_MANAGERS[*]}"
    fi
}
