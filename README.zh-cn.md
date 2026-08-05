语言：🇨🇳 | [🇺🇸](./README.md)

# ShellConfig

适用于 macOS、Linux 和 Windows 的 Shell 与 Neovim 共享配置。

## Shell 配置

- 提示符：[Oh My Posh](https://ohmyposh.dev/)，使用锦鲤主题 [`jinli.omp.json`](./jinli.omp.json)
- Shell：macOS/Linux 使用 Zsh，Windows 使用 PowerShell
- Zsh 插件：[zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions) 和 [fast-syntax-highlighting](https://github.com/zdharma-continuum/fast-syntax-highlighting)
- Oh My Zsh 为可选组件。如果已经安装，脚本会把插件安装到它的自定义插件目录；否则插件会安装到 `~/.local/share/zsh/plugins`，脚本不会额外安装 Oh My Zsh。

仓库中的 `.zshrc` 不强制依赖 Homebrew、Oh My Zsh 或 Neovim，仅在对应程序存在时启用相关配置。

### macOS 和 Linux

支持 Debian/Ubuntu、Fedora/RHEL、Arch 和 openSUSE 等主流 Linux 系列。macOS 请先安装 [Homebrew](https://brew.sh/)。

请以普通用户运行，不要使用 `sudo` 启动脚本：

```sh
curl -fsSLO https://raw.githubusercontent.com/jin-li/ShellConfig/main/install-oh-my-posh.sh
chmod +x install-oh-my-posh.sh
./install-oh-my-posh.sh
```

脚本会：

1. 安装 Zsh 依赖和 Oh My Posh；
2. 将本仓库克隆或更新到 `~/Documents/GitHub/ShellConfig`；
3. 根据是否存在 Oh My Zsh，以相应方式安装两个 Zsh 插件；
4. 将主题链接到 `~/.config/oh-my-posh/jinli.omp.json`；
5. 将已有的 `~/.zshrc` 移动为 `~/.zshrc-pre-oh-my-posh-jinli`（重名时添加时间戳），然后链接仓库中的 `.zshrc`；
6. 询问是否安装 Meslo Nerd Font。

如需更改仓库目录，可在运行前设置 `SHELL_CONFIG_DIR`。完成后重启终端，或运行 `exec zsh`。

在 HPC 集群上，脚本会先询问是否拥有 `sudo` 权限，然后检查 `curl`、`git`、`unzip` 和 `zsh`。如果没有 `sudo` 且只有 `zsh` 缺失，脚本可以在用户目录 `~/.local`（或 `$SHELL_CONFIG_PREFIX`）下自行编译 ncurses 和 zsh，不会修改系统文件。脚本需要编译器和 `make`；如有需要，请先通过集群的 module 加载它们。安装结束时会显示实际的 `zsh` 路径。其他缺失的工具需要通过集群环境或管理员提供。

安装后的相关文件位置：

- 仓库：`~/Documents/GitHub/ShellConfig`（或 `$SHELL_CONFIG_DIR`）
- Zsh 配置：`~/.zshrc` → 仓库中的 `.zshrc`
- Oh My Posh 主题：`~/.config/oh-my-posh/jinli.omp.json` → 仓库中的 `jinli.omp.json`
- 独立 Zsh 插件：`~/.local/share/zsh/plugins`（如果已有 Oh My Zsh，则位于其自定义插件目录）

### Windows PowerShell

以普通用户打开 PowerShell 并运行：

```powershell
Set-ExecutionPolicy -Scope Process Bypass
Invoke-WebRequest https://raw.githubusercontent.com/jin-li/ShellConfig/main/install-oh-my-posh.ps1 -OutFile install-oh-my-posh.ps1
.\install-oh-my-posh.ps1
```

PowerShell 脚本通过 WinGet 安装 Oh My Posh（必要时也安装 Git），将仓库克隆到 `Documents\GitHub\ShellConfig`，链接同一个锦鲤主题，备份已有 PowerShell Profile，添加提示符初始化命令，并询问是否安装 Meslo 字体。创建符号链接可能需要开启 Windows 开发者模式，或使用管理员 PowerShell。

安装后，请在终端配置中选择 **MesloLGM Nerd Font**。如果使用 WSL，请在 WSL 内运行 Linux 脚本，但字体需要安装并配置在 Windows 宿主系统中。

PowerShell 配置文件通常位于 `$PROFILE`（例如 `Documents\PowerShell\Microsoft.PowerShell_profile.ps1`）。主题链接位于 `~\.config\oh-my-posh\jinli.omp.json`，仓库位于 `Documents\GitHub\ShellConfig`。

## Neovim 配置

LazyVim 与 Oh My Posh 保持为两个独立的安装步骤：Oh My Posh 配置 Shell 提示符，LazyVim 替换 Neovim 配置并下载编辑器插件。这样只使用提示符时不需要安装 Neovim，也不会在配置 Shell 时修改编辑器文件。

当前 LazyVim starter 要求 Neovim 版本不低于 0.11.2。安装脚本不会卸载 Vim 或旧版 Neovim；如果版本过低会提示升级并退出。脚本会在克隆 starter 前备份已有的 Neovim 配置和数据：

```sh
curl -fsSLO https://raw.githubusercontent.com/jin-li/ShellConfig/main/install_LazyVim.sh
chmod +x install_LazyVim.sh
./install_LazyVim.sh
```

在 HPC 上，此脚本同样会先询问 `sudo` 并检查 `git` 和 `nvim`。未经确认不会执行特权安装。如果没有 `sudo` 且缺少依赖，请通过集群 module 加载，或先在用户目录安装后再重新运行。

第一次启动 `nvim` 时会自动下载 LazyVim 插件，启动后请运行 `:checkhealth`。旧版 `.vimrc` 与 LazyVim 相互独立；其中的 Vundle 插件只有在安装 Vundle 后才会加载。为了获得更好的色彩和 Nerd Font 显示效果，macOS 推荐使用 iTerm2，Windows 推荐使用 Windows Terminal。

安装后的编辑器文件位置：

- LazyVim 配置：`~/.config/nvim`
- Neovim 数据：`~/.local/share/nvim`
- Neovim 状态：`~/.local/state/nvim`
- Neovim 缓存：`~/.cache/nvim`
- Vim 配置：`~/.vimrc` → 仓库中的 `.vimrc`（仓库存在时创建；原文件会备份为 `~/.vimrc-pre-lazyvim`）
