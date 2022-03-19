# Shell Configuration

Configurations for Linux shell and *vim*

## Linux Shell Configuration

![Shell Appearence](./shell_appearence.JPG)

### Features

- Shell: oh-my-zsh
- Theme: powerlevel10k
- Plugins: [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions), [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting), [thefuck](https://github.com/nvbn/thefuck)

### Install

1. Install Meslo Nerd Font
   
   Download these four ttf files:

    - [MesloLGS NF Regular.ttf](https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf)
    - [MesloLGS NF Bold.ttf](https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf)
    - [MesloLGS NF Italic.ttf](https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf)
    - [MesloLGS NF Bold Italic.ttf](https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf)

    Double-click on each file and click "Install". This will make `MesloLGS NF` font available to all
    applications on your system.

    For setting up the font in the preference of the terminals, please refer to [p10k Font](https://github.com/romkatv/powerlevel10k#Fonts).

1. Update `apt` sources
    ```bash
    sudo apt update
    ```

1. Install prerequisite tools (*git*, *wget*, *python3*, *pip3*)
   
    ```
    sudo apt install wget git python3-dev python3-pip python3-setuptools
    ```

1. [Install zsh](https://github.com/ohmyzsh/ohmyzsh/wiki/Installing-ZSH)
    
    - Ubuntu, Debian & derivatives
        ```
        sudo apt install zsh
        ```

    - Arch Linux or Manjaro
        ```
        sudo pacman -S zsh
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
    - thefuck
        ```
        sudo pip3 install thefuck
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
        ln ~/Documents/GitHub/ShellConfig/surface_debian/.bashrc ~/.bashrc
        ln ~/Documents/GitHub/ShellConfig/surface_debian/.zshrc ~/.zshrc
        ln ~/Documents/GitHub/ShellConfig/surface_debian/.p10k.zsh ~/.p10k.zsh
        ```

1. Restart terminal

## Vim Configuration

![Vim Appearance](./vim_appearence.JPG)

### Features

- Plugin management: Vundle
- Theme: vim-airline
- Plugins: [YouCompleteMe](https://github.com/ycm-core/YouCompleteMe), [vim-airline](https://github.com/vim-airline/vim-airline), [vimtex](https://github.com/lervag/vimtex)

### Prerequisite

The default *vim* in Debian OS is *vim-tiny*, which does not support the plugins. Use following command to check your *vim* version first before using this configuration.

```
vi --version
```

If there is "Small version without GUI" in the output, it means your *vim* is *vim-tiny*. You can remove it and install the full version *vim* using following command:

```
sudo apt remove vim-tiny
sudo apt install vim
```

### Configuration

1. Install [Vundle](https://github.com/VundleVim/Vundle.vim)

    ```
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    ```

2. Link configuration file to *home* directory
    ```
    ln ~/Documents/GitHub/ShellConfig/surface_debian/.vimrc ~/.vimrc
    ```

3. Install plugins in Vim, type following command in Vim
    ```
    :PluginInstall
    ```
    Plugins will be installed automatically, wait until the install completed.

1. Other plugins can be installed easily via *Vundle*
