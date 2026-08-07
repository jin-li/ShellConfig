#!/usr/bin/env bash

set -Eeuo pipefail

REPO_URL="https://github.com/jin-li/ShellConfig.git"
REPO_DIR="${SHELL_CONFIG_DIR:-$HOME/Documents/GitHub/ShellConfig}"
POSH_DIR="$HOME/.config/oh-my-posh"
PLUGIN_DIR="$HOME/.local/share/zsh/plugins"
PLUGIN_LOCATION=""
LOCAL_PREFIX="${SHELL_CONFIG_PREFIX:-$HOME/.local}"
BUILD_ROOT="${SHELL_CONFIG_BUILD_DIR:-$HOME/.cache/shellconfig-build}"
HAS_SUDO=0

log() { printf '\n==> %s\n' "$*"; }
die() { printf 'Error: %s\n' "$*" >&2; exit 1; }

if [[ ${EUID:-$(id -u)} -eq 0 ]]; then
  die "Run this script as your normal user, not as root or with sudo."
fi

ask_sudo() {
  printf 'Do you have sudo privileges on this machine? [Y/n] '
  read -r answer
  if [[ ! "$answer" =~ ^([nN][oO]?|[fF])$ ]] && command -v sudo >/dev/null 2>&1 && sudo -v; then
    HAS_SUDO=1
  else
    printf 'Continuing without sudo.\n'
  fi
}

download_file() {
  local url=$1 destination=$2
  if command -v curl >/dev/null 2>&1; then
    curl -fL --retry 3 "$url" -o "$destination"
  elif command -v wget >/dev/null 2>&1; then
    wget -O "$destination" "$url"
  else
    die "curl or wget is required to download source files."
  fi
}

resolve_oh_my_posh() {
  if command -v oh-my-posh >/dev/null 2>&1; then
    return 0
  fi
  local candidate
  if command -v brew >/dev/null 2>&1; then
    candidate="$(brew --prefix oh-my-posh 2>/dev/null)/bin/oh-my-posh"
    if [[ -x "$candidate" ]]; then
      export PATH="$(dirname "$candidate"):$PATH"
      return 0
    fi
  fi
  for candidate in \
    "$LOCAL_PREFIX/bin/oh-my-posh" \
    "$HOME/.local/bin/oh-my-posh" \
    "$HOME/bin/oh-my-posh"; do
    if [[ -x "$candidate" ]]; then
      export PATH="$(dirname "$candidate"):$PATH"
      return 0
    fi
  done
  return 1
}

ensure_oh_my_posh_path() {
  resolve_oh_my_posh || die "Oh My Posh was installed but its executable could not be located."
  local executable_dir
  executable_dir=$(dirname "$(command -v oh-my-posh)")
  export PATH="$executable_dir:$PATH"

  local local_config="$HOME/.zshrc.local"
  if [[ ! -f "$local_config" ]] || ! grep -Fq "$executable_dir" "$local_config"; then
    {
      printf '\n# Added by ShellConfig: keep Oh My Posh available in interactive Zsh.\n'
      printf 'export PATH="%s:$PATH"\n' "$executable_dir"
    } >> "$local_config"
    printf 'Added Oh My Posh directory to %s\n' "$local_config"
  else
    printf 'Oh My Posh directory is already configured in %s\n' "$local_config"
  fi
}

build_ncurses() {
  log "Building ncurses in $LOCAL_PREFIX"
  local archive="$BUILD_ROOT/ncurses.tar.gz"
  mkdir -p "$BUILD_ROOT"
  download_file "https://invisible-island.net/archives/ncurses/ncurses.tar.gz" "$archive"
  tar -xzf "$archive" -C "$BUILD_ROOT"
  local source_dir
  source_dir=$(find "$BUILD_ROOT" -maxdepth 1 -type d -name 'ncurses-*' | sort | tail -n1)
  [[ -n "$source_dir" ]] || die "Could not find the extracted ncurses source directory."
  (cd "$source_dir" && ./configure --prefix="$LOCAL_PREFIX" --with-shared --without-debug --enable-widec && \
    make -j"$(getconf _NPROCESSORS_ONLN 2>/dev/null || echo 2)" && make install)
}

