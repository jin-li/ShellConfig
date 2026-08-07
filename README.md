Language: 🇺🇸 | [🇨🇳](./README.zh-cn.md)

# ShellConfig

Shared shell and Neovim configuration for macOS, Linux, and Windows.

## Shell configuration

- Prompt: [Oh My Posh](https://ohmyposh.dev/) with the Koi-fish (锦鲤) [`jinli.omp.json`](./jinli.omp.json) theme
- Shell: Zsh on macOS/Linux; PowerShell on Windows
- Zsh plugins: [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions) and [fast-syntax-highlighting](https://github.com/zdharma-continuum/fast-syntax-highlighting)
- Oh My Zsh is optional. If it is already installed, the installer puts the plugins in its custom plugin directory. Otherwise, it installs the plugins under `~/.local/share/zsh/plugins` and does not install Oh My Zsh.

The supplied `.zshrc` does not require Homebrew, Oh My Zsh, or Neovim. It enables each optional integration only when it is available.

Zsh completion is case-insensitive. For example, `cat rea` followed by Tab can
complete to `README.md`.

Zsh also keeps a directory stack: `AUTO_PUSHD` records directories visited by
`cd`, and `PUSHD_IGNORE_DUPS` avoids repeated entries. Use `cd -<number>` to
select a numbered previous directory, or inspect the stack with `dirs -v`.

### NixOS

This repository also exposes a NixOS module through its flake. The module
installs Zsh, Oh My Posh, the Zsh plugins, and Meslo Nerd Font, and imports the
shared `.zshrc` and `jinli.omp.json` declaratively. It adapts the installer
paths used by the shared `.zshrc` to NixOS package and `/etc` paths.

Add the repository as a flake input:

```nix
inputs.shell-config.url = "github:jin-li/ShellConfig";
```

Import the module and enable it in a NixOS configuration:

```nix
modules = [
  inputs.shell-config.nixosModules.default
];

programs.shellConfig.enable = true;
users.users.<username>.shell = pkgs.zsh;
```

Then rebuild the selected host:

```bash
sudo nixos-rebuild switch --flake .#<host>
exec zsh
```

The module does not manage `~/.zshrc.local`; use that file for private,
machine-specific environment variables and aliases. Configure the terminal
emulator to use **MesloLGM Nerd Font** for the theme icons.

### Local Zsh configuration

The shared `.zshrc` sources `~/.zshrc.local` first when that file exists. Keep machine-specific settings there—private environment variables, workstation-only aliases, cluster module setup, and local tool paths—while keeping portable configuration in this repository. `~/.zshrc.local` is intentionally not managed or symlinked by the installer.

For example:

```zsh
export PATH="$HOME/.local/bin:$PATH"
alias connect-hpc='ssh user@example.org'
```

After installation, the shared configuration is `~/.zshrc` → repository `.zshrc`; the optional local configuration is `~/.zshrc.local`.

### macOS and Linux

Supported Linux families include Debian/Ubuntu, Fedora/RHEL, Arch, and openSUSE. On macOS, install [Homebrew](https://brew.sh/) first.

Run the installer as a normal user, not with `sudo`:

```sh
curl -fsSLO https://raw.githubusercontent.com/jin-li/ShellConfig/main/install-oh-my-posh.sh
chmod +x install-oh-my-posh.sh
./install-oh-my-posh.sh
```

The installer:

1. Installs Zsh dependencies and Oh My Posh.
2. Clones or updates this repository at `~/Documents/GitHub/ShellConfig`.
3. Installs the Zsh plugins, with or without Oh My Zsh.
4. Links `jinli.omp.json` to `~/.config/oh-my-posh/jinli.omp.json`.
5. Moves an existing `~/.zshrc` to `~/.zshrc-pre-oh-my-posh-jinli` (adding a timestamp if necessary), then links this repository's `.zshrc`.
6. Offers to install the Meslo Nerd Font.

After Oh My Posh is installed, the script checks whether its executable directory is available in the current `PATH`. If not, it adds an idempotent `export PATH=...` entry to the user-managed `~/.zshrc.local`, so future Zsh sessions can find Oh My Posh without changing the shared `.zshrc`.

Set `SHELL_CONFIG_DIR` before running the script to use a different checkout directory. Restart the terminal afterward, or run `exec zsh`.

On an HPC system, the script asks about `sudo` before installing anything. It first checks for `curl`, `git`, `unzip`, and `zsh`. If `sudo` is unavailable and only `zsh` is missing, it can build ncurses and zsh locally under `~/.local` (or `$SHELL_CONFIG_PREFIX`) without changing system files. The script checks for a compiler and `make`; load those through your cluster's modules first if needed. The final summary reports the resulting `zsh` executable path. Other missing tools must be provided by the cluster or installed by an administrator.

After installation, the relevant files are located at:

- Repository: `~/Documents/GitHub/ShellConfig` (or `$SHELL_CONFIG_DIR`)
- Zsh configuration: `~/.zshrc` → repository `.zshrc`
- Oh My Posh theme: `~/.config/oh-my-posh/jinli.omp.json` → repository `jinli.omp.json`
- Standalone Zsh plugins: `~/.local/share/zsh/plugins` (or the Oh My Zsh custom plugin directory when Oh My Zsh exists)

### Windows PowerShell

Open PowerShell as your normal user and run:

```powershell
Set-ExecutionPolicy -Scope Process Bypass
Invoke-WebRequest https://raw.githubusercontent.com/jin-li/ShellConfig/main/install-oh-my-posh.ps1 -OutFile install-oh-my-posh.ps1
.\install-oh-my-posh.ps1
```

The PowerShell installer uses WinGet to install Oh My Posh (and Git if needed), skipping tools that are already available. It clones the repository into `Documents\GitHub\ShellConfig`, backs up the existing PowerShell profile, and creates a fresh profile containing the Oh My Posh executable path and initialization command. It checks for Meslo before offering to install it.

After installation, select **MesloLGM Nerd Font** in the terminal profile. For WSL, run the Linux installer inside WSL but install/configure the font on Windows.

The PowerShell profile is normally stored at `$PROFILE` (for example, `Documents\PowerShell\Microsoft.PowerShell_profile.ps1`). Windows uses the theme directly from `Documents\GitHub\ShellConfig\jinli.omp.json`; no `~\.config` theme link is created. The generated profile adds Oh My Posh's installation directory to `$env:Path` before initializing the theme.

## Neovim configuration

LazyVim is intentionally a separate installer from Oh My Posh: Oh My Posh configures the shell prompt, while LazyVim replaces the Neovim configuration and downloads editor plugins. Keeping them separate lets you use the prompt without Neovim and avoids changing editor files during shell setup.

The current LazyVim starter requires Neovim 0.11.2 or newer. The installer does not remove Vim or an older Neovim; it stops with an upgrade message if the installed version is too old. It backs up existing Neovim data before cloning the starter:

```sh
curl -fsSLO https://raw.githubusercontent.com/jin-li/ShellConfig/main/install_LazyVim.sh
chmod +x install_LazyVim.sh
./install_LazyVim.sh
```

On HPC systems, this installer also asks about `sudo` and checks for `git` and `nvim` first. It never attempts a privileged installation without confirmation. If either dependency is missing without `sudo`, load it through the cluster's environment modules or install it in your user space before rerunning.

The first `nvim` launch downloads the LazyVim plugins. Run `:checkhealth` after startup. The legacy `.vimrc` is independent of LazyVim; its Vundle plugins are optional and are loaded only when Vundle is installed. A modern terminal such as iTerm2 on macOS or Windows Terminal on Windows is recommended for good color and Nerd Font support.

After installation, the editor files are located at:

- LazyVim configuration: `~/.config/nvim`
- Neovim data: `~/.local/share/nvim`
- Neovim state: `~/.local/state/nvim`
- Neovim cache: `~/.cache/nvim`
- Vim configuration: `~/.vimrc` → repository `.vimrc` (when the repository is present; any previous file is backed up as `~/.vimrc-pre-lazyvim`)
