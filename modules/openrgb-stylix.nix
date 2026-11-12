{ config, lib, pkgs, ... }:

let
  color = config.lib.stylix.colors.base0D;
  devices = [
    "ENE DRAM"
    "ASUS PRIME B650M-A WIFI II"
  ];

  applyRgb = pkgs.writeShellScriptBin "apply-stylix-rgb" ''
    for device in ${lib.escapeShellArgs devices}; do
      ${pkgs.openrgb}/bin/openrgb \
        --nodetect \
        --device "$device" \
        --mode direct \
        --color ${color} || true
    done
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
