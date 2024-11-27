#!/bin/bash

# including functions
source functions/detect_package_manager.sh
source functions/list_software.sh
source functions/install_software.sh
source data/software_list.sh

# user input
echo "Enter space-separated short names of softwares you want to install:"
read -r selected_software