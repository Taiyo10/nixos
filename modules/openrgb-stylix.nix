{ config, lib, pkgs, ... }:

let
  color = config.lib.stylix.colors.base0D;
  device = "ASUS PRIME B650M-A WIFI II";

  applyRgb = pkgs.writeShellScriptBin "apply-stylix-rgb" ''
    ${pkgs.openrgb}/bin/openrgb \
      --nodetect \
      --device ${lib.escapeShellArg device} \
      --mode direct \
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
