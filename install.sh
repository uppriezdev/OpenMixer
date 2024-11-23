#!/bin/bash

# Configuration
APP_NAME="OpenMixer"
APP_URL="http://192.168.1.38/OpenMixer_v1.0.0_portable.tar.gz"
APP_DIR="/opt/OpenMixer"
USER_NAME="mixer"
USER_PASSWORD="mixer123"  # Change this!
TEMP_DIR="/tmp/openmixer_setup"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Logging
LOG_FILE="/var/log/embedded_setup.log"

# Function to print messages
print_message() {
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo -e "${2}[${timestamp}] ${1}${NC}" | tee -a "${LOG_FILE}"
}

# Function to download and extract OpenMixer
download_and_extract() {
    print_message "Downloading OpenMixer..." "${YELLOW}"

    # Create temporary directory
    mkdir -p "${TEMP_DIR}"
    cd "${TEMP_DIR}" || exit 1

    # Download the application
    if ! wget "${APP_URL}" -O OpenMixer.tar.gz; then
        print_message "Failed to download OpenMixer" "${RED}"
        exit 1
    fi

    print_message "Extracting OpenMixer..." "${YELLOW}"

    # Extract the archive
    if ! tar xzf OpenMixer.tar.gz; then
        print_message "Failed to extract OpenMixer" "${RED}"
        exit 1
    fi

    print_message "Download and extraction completed" "${GREEN}"
}

# Function to check if running as root
check_root() {
    if [ "$EUID" -ne 0 ]; then
        print_message "Please run as root" "${RED}"
        exit 1
    fi
}

# Function to install required packages
install_packages() {
    print_message "Installing required packages..." "${YELLOW}"

    # Update package lists
    pacman -Syu --noconfirm

    # Install required packages
    pacman -S --noconfirm \
        xorg-server \
        xorg-xinit \
        openbox \
        xorg-xsetroot \
        xterm \
        wget \
        unzip \
        alsa-utils \
        pulseaudio \
        pavucontrol \
        network-manager-applet \
        mesa \
        libxcb \
        xcb-util-keysyms \
        xcb-util-image \
        xcb-util-renderutil \
        xcb-util-wm \
        libxkbcommon-x11
}

# Function to create user
create_user() {
    print_message "Creating user ${USER_NAME}..." "${YELLOW}"

    if ! id "${USER_NAME}" &>/dev/null; then
        useradd -m -G audio,video,network -s /bin/bash "${USER_NAME}"
        echo "${USER_NAME}:${USER_PASSWORD}" | chpasswd
        print_message "User created successfully" "${GREEN}"
    else
        print_message "User already exists" "${YELLOW}"
    fi
}

# Function to setup OpenBox
setup_openbox() {
    print_message "Setting up OpenBox..." "${YELLOW}"

    # Create OpenBox config directory
    mkdir -p "/home/${USER_NAME}/.config/openbox"

    # Create autostart file
    cat > "/home/${USER_NAME}/.config/openbox/autostart" << 'EOL'
# Set background color
xsetroot -solid "#333333" &

# Start system tray
(nm-applet) &

# Start PulseAudio system tray
(pasystray) &

# Start OpenMixer
(/opt/OpenMixer/run_OpenMixer.sh) &
EOL

    # Create OpenBox config
    cat > "/home/${USER_NAME}/.config/openbox/rc.xml" << 'EOL'
<?xml version="1.0" encoding="UTF-8"?>
<openbox_config xmlns="http://openbox.org/3.4/rc">
  <resistance>
    <strength>10</strength>
    <screen_edge_strength>20</screen_edge_strength>
  </resistance>
  <focus>
    <focusNew>yes</focusNew>
    <followMouse>no</followMouse>
  </focus>
  <placement>
    <policy>Smart</policy>
  </placement>
  <theme>
    <name>Clearlooks</name>
    <keepBorder>yes</keepBorder>
  </theme>
  <keyboard>
    <chainQuitKey>C-g</chainQuitKey>
    <keybind key="A-F4">
      <action name="Close"/>
    </keybind>
    <keybind key="C-A-Delete">
      <action name="Exit"/>
    </keybind>
  </keyboard>
  <mouse>
    <dragThreshold>1</dragThreshold>
    <doubleClickTime>500</doubleClickTime>
  </mouse>
</openbox_config>
EOL

    # Create xinitrc
    cat > "/home/${USER_NAME}/.xinitrc" << 'EOL'
#!/bin/sh

# Load environment variables
if [ -f "$HOME/.config/environment" ]; then
    . "$HOME/.config/environment"
fi

# Start OpenBox
exec openbox-session
EOL

    # Create environment file
    mkdir -p "/home/${USER_NAME}/.config"
    cat > "/home/${USER_NAME}/.config/environment" << EOL
# Qt settings
export QT_QPA_PLATFORM=xcb
export QT_PLUGIN_PATH=/opt/OpenMixer/plugins
export LD_LIBRARY_PATH=/opt/OpenMixer/lib:\$LD_LIBRARY_PATH
export QML2_IMPORT_PATH=/opt/OpenMixer/qml
EOL

    # Set permissions
    chown -R "${USER_NAME}:${USER_NAME}" "/home/${USER_NAME}/.config"
    chmod +x "/home/${USER_NAME}/.xinitrc"
}

