语言 : 🇨🇳 | [🇺🇸](./README.md)

## 配置shell

效果展示:

![Shell Appearence](./figs/shell_appearence.JPG)

### 特点

- Shell: oh-my-zsh
- 主题: powerlevel10k
- 插件: 命令自动补全建议[zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions), 命令语法高亮[zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting), 命令修正建议[thefuck](https://github.com/nvbn/thefuck)

### 安装

1. 安装 Meslo Nerd 字体
   
   下载一下四个字体文件：

    - [MesloLGS NF Regular.ttf](https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf)
    - [MesloLGS NF Bold.ttf](https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf)
    - [MesloLGS NF Italic.ttf](https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf)
    - [MesloLGS NF Bold Italic.ttf](https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf)

    双击各文件并点击`安装`按钮，然后电脑上包括命令行终端在内的的各个软件就可以使用`MesloLGS NF`字体了。

    请参考[p10k Font](https://github.com/romkatv/powerlevel10k#Fonts)来为Windows Power Shell、macOS Terminal等命令行终端工具配置`MesloLGS NF`字体。


1. [安装 zsh](https://github.com/ohmyzsh/ohmyzsh/wiki/Installing-ZSH)
    
    - Ubuntu, Debian 及Debian系衍生系统
    
      1. 更新 `apt` 源
      ```bash
      sudo apt update
      ```

     1. 安装依赖的工具库 (*git*, *wget*, *python3*, *pip3*)
        
         ```
         sudo apt install wget git python3-dev python3-pip python3-setuptools
         ```
    
     1. 安装 *zsh*
        ```
        sudo apt install zsh
        ```

    - Arch Linux 或 Manjaro
        ```
        sudo pacman -S zsh
        ```
    
    - macOS已自带zsh

    - Fedora
        ```
        sudo dnf install zsh
        ```

1. 通过*wget*安装 [oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh)
    
    ```
    sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    ```

1. 安装 [powerlevel10k](https://github.com/romkatv/powerlevel10k#oh-my-zsh)
   
    ```
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
    ```

1. 安装插件和工具
   
    - 命令自动补全建议zsh-autosuggestions
        ```
        git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
        ```
    - 命令语法高亮zsh-syntax-highlighting
        ```
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
        ```

1. 下载配置文件，并链接到用户根目录下
    
    1. 从GitHub下载 *ShellConfig*
        ```
        mkdir -p ~/Documents/GitHub
        cd ~/Documents/GitHub
        git clone https://github.com/jin-li/ShellConfig.git 
        ```
    2. 备份旧配置文件
        ```
        mv ~/.bashrc ~/.bashrc_bak
        mv ~/.zshrc ~/.zshrc_bak
        ```
    3.将配置文件链接到 *home* 目录
        ```
        ln ~/Documents/GitHub/ShellConfig/.bashrc ~/.bashrc
        ln ~/Documents/GitHub/ShellConfig/.zshrc ~/.zshrc
        ln ~/Documents/GitHub/ShellConfig/.p10k.zsh ~/.p10k.zsh
        ```

1.  重启命令行终端

## 配置Vim

![Vim Appearance](./figs/vim_appearence.JPG)

### 动机

虽然日常的代码开发中我一般都使用vscode，但是在编辑一些简单的文本文件，或者在服务器上编辑文本文件时，还是用vim更加方便快捷。之前一直使用vim，但总觉得配置起来比较麻烦。于是我准备迁移到neovim，并使用LazyVim，这样就可以做到开箱即用，不需要再配置了。

### 安装

#### 卸载 *vim-tiny* 或 *vim-minimal*

Debian系统默认的vim是*vim-tiny*，Fedora系统默认的vim是*vim-minimal*，这两个版本都不支持插件。在使用本配置之前，需要先检查你的vim版本。

```
vi --version
```

如果输出中有"Small version without GUI"，说明你的vim是*vim-tiny*或*vim-minimal*。你可以卸载它：

- Debian / Ubuntu
    ```
    sudo apt remove vim-tiny
    ```
- Fedora
    ```
    sudo dnf remove vim-minimal
    ```

#### 安装 *neovim*

然后安装[*neovim*](https://neovim.io/)。

- Debian / Ubuntu
  
  由于*LazyVim*需要*neovim* 0.8或更高版本，而在Ubuntu 22.04中，neovim的版本是0.6.1。因此，我们需要从官方网站安装更新的*neovim*。

    1. 从[官方网站](https://github.com/neovim/neovim/releases)下载预编译的*neovim*二进制文件
        ```
        curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
        ```
    2. 解压下载的文件
        ```
        sudo tar -C /opt -xzf nvim-linux64.tar.gz
        ```
        这将*neovim*安装到*/opt/nvim-linux64*目录。
    3. 创建一个符号链接到*neovim*可执行文件
        ```
        sudo ln -s /opt/nvim-linux64/bin/nvim /usr/bin/nvim
        ```
- Fedora
    
    在Fedora 40中，*neovim*的版本是0.9.5，这个版本足够新，可以使用*LazyVim*。所以我们可以直接使用*dnf*安装它。
        ```
        sudo dnf install neovim
        ```

### 安装 *LazyVim*

参考[官方网站](https://www.lazyvim.org/installation)，我们可以使用以下命令安装*LazyVim*：   

1. 安装 *LazyVim*
    ```
    git clone https://github.com/LazyVim/starter ~/.config/nvim
    ```
2. 删除`.git`文件夹，这样你就可以将它添加到你自己的仓库中
    ```
    rm -rf ~/.config/nvim/.git
    ```
3. 第一次运行*nvim*会自动安装插件。这可能需要一段时间才能完成。
    ```
    nvim
    ```
4. 退出*nvim*，然后重新打开*nvim*，你就可以看到*LazyVim*的效果了。