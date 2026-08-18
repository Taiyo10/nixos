{ config, lib, pkgs, ... }:

let
  color = config.lib.stylix.colors.base0D;
in
{
  home.activation.openrgbStylix =
    lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      ${pkgs.openrgb}/bin/openrgb \
        --mode direct \
        --color ${color} || true
    '';
}
