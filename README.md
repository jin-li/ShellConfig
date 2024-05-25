Language : 🇺🇸 | [🇨🇳](./README.zh-cn.md)

# Shell Configuration

Configurations for Linux shell and *Neovim*

## Linux Shell Configuration

![Shell Appearence](https://img.jinli.io/images/2024/05/19/shell_appearence.md.jpg)

### Features

- Shell: [oh-my-zsh](https://ohmyz.sh/)
- Theme: [powerlevel10k](https://github.com/romkatv/powerlevel10k)
- Plugins: [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions), [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)

### Install

#### Method 1: Use Installation Script (Recommend)

1. Download the installation script:
    ```sh
    curl -s https://raw.githubusercontent.com/jin-li/ShellConfig/main/install_OhMyZsh_p10k.sh -o install_OhMyZsh_p10k.sh
    ```

1. Run the script:
    ```
    chmod +x install_OhMyZsh_p10k.sh
    ./install_OhMyZsh_p10k.sh
    ```

#### Manual Install

1. Install Meslo Nerd Font
   
   Download these four ttf files:

    - [MesloLGS NF Regular.ttf](https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf)
    - [MesloLGS NF Bold.ttf](https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf)
    - [MesloLGS NF Italic.ttf](https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf)
    - [MesloLGS NF Bold Italic.ttf](https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf)

    Double-click on each file and click "Install". This will make `MesloLGS NF` font available to all
    applications on your system.

    For setting up the font in the preference of the terminals, please refer to [p10k Font](https://github.com/romkatv/powerlevel10k#Fonts).

1. [Install zsh](https://github.com/ohmyzsh/ohmyzsh/wiki/Installing-ZSH)
    
    - Ubuntu, Debian & derivatives
        1. Update `apt` sources
            ```bash
            sudo apt update
            ```

        1. Install prerequisite tools (*git*, *wget*, *python3*, *pip3*)
        
            ```
            sudo apt install wget git python3-dev python3-pip python3-setuptools
            ```
    
        1. Install *zsh*
            ```
            sudo apt install zsh
            ```

    - Arch Linux or Manjaro
        ```
        sudo pacman -S zsh
        ```
    
    - Fedora
        ```
        sudo dnf install zsh
        ```

1. Install [oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh) via *wget*
    
    ```
    sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    ```

1. Install [powerlevel10k](https://github.com/romkatv/powerlevel10k#oh-my-zsh)
   
    ```
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
    ```

1. Install plugins and tools
   
    - zsh-autosuggestions
        ```
        git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
        ```
    - zsh-syntax-highlighting
        ```
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
        ```

1. Download configuration files and link to home directory
    
    1. Download *ShellConfig* from GitHub
        ```
        mkdir -p ~/Documents/GitHub
        cd ~/Documents/GitHub
        git clone https://github.com/jin-li/ShellConfig.git 
        ```
    2. Backup old configuration files
        ```
        mv ~/.bashrc ~/.bashrc_bak
        mv ~/.zshrc ~/.zshrc_bak
        ```
    3. Link configuration files to *home* directory
        ```
        ln ~/Documents/GitHub/ShellConfig/.bashrc ~/.bashrc
        ln ~/Documents/GitHub/ShellConfig/.zshrc ~/.zshrc
        ln ~/Documents/GitHub/ShellConfig/.p10k.zsh ~/.p10k.zsh
        ```

1. Restart terminal

## Vim Configuration

![Vim Appearance](https://img.jinli.io/images/2024/05/24/lazyvim.md.png)

### Motivation

I migrated from *vim* to *Neovim* because of the better performance and more features. 

[*LazyVim*](https://www.lazyvim.org/) is a starter-friendly configuration for *Neovim* with the commonly used plugins. It is easy to install and use.

#### Method 1: Use Installation Script (Recommend)

1. Download the installation script:
    ```sh
    curl -s https://raw.githubusercontent.com/jin-li/ShellConfig/main/install_LazyVim.sh -o install_LazyVim.sh
    ```

2. Run the script:
    ```
    chmod +x install_LazyVim.sh
    ./install_LazyVim.sh
    ```

#### Method 2: Manual Install

1. Remove *vim-tiny* or *vim-minimal*

    The default *vim* in Debian OS is *vim-tiny* (in Fedora is *vim-minimal*), which does not support the plugins. Use following command to check your *vim* version first before using this configuration.

    ```
    vi --version
    ```

    If there is "Small version without GUI" in the output, it means your *vim* is *vim-tiny* or *vim-minimal*. You can remove it:

    - Debian / Ubuntu
        ```
        sudo apt remove vim-tiny
        ```
    - Fedora
        ```
        sudo dnf remove vim-minimal
        ```

2. Install *Neovim*

    Then install [*Neovim*](https://neovim.io/).

    - Debian / Ubuntu
    
        Since *LazyVim* requires *Neovim* 0.8 or later, in Ubuntu 22.04, the neovim version is 0.6.1. Therefore, We need to install the newer version of *neovim* from the official website.

      1. Download the pre-built binaries of *Neovim* from the [official website](https://github.com/neovim/neovim/releases)
          ```
          curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
          ```
      2. Extract the downloaded file
          ```
          sudo tar -C /opt -xzf nvim-linux64.tar.gz
          ```
          This will install *Neovim* to */opt/nvim-linux64* directory.
      3. Create a symbolic link to the *Neovim* executable
          ```
          sudo ln -s /opt/nvim-linux64/bin/nvim /usr/bin/nvim
          ```

    - Fedora
    
        In Fedora 40, the *Neovim* version is 0.9.5, which is new enough to use *LazyVim*. So we can install it using *dnf* directly.
        ```
        sudo dnf install neovim
        ```

3. Install *LazyVim*

    Refer to the [official website](https://www.lazyvim.org/installation), we can install *LazyVim* using the following command:

    1. Install *LazyVim*
        ```
        git clone https://github.com/LazyVim/starter ~/.config/nvim
        ```

    2. Remove the `.git` folder, so you can add it to your own repo later
        ```
        rm -rf ~/.config/nvim/.git
        ```

    3. First time run *nvim* will install the plugins automatically. It may take a while to finish.
        ```
        nvim
        ```

## Replace macOS Terminal

After installing LazyVim, I found that the display effect of LazyVim in macOS Terminal is very poor, with dim colors and low contrast:

![LazyVim in macOS Terminal](https://img.jinli.io/images/2024/05/19/lazyvim_macos_terminal.md.png)

The reason is that the macOS Terminal's color scheme does not support 256 true colors, while LazyVim defaults to a 256-color color scheme.
I heard that [iTerm2](https://iterm2.com/) supports 256 true colors, so I decided to migrate from the macOS built-in terminal to iTerm2.
After installing iTerm2, you need to set iTerm2 to use the Meslo Nerd font you downloaded and installed earlier.
Then open LazyVim in iTerm2, it looks much better now:

![LazyVim in iTerm2](https://img.jinli.io/images/2024/05/19/lazyvim_iterm2.md.png)

