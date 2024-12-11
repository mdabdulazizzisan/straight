#!/bin/bash

# Logger utility for the Straight package installer

# Log levels
declare -r LOG_LEVEL_ERROR=0
declare -r LOG_LEVEL_WARN=1
declare -r LOG_LEVEL_INFO=2
declare -r LOG_LEVEL_DEBUG=3

# Current log level (default: INFO)
CURRENT_LOG_LEVEL=$LOG_LEVEL_INFO

# Log file path
LOG_FILE="./logs/straight.log"

# Initialize logger
init_logger() {
    # Create logs directory if it doesn't exist
    mkdir -p "$(dirname "$LOG_FILE")"
    
    # Create or clear log file
    echo "=== Straight Package Installer Log ===" > "$LOG_FILE"
    echo "Started at: $(date)" >> "$LOG_FILE"
    echo "===================================" >> "$LOG_FILE"
}

# Internal logging function
_log() {
    local level=$1
    local message=$2
    local level_str=""
    
    # Only log if level is less than or equal to current log level
    if [ "$level" -le "$CURRENT_LOG_LEVEL" ]; then
        # Convert level number to string
        case $level in
            $LOG_LEVEL_ERROR) level_str="ERROR";;
            $LOG_LEVEL_WARN)  level_str="WARN ";;
            $LOG_LEVEL_INFO)  level_str="INFO ";;
            $LOG_LEVEL_DEBUG) level_str="DEBUG";;
            *) level_str="?????";;
        esac
        
        # Format the log message
        local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
        local log_message="[$timestamp] $level_str: $message"
        
        # Write to log file
        echo "$log_message" >> "$LOG_FILE"
        
        # Also print to console for ERROR and WARN
        if [ "$level" -le "$LOG_LEVEL_WARN" ]; then
            echo "$log_message" >&2
        fi
    fi
}

# Public logging functions
log_error() {
    _log $LOG_LEVEL_ERROR "$1"
}

log_warn() {
    _log $LOG_LEVEL_WARN "$1"
}

log_info() {
    _log $LOG_LEVEL_INFO "$1"
}

log_debug() {
    _log $LOG_LEVEL_DEBUG "$1"
}

# Set log level
set_log_level() {
    case "${1,,}" in
        "error") CURRENT_LOG_LEVEL=$LOG_LEVEL_ERROR;;
        "warn")  CURRENT_LOG_LEVEL=$LOG_LEVEL_WARN;;
        "info")  CURRENT_LOG_LEVEL=$LOG_LEVEL_INFO;;
        "debug") CURRENT_LOG_LEVEL=$LOG_LEVEL_DEBUG;;
        *)
            log_warn "Invalid log level '$1'. Using default (INFO)"
            CURRENT_LOG_LEVEL=$LOG_LEVEL_INFO
            ;;
    esac
}

# Get current log file path
get_log_file() {
    echo "$LOG_FILE"
} 