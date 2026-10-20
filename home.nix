{ config, pkgs, inputs, ... }:

let
  rebuild = pkgs.writeShellApplication {
    name = "rebuild";
    runtimeInputs = with pkgs; [
      coreutils
      git
      nixos-rebuild
      openssh
    ];
    text = ''
      config_dir="$HOME/.nixos"

      sudo nixos-rebuild switch --flake "$config_dir#nixos"

      git -C "$config_dir" add -A
      if git -C "$config_dir" diff --cached --quiet; then
        printf 'No Git changes to commit.\n'
        exit 0
      fi

      git -C "$config_dir" commit -m "NixOS rebuild $(date '+%Y-%m-%d %H:%M')"
      git -C "$config_dir" push
    '';
  };
in
{
  imports = [
    ./modules/noctalia-stylix.nix
    inputs.zen-browser.homeModules.default
    ./modules/openrgb-stylix.nix
  ];

  home.username = "teo";
  home.homeDirectory = "/home/teo";

  home.stateVersion = "26.05";

  programs.home-manager.enable = true;

  programs.vesktop = {
    enable = true;
  };

  home.packages = with pkgs; [
    prismlauncher
    obsidian
    thunar
    opencode
    rebuild
  ];

  programs.kitty.enable = true;

  programs.zen-browser = {
    enable = true;
  };

  stylix.targets.zen-browser = {
    enable = true;
    profileNames = ["default"];
  };
}
