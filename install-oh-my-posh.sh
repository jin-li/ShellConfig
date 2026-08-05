#!/usr/bin/env bash

set -Eeuo pipefail

REPO_URL="https://github.com/jin-li/ShellConfig.git"
REPO_DIR="${SHELL_CONFIG_DIR:-$HOME/Documents/GitHub/ShellConfig}"
POSH_DIR="$HOME/.config/oh-my-posh"
PLUGIN_DIR="$HOME/.local/share/zsh/plugins"
PLUGIN_LOCATION=""

log() { printf '\n==> %s\n' "$*"; }
die() { printf 'Error: %s\n' "$*" >&2; exit 1; }

if [[ ${EUID:-$(id -u)} -eq 0 ]]; then
  die "Run this script as your normal user, not as root or with sudo."
fi

install_linux_dependencies() {
  # shellcheck disable=SC1091
  . /etc/os-release
  case "${ID:-}" in
    ubuntu|debian|pop|deepin|linuxmint)
      sudo apt-get update
      sudo apt-get install -y curl git zsh unzip
      ;;
    fedora|rhel|centos|rocky|almalinux)
      sudo dnf install -y curl git zsh unzip
      ;;
    arch|manjaro|endeavouros|garuda|artix)
      sudo pacman -Syu --needed --noconfirm curl git zsh unzip
      ;;
    opensuse*|sles)
      sudo zypper --non-interactive install curl git zsh unzip
      ;;
    *) die "Unsupported Linux distribution: ${PRETTY_NAME:-${ID:-unknown}}" ;;
  esac
}

install_oh_my_posh() {
  if [[ $(uname -s) == Darwin ]]; then
    command -v brew >/dev/null 2>&1 || die "Homebrew is required on macOS: https://brew.sh"
    command -v git >/dev/null 2>&1 || brew install git
    command -v zsh >/dev/null 2>&1 || brew install zsh
    if command -v oh-my-posh >/dev/null 2>&1; then
      brew upgrade oh-my-posh 2>/dev/null || true
    else
      brew install jandedobbeleer/oh-my-posh/oh-my-posh
    fi
  elif [[ -f /etc/os-release ]]; then
    install_linux_dependencies
    if ! command -v oh-my-posh >/dev/null 2>&1; then
      log "Installing Oh My Posh"
      curl -fsSL https://ohmyposh.dev/install.sh | bash -s
      export PATH="$HOME/.local/bin:$HOME/bin:$PATH"
    fi
  else
    die "Only macOS and Linux are supported by this script."
  fi
  command -v oh-my-posh >/dev/null 2>&1 || die "Oh My Posh was installed but is not on PATH. Add ~/.local/bin or ~/bin to PATH and rerun."
}

clone_or_update() {
  log "Installing ShellConfig in $REPO_DIR"
  mkdir -p "$(dirname "$REPO_DIR")"
  if [[ -d "$REPO_DIR/.git" ]]; then
    git -C "$REPO_DIR" pull --ff-only
  elif [[ -e "$REPO_DIR" ]]; then
    die "$REPO_DIR exists but is not a Git checkout. Move it or set SHELL_CONFIG_DIR."
  else
    git clone "$REPO_URL" "$REPO_DIR"
  fi
}

clone_plugin() {
  local url=$1 destination=$2
  if [[ -d "$destination/.git" ]]; then
    git -C "$destination" pull --ff-only
  elif [[ -e "$destination" ]]; then
    printf 'Skipping existing non-Git path: %s\n' "$destination"
  else
    git clone --depth=1 "$url" "$destination"
  fi
}

install_plugins() {
  log "Installing Zsh plugins"
  if [[ -f "$HOME/.oh-my-zsh/oh-my-zsh.sh" ]]; then
    local custom_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins"
    PLUGIN_LOCATION="$custom_dir"
    mkdir -p "$custom_dir"
    clone_plugin https://github.com/zsh-users/zsh-autosuggestions.git "$custom_dir/zsh-autosuggestions"
    clone_plugin https://github.com/zdharma-continuum/fast-syntax-highlighting.git "$custom_dir/fast-syntax-highlighting"
  else
    PLUGIN_LOCATION="$PLUGIN_DIR"
    mkdir -p "$PLUGIN_DIR"
    clone_plugin https://github.com/zsh-users/zsh-autosuggestions.git "$PLUGIN_DIR/zsh-autosuggestions"
    clone_plugin https://github.com/zdharma-continuum/fast-syntax-highlighting.git "$PLUGIN_DIR/fast-syntax-highlighting"
  fi
}

link_configs() {
  log "Linking the Jinli theme and Zsh configuration"
  mkdir -p "$POSH_DIR"
  ln -sfn "$REPO_DIR/jinli.omp.json" "$POSH_DIR/jinli.omp.json"

  if [[ -e "$HOME/.zshrc" || -L "$HOME/.zshrc" ]]; then
    if [[ $(readlink "$HOME/.zshrc" 2>/dev/null || true) != "$REPO_DIR/.zshrc" ]]; then
      local backup="$HOME/.zshrc-pre-oh-my-posh-jinli"
      [[ ! -e "$backup" && ! -L "$backup" ]] || backup="$backup-$(date +%Y%m%d-%H%M%S)"
      mv "$HOME/.zshrc" "$backup"
      printf 'Previous .zshrc moved to %s\n' "$backup"
    else
      return
    fi
  fi
  ln -s "$REPO_DIR/.zshrc" "$HOME/.zshrc"
}

install_font() {
  printf '\nInstall the Meslo Nerd Font used by the Jinli theme? [y/N] '
  read -r answer
  case "$answer" in
    y|Y|yes|YES|Yes)
      oh-my-posh font install meslo
      printf 'Configure your terminal to use "MesloLGM Nerd Font".\n'
      ;;
    *) printf 'Skipping font installation.\n' ;;
  esac
}

install_oh_my_posh
clone_or_update
install_plugins
link_configs
install_font

log "Installation complete"
printf 'Oh My Posh: %s\n' "$(oh-my-posh version)"
printf '\nConfiguration summary:\n'
printf '  Repository:     %s\n' "$REPO_DIR"
printf '  Theme:          %s -> %s\n' "$POSH_DIR/jinli.omp.json" "$REPO_DIR/jinli.omp.json"
printf '  Zsh config:     %s -> %s\n' "$HOME/.zshrc" "$REPO_DIR/.zshrc"
printf '  Zsh plugins:    %s\n' "$PLUGIN_LOCATION"
printf '  Font:           MesloLGM Nerd Font (if selected)\n'
printf '\nRestart your terminal or run: exec zsh\n'
