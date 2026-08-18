{ config, pkgs, inputs, ... }:

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

  programs.kitty.enable = true;

  programs.zen-browser = {
    enable = true;
  };

  stylix.targets.zen-browser = {
    enable = true;
    profileNames = ["default"];
  };
}
