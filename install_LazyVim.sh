#!/bin/bash

# Function to check and uninstall Vim on Debian-based systems
uninstall_vim_debian() {
    for pkg in vim vim-tiny vim-common vim-minimal; do
        if dpkg -l | grep -q "^ii  $pkg"; then
            echo "Removing $pkg"
            sudo apt remove -y $pkg
        else
            echo "$pkg is not installed"
        fi
    done
}

# Function to check and uninstall Vim on Fedora-based systems
uninstall_vim_fedora() {
    for pkg in vim-enhanced vim-common vim-minimal; do
        if rpm -q $pkg; then
            echo "Removing $pkg"
            sudo dnf remove -y $pkg
        else
            echo "$pkg is not installed"
        fi
    done
}

# Function to check and uninstall Vim on Arch-based systems
uninstall_vim_arch() {
    for pkg in vim; do
        if pacman -Qs $pkg > /dev/null; then
            echo "Removing $pkg"
            sudo pacman -Rns --noconfirm $pkg
        else
            echo "$pkg is not installed"
        fi
    done
}

# Function to check and uninstall Vim on Archcraft
uninstall_vim_archcraft() {
    for pkg in archcraft-vim vim; do
        if pacman -Qs $pkg > /dev/null; then
            echo "Removing $pkg"
            sudo pacman -Rns --noconfirm $pkg
        else
            echo "$pkg is not installed"
        fi
    done
}

# Function to check and uninstall Vim on openSUSE-based systems
uninstall_vim_opensuse() {
    for pkg in vim; do
        if rpm -q $pkg; then
            echo "Removing $pkg"
            sudo zypper remove -y $pkg
        else
            echo "$pkg is not installed"
        fi
    done
}

# Function to check and uninstall Vim on macOS
uninstall_vim_macos() {
    if brew list | grep -q "^vim$"; then
        echo "Removing vim"
        brew uninstall vim
    else
        echo "vim is not installed"
    fi
}

# Function to uninstall neovim on Debian-based systems
uninstall_neovim_debian() {
    sudo apt remove -y neovim
}

# Function to uninstall neovim on Fedora-based systems
uninstall_neovim_fedora() {
    sudo dnf remove -y neovim
}

# Function to uninstall neovim on Arch-based systems
uninstall_neovim_arch() {
    sudo pacman -Rns --noconfirm neovim
}

# Function to uninstall neovim on openSUSE-based systems
uninstall_neovim_opensuse() {
    sudo zypper remove -y neovim
}

# Function to uninstall neovim on macOS
uninstall_neovim_macos() {
    brew uninstall neovim
}

# Function to install Neovim on Debian-based systems
install_neovim_debian() {
    sudo apt update
    sudo apt install -y neovim
}

# Function to install Neovim on Fedora-based systems
install_neovim_fedora() {
    sudo dnf install -y neovim
}

# Function to install Neovim on Arch-based systems
install_neovim_arch() {
    sudo pacman -Sy --noconfirm neovim
}

# Function to install Neovim on openSUSE-based systems
install_neovim_opensuse() {
    sudo zypper install -y neovim
}

# Function to install Neovim on macOS
install_neovim_macos() {
    brew install neovim
}

# Function to check Neovim version
check_neovim_version() {
    if command -v nvim &> /dev/null; then
        NVIM_VERSION=$(nvim --version | head -n 1 | awk '{print $2}')
        echo "$NVIM_VERSION"
    else
        echo "v0.0.0"
    fi
}

# Function to install the latest Neovim binary
install_latest_neovim() {
    echo "Installing the latest Neovim version..."
    wget https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
    chmod u+x nvim.appimage
    sudo mv nvim.appimage /usr/local/bin/nvim
}

# Detect the operating system and uninstall Vim, then install Neovim
if [ -f /etc/os-release ]; then
    . /etc/os-release
    case "$ID" in
        ubuntu|debian|Deepin|pop)
            echo "Detected Debian-based system"
            uninstall_vim_debian
            install_neovim_debian
            ;;
        fedora)
            echo "Detected Fedora-based system"
            uninstall_vim_fedora
            install_neovim_fedora
            ;;
        arch|manjaro|endeavouros)
            echo "Detected Arch-based system"
            uninstall_vim_arch
            install_neovim_arch
            ;;
        archcraft)
            echo "Detected Arch-based system"
            uninstall_vim_archcraft
            install_neovim_arch
            ;;
        opensuse|suse)
            echo "Detected openSUSE-based system"
            uninstall_vim_opensuse
            install_neovim_opensuse
            ;;
        *)
            echo "Unsupported operating system: $ID"
            exit 1
            ;;
    esac
elif [[ "$OSTYPE" == "darwin"* ]]; then
    echo "Detected macOS"
    uninstall_vim_macos
    install_neovim_macos
else
    echo "Unsupported operating system"
    exit 1
fi

# Check Neovim version and install the latest if necessary
INSTALLED_NVIM_VERSION=$(check_neovim_version)
REQUIRED_VERSION="v0.8.0"

if [ "$(printf '%s\n' "$REQUIRED_VERSION" "$INSTALLED_NVIM_VERSION" | sort -V | head -n1)" != "$REQUIRED_VERSION" ]; then
    echo "Neovim version is $INSTALLED_NVIM_VERSION, which is less than $REQUIRED_VERSION. Installing the latest version."
    # Uninstall the current Neovim version
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        case "$ID" in
            ubuntu|debian|Deepin|pop)
                echo "Detected Debian-based system"
                uninstall_neovim_debian
                ;;
            fedora)
                echo "Detected Fedora-based system"
                uninstall_neovim_fedora
                ;;
            arch|manjaro|endeavouros|garuda|artix|archcraft|archlabs|arcolinux|archbang|archmerge|archstrike|archman|archfi|archbox|archlabs)
                echo "Detected Arch-based system"
                uninstall_neovim_arch
                ;;
            opensuse|suse)
                echo "Detected openSUSE-based system"
                uninstall_neovim_opensuse
                ;;
            *)
                echo "Unsupported operating system: $ID"
                exit 1
                ;;
        esac
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        echo "Detected macOS"
        uninstall_neovim_macos
    else
        echo "Unsupported operating system"
        exit 1
    fi
    # Install the latest Neovim version
    install_latest_neovim
else
    echo "Neovim version is $INSTALLED_NVIM_VERSION, which meets the requirement."
fi

# Install LazyVim
echo "Installing LazyVim ..."
if [ -d $HOME/.config/nvim ]; then
    echo "Backing up the existing nvim configuration..."
    mv $HOME/.config/nvim $HOME/.config/nvim.bak
else
    echo "Creating the nvim configuration directory..."
    git clone https://github.com/LazyVim/starter $HOME/.config/nvim
    rm -rf $HOME/.config/nvim/.git
fi

# Finished
echo "LazyVim has been installed successfully!"
# Show the neoVim version
echo "Neovim version: $(check_neovim_version)"

# Set the default editor to Neovim
echo "Setting Neovim as the default editor..."
echo "###########################################################################" >> $HOME/.zshrc`
echo "### Added after installing LazyVim, only valid when Neovim is installed ###" >> $HOME/.zshrc
if [ -z "$(command -v vim)" ]; then
    echo "alias vim='nvim'" >> $HOME/.zshrc
fi
echo "export EDITOR='nvim'" >> $HOME/.zshrc
echo "###########################################################################" >> $HOME/.zshrc`

echo "Please restart your terminal and nvim to apply the changes."
echo "It may take a while to install plugins and set up the configuration for the first time."