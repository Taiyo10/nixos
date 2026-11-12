{ config, lib, pkgs, ... }:

let
  color = config.lib.stylix.colors.base0D;

  applyRgb = pkgs.writeShellScriptBin "apply-stylix-rgb" ''
    ${pkgs.openrgb}/bin/openrgb \
      --nodetect \
      --color ${color} || true
  '';
in
{
  # Apply immediately whenever Home Manager activates/rebuilds
  home.activation.openrgbStylix =
    lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      ${applyRgb}/bin/apply-stylix-rgb
    '';

  # Makes `apply-stylix-rgb` available as a normal command
  home.packages = [
    applyRgb
  ];
}
