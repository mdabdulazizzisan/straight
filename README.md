# Straight Package Installer

A cross-distribution package installer for Linux, inspired by Ninite for Windows. Straight allows you to install multiple applications across different Linux distributions using a single command.

## Features

- Supports multiple Linux distributions (Ubuntu, Debian, Fedora, Arch Linux, etc.)
- Automatic distribution detection
- Multiple package manager support (apt, dnf, pacman, flatpak, snap)
- Smart package manager selection based on availability
- Extensive software catalog with popular applications
- Fallback to alternative package managers when needed
- Detailed logging system
- Progress tracking and status updates

## Requirements

- Bash shell
- Root/sudo privileges
- Internet connection
- One of the supported Linux distributions

## Supported Distributions

- Ubuntu and derivatives (Linux Mint, Pop!_OS, etc.)
- Debian
- Fedora
- Arch Linux
- OpenSUSE
- CentOS
- Red Hat Enterprise Linux
- And more...

## Installation

1. Clone the repository:
```bash
git clone https://github.com/mdabdulazizzisan/straight.git
cd straight
```

2. Make the script executable:
```bash
chmod +x straight.sh
```
![ezgif com-video-to-gif-converter](https://github.com/user-attachments/assets/a680979b-c440-4b95-a45a-c5dc83a21b7c)

## Usage

Basic usage:
```bash
sudo ./straight.sh [software_names...]
```

Example:
```bash
sudo ./straight.sh firefox vlc gimp libreoffice
```

List available software:
```bash
./straight.sh --list
```

Show help:
```bash
./straight.sh --help
```

## Supported Software

The installer supports a wide range of popular software, including:

- LibreOffice - Office suite
- GIMP - Image editor
- VLC - Media player
- Firefox - Web browser
- Visual Studio Code - Code editor
- Steam - Gaming platform
- And many more...

For a complete list of supported software, use the `--list` option.

## Project Structure

```
straight/
├── straight.sh          # Main script
├── src/
│   ├── distro_detect.sh    # Distribution detection
│   ├── package_managers.sh # Package manager operations
│   └── software_install.sh # Software installation logic
├── data/
│   └── package_names.sh    # Package name mappings
├── utils/
│   ├── logger.sh          # Logging utilities
│   └── helpers.sh         # Helper functions
└── logs/
    └── straight.log       # Log file
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](https://github.com/mdabdulazizzisan/straight/blob/main/LICENSE) file for details.

## Acknowledgments

- Inspired by Ninite for Windows
- Thanks to all package maintainers and distribution developers
- Special thanks to the open-source community

## Author
```
[Md Abdul Aziz Zisan,
Fahim Faisal Talha,
Nafiul Islam]
```
## Support

For bug reports and feature requests, please use the GitHub issue tracker. 
