语言：中文🇨🇳 | Language [English 🇺🇸](./README.md)

# ShellConfig

> 面向 macOS、Linux、Windows 和 NixOS 的精致、便携式 Shell 环境。

![Jinli Oh My Posh 主题演示](./jinli-omp-demo.png)

ShellConfig 将精心设计的 [Oh My Posh](https://ohmyposh.dev/) 提示符、实用的
Zsh 默认配置、可选插件和独立的 LazyVim 配置组合在一起。应该共享的配置会
保持共享；机器和工具需要定制的部分则保留在本地。

## Jinli 主题的亮点

锦鲤主题 [`jinli.omp.json`](./jinli.omp.json) 让有用的信息始终可见，同时
避免提示符过于拥挤：

| 功能 | 展示内容 |
| --- | --- |
| **上下文感知路径** | 家目录、锁定目录、GitHub、Git、npm、Downloads、Pictures 和普通目录使用不同图标。 |
| **Git 状态一目了然** | 仓库名、分支、工作区状态和变更数量。 |
| **语言环境信息** | 仅在当前项目相关时显示 Python 和 Node 版本。 |
| **远程会话识别** | SSH 会话带有远程图标，方便区分本地和远程 Shell。 |
| **自适应提示符** | 电池、时间、命令耗时和退出状态会根据环境动态调整，并保持右对齐。 |
| **跨平台设计** | macOS/Linux 使用 Zsh，Windows 使用 PowerShell，并支持声明式 NixOS 配置。 |

上面的截图还展示了该主题与仓库中可选的系统信息显示配合使用的效果。

## 安装

请选择对应平台的安装方式。请以普通用户运行脚本；需要系统软件包时，脚本
会在使用 `sudo` 前进行询问。

### macOS 或 Linux

macOS 请先安装 [Homebrew](https://brew.sh/)，然后运行：

```sh
curl -fsSLO https://raw.githubusercontent.com/jin-li/ShellConfig/main/install-oh-my-posh.sh
chmod +x install-oh-my-posh.sh
./install-oh-my-posh.sh
```

脚本会询问仓库目录。直接按 Enter 使用 `~/Documents/GitHub/ShellConfig`，也
可以输入其他目录。安装完成后请重启终端，或运行 `exec zsh`。

更新已有安装时，请从仓库目录运行：

```sh
cd /path/to/ShellConfig
./update.sh
```

### Windows PowerShell

以普通用户打开 PowerShell：

```powershell
Set-ExecutionPolicy -Scope Process Bypass
Invoke-WebRequest https://raw.githubusercontent.com/jin-li/ShellConfig/main/install-oh-my-posh.ps1 -OutFile install-oh-my-posh.ps1
.\install-oh-my-posh.ps1
```

脚本在需要时通过 WinGet 安装 Oh My Posh 或 Git，询问仓库目录，并保留现有
PowerShell Profile 内容。

### NixOS

将仓库添加为 Flake 输入，导入模块并启用：

```nix
inputs.shell-config.url = "github:jin-li/ShellConfig";

modules = [ inputs.shell-config.nixosModules.default ];
programs.shellConfig.enable = true;
users.users.<username>.shell = pkgs.zsh;
```

然后重建系统并启动新的 Zsh 会话：

```bash
sudo nixos-rebuild switch --flake .#<host>
exec zsh
```

## 字体与终端设置

请在终端配置中安装并选择 **MesloLGM Nerd Font**。主题图标依赖 Nerd Font；
未配置该字体时，图标可能显示为方框。使用 WSL 时，请在 WSL 内运行 Linux
安装脚本，但在 Windows 中安装字体。

## Shell 配置

共享 Shell 配置在 macOS/Linux 使用 Zsh，在 Windows 使用 PowerShell。Zsh 包含：

- [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)
- [fast-syntax-highlighting](https://github.com/zdharma-continuum/fast-syntax-highlighting)
- 不区分大小写的补全，包括便捷的目录补全
- 通过 `AUTO_PUSHD`、`PUSHD_IGNORE_DUPS`、`cd -<数字>` 和 `dirs -v` 管理目录栈

Homebrew、Oh My Zsh 和 Neovim 都是可选的。`.zshrc.common` 只会在相关程序
存在时启用对应集成。如果已有 Oh My Zsh，脚本会使用其自定义插件目录；否则
插件会安装到 `~/.local/share/zsh/plugins`。

## 共享与本地 Zsh 配置

仓库中的 [`.zshrc.common`](./.zshrc.common) 是稳定的共享配置。安装脚本会
创建普通文件 `~/.zshrc` 并加载它。机器专属设置和工具初始化应放在
`~/.zshrc` 中，这样 Conda、OpenClaw 等工具可以追加自己的配置，而不会修改
仓库中的共享文件。

```zsh
export PATH="$HOME/.local/bin:$PATH"
alias connect-hpc='ssh user@example.org'
```

已有的 `~/.zshrc.local` 仍会被加载，以兼容旧版安装。原有 `~/.zshrc` 会被
备份为 `~/.zshrc-pre-oh-my-posh-jinli`，重名时会自动添加时间戳。

## Neovim 配置

LazyVim 与 Shell 安装保持独立：

```sh
curl -fsSLO https://raw.githubusercontent.com/jin-li/ShellConfig/main/install_LazyVim.sh
chmod +x install_LazyVim.sh
./install_LazyVim.sh
```

当前 LazyVim starter 要求 Neovim 0.11.2 或更高版本。安装脚本会在克隆 starter
前备份已有的 Neovim 数据。第一次启动 `nvim` 会下载插件，之后请运行
`:checkhealth`。

## 安装参考

macOS/Linux 安装脚本会安装 Zsh 依赖和 Oh My Posh，克隆或更新仓库，安装两个
Zsh 插件，将主题链接到 `~/.config/oh-my-posh/jinli.omp.json`，并询问是否安装
Meslo Nerd Font。如有需要，它还会把 Oh My Posh 的可执行文件目录加入用户管理
的 `~/.zshrc`，且确保该 PATH 配置位于加载 `.zshrc.common` 之前。

在 HPC 集群上，如果没有 `sudo` 且只有 Zsh 缺失，脚本可以将 ncurses 和 Zsh
编译到 `~/.local`（或 `$SHELL_CONFIG_PREFIX`）下。编译器和 `make` 必须已经
可用，例如通过集群 module 加载。

安装后的主要文件如下：

| 用途 | 位置 |
| --- | --- |
| 仓库 | `~/Documents/GitHub/ShellConfig` 或安装时选择的目录 |
| 共享 Zsh 配置 | 仓库中的 [`.zshrc.common`](./.zshrc.common) |
| 本地 Zsh 配置 | `~/.zshrc` |
| Oh My Posh 主题 | `~/.config/oh-my-posh/jinli.omp.json` |
| 独立 Zsh 插件 | `~/.local/share/zsh/plugins` |
| LazyVim 配置 | `~/.config/nvim` |

Windows 会直接使用仓库中的主题，只更新 `$PROFILE` 中由 ShellConfig 管理的
Oh My Posh 区块，不会创建 `~/.config` 下的主题链接。NixOS 模块以声明式方式
管理共享配置，但不会管理用户自己的 `~/.zshrc`。
