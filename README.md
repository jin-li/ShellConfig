Language: 🇺🇸 | [🇨🇳](./README.zh-cn.md)

# ShellConfig

Shared shell and Neovim configuration for macOS, Linux, and Windows.

## Shell configuration

- Prompt: [Oh My Posh](https://ohmyposh.dev/) with the Koi-fish (锦鲤) [`jinli.omp.json`](./jinli.omp.json) theme
- Shell: Zsh on macOS/Linux; PowerShell on Windows
- Zsh plugins: [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions) and [fast-syntax-highlighting](https://github.com/zdharma-continuum/fast-syntax-highlighting)
- Oh My Zsh is optional. If it is already installed, the installer puts the plugins in its custom plugin directory. Otherwise, it installs the plugins under `~/.local/share/zsh/plugins` and does not install Oh My Zsh.

The supplied `.zshrc` does not require Homebrew, Oh My Zsh, or Neovim. It enables each optional integration only when it is available.

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

Set `SHELL_CONFIG_DIR` before running the script to use a different checkout directory. Restart the terminal afterward, or run `exec zsh`.

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

The PowerShell installer uses WinGet to install Oh My Posh (and Git if needed), clones the repository into `Documents\GitHub\ShellConfig`, links the same Jinli theme, backs up the existing PowerShell profile, adds the prompt initialization, and offers to install Meslo. Creating symbolic links may require Windows Developer Mode or an elevated PowerShell session.

After installation, select **MesloLGM Nerd Font** in the terminal profile. For WSL, run the Linux installer inside WSL but install/configure the font on Windows.

The PowerShell profile is normally stored at `$PROFILE` (for example, `Documents\PowerShell\Microsoft.PowerShell_profile.ps1`). The theme link is `~\.config\oh-my-posh\jinli.omp.json`; the repository is `Documents\GitHub\ShellConfig`.

## Neovim configuration

LazyVim is intentionally a separate installer from Oh My Posh: Oh My Posh configures the shell prompt, while LazyVim replaces the Neovim configuration and downloads editor plugins. Keeping them separate lets you use the prompt without Neovim and avoids changing editor files during shell setup.

The current LazyVim starter requires Neovim 0.11.2 or newer. The installer does not remove Vim or an older Neovim; it stops with an upgrade message if the installed version is too old. It backs up existing Neovim data before cloning the starter:

```sh
curl -fsSLO https://raw.githubusercontent.com/jin-li/ShellConfig/main/install_LazyVim.sh
chmod +x install_LazyVim.sh
./install_LazyVim.sh
```

The first `nvim` launch downloads the LazyVim plugins. Run `:checkhealth` after startup. The legacy `.vimrc` is independent of LazyVim; its Vundle plugins are optional and are loaded only when Vundle is installed. A modern terminal such as iTerm2 on macOS or Windows Terminal on Windows is recommended for good color and Nerd Font support.

After installation, the editor files are located at:

- LazyVim configuration: `~/.config/nvim`
- Neovim data: `~/.local/share/nvim`
- Neovim state: `~/.local/state/nvim`
- Neovim cache: `~/.cache/nvim`
- Vim configuration: `~/.vimrc` → repository `.vimrc` (when the repository is present; any previous file is backed up as `~/.vimrc-pre-lazyvim`)
