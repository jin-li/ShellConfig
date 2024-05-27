#!/bin/bash

# Function to check and uninstall Vim on Debian-based systems
install_zsh_debian() {
    for pkg in wget curl git zsh; do
        if dpkg -l | grep -q "^ii  $pkg"; then
            echo "$pkg is already installed"
        else
            echo "Installing $pkg ..."
            sudo apt install -y $pkg
        fi
    done
}

# Function to check and uninstall Vim on Fedora-based systems
install_zsh_fedora() {
    for pkg in wget curl git zsh; do
        if rpm -q $pkg; then
            echo "$pkg is already installed"
        else
            echo "Installing $pkg ..."
            sudo dnf install -y $pkg
        fi
    done
}

# Function to check and uninstall Vim on Arch-based systems
install_zsh_arch() {
    for pkg in wget curl git zsh; do
        if pacman -Qs $pkg > /dev/null; then
            echo "$pkg is already installed"
        else
            echo "Installing $pkg ..."
            sudo pacman -Sy --noconfirm $pkg
        fi
    done
}

# Function to check and uninstall Vim on openSUSE-based systems
install_zsh_opensuse() {
    for pkg in wget curl git zsh; do
        if rpm -q $pkg; then
            echo "$pkg is already installed"
        else
            echo "Installing $pkg ..."
            sudo zypper install -y $pkg
        fi
    done
}

# Function to check and uninstall Vim on macOS
install_zsh_macos() {
    for pkg in wget curl git zsh; do
        if brew list | grep -q $pkg; then
            echo "$pkg is already installed"
        else
            echo "Installing $pkg ..."
            brew install $pkg
        fi
    done
}

# Detect the operating system and install the dependencies
if [ -f /etc/os-release ]; then
    . /etc/os-release
    case "$ID" in
        Deepin|pop|ubuntu|debian)
            echo "Detected Debian-based system"
            install_zsh_debian
            ;;
        fedora)
            echo "Detected Fedora-based system"
            install_zsh_fedora
            ;;
        arch|manjaro|endeavouros|garuda|artix|archcraft)
            echo "Detected Arch-based system"
            install_zsh_arch
            ;;
        opensuse|suse)
            echo "Detected openSUSE-based system"
            install_zsh_opensuse
            ;;
        *)
            echo "Unsupported operating system: $ID"
            exit 1
            ;;
    esac
elif [[ "$OSTYPE" == "darwin"* ]]; then
    echo "Detected macOS"
    install_zsh_macos
else
    echo "Unsupported operating system"
    exit 1
fi

# Install Oh My Zsh
echo "Installing Oh My Zsh ..."
sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install Powerlevel10k
echo "Installing Powerlevel10k ..."
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# Install Zsh Autosuggestions
echo "Installing Zsh Autosuggestions ..."
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# Install Fast Syntax Highlighting
echo "Installing Fast Syntax Highlighting ..."
git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git \
  ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting

# Check with the user if they want to install Meslo Nerd Fonts
read -p "Do you want to install LazyVim? (y/n): " choice
case "$choice" in
    y|Y )
        echo "Installing Nerd Fonts ...";
        USER_FONT_DIR="$HOME/.local/share/fonts"
        if [ ! -d "$USER_FONT_DIR" ]; then
            echo "Creating directory $USER_FONT_DIR"
            mkdir -p "$USER_FONT_DIR"
        else
            echo "Directory $USER_FONT_DIR already exists"
        fi
        wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf -P "$USER_FONT_DIR"
        wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf -P "$USER_FONT_DIR"
        wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf -P "$USER_FONT_DIR"
        wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf -P "$USER_FONT_DIR"
        fc-cache -f -v
        ;;
    n|N ) echo "Nerd Fonts will not be installed";;
    * ) echo "Invalid choice. Nerd Fonts will not be installed";;
esac

# Directory to be created
SHELL_CONFIG_PATH="$HOME/Documents/GitHub"

# Create the directory if it doesn't exist
if [ ! -d "$SHELL_CONFIG_PATH" ]; then
    echo "Creating directory $SHELL_CONFIG_PATH"
    mkdir -p "$SHELL_CONFIG_PATH"
else
    echo "Directory $SHELL_CONFIG_PATH already exists"
fi

# Clone the repository
echo "Cloning the repository"
if [ -d "$SHELL_CONFIG_PATH/ShellConfig" ]; then
    echo "ShellConfig already exists"
    read -p "Do you want to update ShellConfig? (y/n): " choice
    case "$choice" in
        y|Y ) echo "Updating ShellConfig ..."; cd "$SHELL_CONFIG_PATH/ShellConfig" || exit; git pull;;
        n|N ) echo "ShellConfig will not be updated";;
        * ) echo "Invalid choice. ShellConfig will not be updated";;
    esac
else
    git clone https://github.com/jin-li/ShellConfig.git "$SHELL_CONFIG_PATH/ShellConfig"
fi

# Back up the existing configuration files
echo "Backing up existing configuration files"
if [ -f $HOME/.bashrc ]; then
    cp $HOME/.bashrc $HOME/.bashrc.bak
fi
if [ -f $HOME/.zshrc ]; then
    cp $HOME/.zshrc $HOME/.zshrc.bak
fi
if [ -f $HOME/.p10k.zsh ]; then
    cp $HOME/.p10k.zsh $HOME/.p10k.zsh.bak
fi

# Link the new configuration files
echo "Linking the new configuration files"
ln -sf "$SHELL_CONFIG_PATH/ShellConfig/.bashrc" $HOME/.bashrc
ln -sf "$SHELL_CONFIG_PATH/ShellConfig/.zshrc" $HOME/.zshrc
ln -sf "$SHELL_CONFIG_PATH/ShellConfig/.p10k.zsh" $HOME/.p10k.zsh

# Source the new configuration files
#echo "Sourcing the new configuration files"
#source $HOME/.bashrc
#source $HOME/.zshrc

# Print the success message
echo "Shell configuration has been successfully installed!"

# Check with the user if they want to install LazyVim
#read -p "Do you want to install LazyVim? (y/n): " choice
#case "$choice" in
#    y|Y ) echo "Installing LazyVim ...";;
#    n|N ) echo "LazyVim will not be installed. Please restart your shell to apply the changes."; exit 0;;
#    * ) echo "Invalid choice. LazyVim will not be installed. Please restart your shell to apply the changes. If you want to install LazyVim later, run the script install_LazyVim.sh"; exit 1;;
#esac
# execute the LazyVim installation script install_LazyVim.sh
#/bin/bash "./install_LazyVim.sh"

# Finish the installation
echo "Installation complete. You need to apply the Nerd Fonts in your terminal settings. Please restart your terminal to apply the changes."