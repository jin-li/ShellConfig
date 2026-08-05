# Machine-specific/local configuration
[[ -f $HOME/.zshrc.local ]] && source $HOME/.zshrc.local

# Oh My Zsh is optional. When present, it manages the two plugins below.
if [[ -f "$HOME/.oh-my-zsh/oh-my-zsh.sh" ]]; then
  export ZSH="$HOME/.oh-my-zsh"
  plugins=(zsh-autosuggestions fast-syntax-highlighting)
  source "$ZSH/oh-my-zsh.sh"
else
  [[ -f "$HOME/.local/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" ]] && \
    source "$HOME/.local/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi

export POSH_CATPPUCCIN_FLAVOR=macchiato
if command -v oh-my-posh >/dev/null 2>&1; then
  eval "$(oh-my-posh init zsh --config "$HOME/.config/oh-my-posh/jinli.omp.json")"
fi

# Syntax highlighting must load after other ZLE plugins.
if [[ ! -f "$HOME/.oh-my-zsh/oh-my-zsh.sh" && \
      -f "$HOME/.local/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh" ]]; then
  source "$HOME/.local/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"
fi

if command -v nvim >/dev/null 2>&1; then
  export EDITOR=nvim
  alias vi=nvim
elif command -v vim >/dev/null 2>&1; then
  export EDITOR=vim
fi
