sourcePath: { config, lib, pkgs, ... }:

let
  # The shared .zshrc expects the non-NixOS installer paths. Adapt only those
  # paths; keep the rest of the cross-platform configuration shared upstream.
  shellConfigZshrc = builtins.replaceStrings
    [
      "\"$HOME/.config/oh-my-posh/jinli.omp.json\""
      "\"$HOME/.local/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh\""
      "\"$HOME/.local/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh\""
    ]
    [
      "\"/etc/oh-my-posh/jinli.omp.json\""
      "\"${pkgs.zsh-autosuggestions}/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh\""
      "\"${pkgs.zsh-fast-syntax-highlighting}/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh\""
    ]
    (builtins.readFile (sourcePath + "/.zshrc"));
in
{
  options.programs.shellConfig.enable = lib.mkEnableOption
    "the shared ShellConfig Zsh and Oh My Posh setup";

  config = lib.mkIf config.programs.shellConfig.enable {
    programs.zsh = {
      enable = true;
      interactiveShellInit = shellConfigZshrc;
    };

    environment.etc."oh-my-posh/jinli.omp.json".source =
      sourcePath + "/jinli.omp.json";

    environment.systemPackages = with pkgs; [
      oh-my-posh
      zsh-autosuggestions
      zsh-fast-syntax-highlighting
    ];

    fonts.packages = [ pkgs.nerd-fonts.meslo-lg ];
  };
}