# Function to setup automatic login
setup_autologin() {
    print_message "Setting up automatic login..." "${YELLOW}"

    # Configure systemd for auto-login
    mkdir -p /etc/systemd/system/getty@tty1.service.d/
    cat > /etc/systemd/system/getty@tty1.service.d/override.conf << EOL
[Service]
ExecStart=
ExecStart=-/usr/bin/agetty --autologin ${USER_NAME} --noclear %I \$TERM
EOL

    # Configure automatic X server start
    cat > "/home/${USER_NAME}/.bash_profile" << 'EOL'
if [ -z "$DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
    startx
fi
EOL

    chown "${USER_NAME}:${USER_NAME}" "/home/${USER_NAME}/.bash_profile"
}

# Function to install OpenMixer
install_openmixer() {
    print_message "Installing OpenMixer..." "${YELLOW}"

    # Create application directory
    mkdir -p "${APP_DIR}"

    # Copy files from temporary directory to installation directory
    cp -r "${TEMP_DIR}"/* "${APP_DIR}/"

    # Create run script
    cat > "${APP_DIR}/run_OpenMixer.sh" << 'EOL'
#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
export LD_LIBRARY_PATH="$SCRIPT_DIR/lib:$LD_LIBRARY_PATH"
export QT_PLUGIN_PATH="$SCRIPT_DIR/plugins"
export QML2_IMPORT_PATH="$SCRIPT_DIR/qml"
export QT_QPA_PLATFORM=xcb
export QT_DEBUG_PLUGINS=1
"$SCRIPT_DIR/bin/OpenMixer" "$@"
EOL

    # Set permissions
    chmod +x "${APP_DIR}/run_OpenMixer.sh"
    chown -R "${USER_NAME}:${USER_NAME}" "${APP_DIR}"
}

# Function to setup audio
setup_audio() {
    print_message "Setting up audio..." "${YELLOW}"
    usermod -a -G audio "${USER_NAME}"
    systemctl --user enable pulseaudio
}

# Function to optimize system
optimize_system() {
    print_message "Optimizing system..." "${YELLOW}"

    # Disable unnecessary services
    systemctl disable bluetooth.service || true
    systemctl disable cups.service || true

    # Create X server config
    mkdir -p /etc/X11/xorg.conf.d
    cat > /etc/X11/xorg.conf.d/20-modesetting.conf << 'EOL'
Section "Device"
    Identifier "Video Card"
    Driver "modesetting"
    Option "AccelMethod" "glamor"
    Option "DRI" "3"
EndSection
EOL

    # System optimizations
    cat > /etc/sysctl.d/99-embedded.conf << 'EOL'
vm.swappiness=10
kernel.panic=10
EOL
}

# Function to cleanup
cleanup() {
    print_message "Cleaning up temporary files..." "${YELLOW}"
    rm -rf "${TEMP_DIR}"
}

# Main installation function
main() {
    print_message "Starting installation..." "${GREEN}"
    echo "Installation started at $(date)" > "${LOG_FILE}"

    check_root
    download_and_extract
    install_packages
    create_user
    setup_openbox
    setup_autologin
    install_openmixer
    setup_audio
    optimize_system
    cleanup

    print_message "Installation completed successfully!" "${GREEN}"
    print_message "Please reboot the system to apply changes." "${YELLOW}"
    print_message "Log file available at: ${LOG_FILE}" "${YELLOW}"
}

# Run main installation
main
