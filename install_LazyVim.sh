#!/usr/bin/env bash

set -Eeuo pipefail

MIN_NVIM_VERSION="0.11.2"
STARTER_URL="https://github.com/LazyVim/starter.git"
NVIM_CONFIG="$HOME/.config/nvim"

log() { printf '\n==> %s\n' "$*"; }
die() { printf 'Error: %s\n' "$*" >&2; exit 1; }

if [[ ${EUID:-$(id -u)} -eq 0 ]]; then
  die "Run this script as your normal user, not as root or with sudo."
fi

install_dependencies() {
  if [[ $(uname -s) == Darwin ]]; then
    command -v brew >/dev/null 2>&1 || die "Homebrew is required on macOS: https://brew.sh"
    brew install git neovim 2>/dev/null || true
  elif [[ -f /etc/os-release ]]; then
    # shellcheck disable=SC1091
    . /etc/os-release
    case "${ID:-}" in
      ubuntu|debian|pop|deepin|linuxmint)
        sudo apt-get update
        sudo apt-get install -y curl git neovim
        ;;
      fedora|rhel|centos|rocky|almalinux)
        sudo dnf install -y curl git neovim
        ;;
      arch|manjaro|endeavouros|garuda|artix)
        sudo pacman -Syu --needed --noconfirm curl git neovim
        ;;
      opensuse*|sles)
        sudo zypper --non-interactive install curl git neovim
        ;;
      *) die "Unsupported Linux distribution: ${PRETTY_NAME:-${ID:-unknown}}" ;;
    esac
  else
    die "Only macOS and Linux are supported by this script."
  fi
}

version_at_least() {
  local installed=$1
  [[ "$(printf '%s\n' "$MIN_NVIM_VERSION" "$installed" | sort -V | head -n1)" == "$MIN_NVIM_VERSION" ]]
}

install_dependencies
command -v git >/dev/null 2>&1 || die "Git is required but was not found on PATH."
command -v nvim >/dev/null 2>&1 || die "Neovim is required but was not found on PATH."

NVIM_VERSION=$(nvim --version | sed -n '1s/^NVIM v\([^ ]*\).*/\1/p')
[[ -n "$NVIM_VERSION" ]] || die "Could not determine the Neovim version."
if ! version_at_least "$NVIM_VERSION"; then
  die "LazyVim currently requires Neovim >= $MIN_NVIM_VERSION; found $NVIM_VERSION. Upgrade Neovim and rerun."
fi

mkdir -p "$(dirname "$NVIM_CONFIG")"
BACKUP_SUFFIX="pre-lazyvim-$(date +%Y%m%d-%H%M%S)"
backup_path() {
  local path=$1
  if [[ -e "$path" || -L "$path" ]]; then
    local backup="${path}-${BACKUP_SUFFIX}"
    mv "$path" "$backup"
    printf 'Existing Neovim data moved to %s\n' "$backup"
  fi
}

backup_path "$NVIM_CONFIG"
backup_path "$HOME/.local/share/nvim"
backup_path "$HOME/.local/state/nvim"
backup_path "$HOME/.cache/nvim"

log "Installing LazyVim starter"
git clone "$STARTER_URL" "$NVIM_CONFIG"
rm -rf "$NVIM_CONFIG/.git"

log "LazyVim installed"
printf 'Neovim %s is ready. Start nvim to install plugins, then run :checkhealth.\n' "$NVIM_VERSION"
