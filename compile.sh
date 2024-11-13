OUTPUT="hitmanLinux"
SOURCE="hitmanLinux.cpp"
USER_HOME=$(getent passwd "$SUDO_USER" | cut -d: -f6)
CONFIG_DIR="$USER_HOME/.config/hitmanLinux"

REQUIRED_PACKAGES=("g++" "pkg-config" "libgtk-3-dev" "libx11-dev" "libayatana-appindicator3-dev")

check_and_install_packages() {
    echo "Checking for required packages..."
    for PACKAGE in "${REQUIRED_PACKAGES[@]}"; do
        if ! dpkg -s "$PACKAGE" &>/dev/null; then
            echo "Missing package: $PACKAGE"
            echo "Installing $PACKAGE..."
            sudo apt update
            sudo apt install -y "$PACKAGE"
            if [ $? -ne 0 ]; then
                echo "Failed to install $PACKAGE. Please check your package manager."
                exit 1
            fi
        else
            echo "$PACKAGE is already installed."
        fi
    done
}

compile_source() {
    export PKG_CONFIG_PATH=/usr/lib/x86_64-linux-gnu/pkgconfig:$PKG_CONFIG_PATH
    g++ "$SOURCE" -o "$OUTPUT" $(pkg-config --cflags --libs gtk+-3.0 x11 ayatana-appindicator3-0.1) -std=c++11
}

main() {
    check_and_install_packages
    compile_source
}

main