build_zsh() {
  log "Building zsh in $LOCAL_PREFIX"
  command -v make >/dev/null 2>&1 || die "make is required to build zsh without sudo."
  command -v cc >/dev/null 2>&1 || die "a C compiler (cc) is required to build zsh without sudo."
  mkdir -p "$BUILD_ROOT" "$LOCAL_PREFIX"
  if [[ ! -f "$LOCAL_PREFIX/include/ncurses.h" && ! -f "$LOCAL_PREFIX/include/ncurses/curses.h" ]]; then
    build_ncurses
  fi
  local archive="$BUILD_ROOT/zsh.tar.xz"
  download_file "https://www.zsh.org/pub/zsh-latest.tar.xz" "$archive"
  tar -xJf "$archive" -C "$BUILD_ROOT"
  local source_dir
  source_dir=$(find "$BUILD_ROOT" -maxdepth 1 -type d -name 'zsh-*' | sort | tail -n1)
  [[ -n "$source_dir" ]] || die "Could not find the extracted zsh source directory."
  (cd "$source_dir" && CPPFLAGS="-I$LOCAL_PREFIX/include" LDFLAGS="-L$LOCAL_PREFIX/lib" \
    ./configure --prefix="$LOCAL_PREFIX" && \
    make -j"$(getconf _NPROCESSORS_ONLN 2>/dev/null || echo 2)" && make install)
  export PATH="$LOCAL_PREFIX/bin:$PATH"
  printf 'User-local zsh installed at %s/bin/zsh\n' "$LOCAL_PREFIX"
}

install_linux_dependencies() {
  # shellcheck disable=SC1091
  . /etc/os-release
  local required=(curl git unzip zsh)
  local missing=()
  for command_name in "${required[@]}"; do
    command -v "$command_name" >/dev/null 2>&1 || missing+=("$command_name")
  done
  [[ ${#missing[@]} -eq 0 ]] && return

  if (( HAS_SUDO )); then
    case "${ID:-}" in
      ubuntu|debian|pop|deepin|linuxmint)
        sudo apt-get update
        sudo apt-get install -y "${missing[@]}"
        ;;
      fedora|rhel|centos|rocky|almalinux)
        sudo dnf install -y "${missing[@]}"
        ;;
      arch|manjaro|endeavouros|garuda|artix)
        sudo pacman -Syu --needed --noconfirm "${missing[@]}"
        ;;
      opensuse*|sles)
        sudo zypper --non-interactive install "${missing[@]}"
        ;;
      *) die "Unsupported Linux distribution: ${PRETTY_NAME:-${ID:-unknown}}" ;;
    esac
  else
    local missing_without_zsh=()
    for command_name in "${missing[@]}"; do
      [[ "$command_name" == zsh ]] || missing_without_zsh+=("$command_name")
    done
    if [[ ${#missing_without_zsh[@]} -gt 0 ]]; then
      die "Missing dependencies without sudo: ${missing_without_zsh[*]}. Install them or load them with your HPC modules, then rerun."
    fi
    printf 'zsh is missing and sudo is unavailable. Build zsh and ncurses under %s? [y/N] ' "$LOCAL_PREFIX"
    read -r answer
    [[ "$answer" =~ ^[Yy]([Ee][Ss])?$ ]] || die "zsh is required. Rerun and choose the local zsh build, or load zsh from your HPC environment."
    build_zsh
  fi
}

install_oh_my_posh() {
  if [[ $(uname -s) == Darwin ]]; then
    command -v brew >/dev/null 2>&1 || die "Homebrew is required on macOS: https://brew.sh"
    command -v git >/dev/null 2>&1 || brew install git
    command -v zsh >/dev/null 2>&1 || brew install zsh
    if resolve_oh_my_posh; then
      brew upgrade oh-my-posh 2>/dev/null || true
    else
      brew install jandedobbeleer/oh-my-posh/oh-my-posh
    fi
  elif [[ -f /etc/os-release ]]; then
    install_linux_dependencies
    if ! resolve_oh_my_posh; then
      log "Installing Oh My Posh"
      curl -fsSL https://ohmyposh.dev/install.sh | bash -s
      export PATH="$HOME/.local/bin:$HOME/bin:$PATH"
    fi
  else
    die "Only macOS and Linux are supported by this script."
  fi
  resolve_oh_my_posh || die "Oh My Posh was installed but its executable could not be located. Add ~/.local/bin or ~/bin to PATH and rerun."
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

ask_sudo
install_oh_my_posh
ensure_oh_my_posh_path
clone_or_update
install_plugins
link_configs
install_font

log "Installation complete"
printf 'Oh My Posh: %s\n' "$(oh-my-posh version)"
printf '\nConfiguration summary:\n'
printf '  Repository:     %s\n' "$REPO_DIR"
printf '  Theme:          %s -> %s\n' "$POSH_DIR/jinli.omp.json" "$REPO_DIR/jinli.omp.json"
printf '  Common Zsh:     %s -> %s (GitHub-managed shared config)\n' "$HOME/.zshrc" "$REPO_DIR/.zshrc"
printf '  Local Zsh:      %s (optional, user-managed; create it for machine-specific settings)\n' "$HOME/.zshrc.local"
printf '  Oh My Posh PATH: %s (configured in %s)\n' "$(dirname "$(command -v oh-my-posh)")" "$HOME/.zshrc.local"
printf '  Zsh executable: %s\n' "$(command -v zsh)"
printf '  Zsh plugins:    %s\n' "$PLUGIN_LOCATION"
printf '  Font:           MesloLGM Nerd Font (if selected)\n'
printf '\nRestart your terminal or run: exec zsh\n'
