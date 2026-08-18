{ config, lib, pkgs,... }:

let
  colors = config.lib.stylix.colors;

  terminalPalette = {
    normal = {
      black   = colors.withHashtag.base00;
      red     = colors.withHashtag.base08;
      green   = colors.withHashtag.base0B;
      yellow  = colors.withHashtag.base0A;
      blue    = colors.withHashtag.base0D;
      magenta = colors.withHashtag.base0E;
      cyan    = colors.withHashtag.base0C;
      white   = colors.withHashtag.base05;
    };

    bright = {
      black   = colors.withHashtag.base03;
      red     = colors.withHashtag.base08;
      green   = colors.withHashtag.base0B;
      yellow  = colors.withHashtag.base0A;
      blue    = colors.withHashtag.base0D;
      magenta = colors.withHashtag.base0E;
      cyan    = colors.withHashtag.base0C;
      white   = colors.withHashtag.base07;
    };

    foreground = colors.withHashtag.base05;
    background = colors.withHashtag.base00;

    selectionFg = colors.withHashtag.base00;
    selectionBg = colors.withHashtag.base05;

    cursorText = colors.withHashtag.base00;
    cursor = colors.withHashtag.base05;
  };
in
{
  xdg.configFile."noctalia/palettes/Stylix.json".text =
    builtins.toJSON {
      dark = {
        mPrimary = colors.withHashtag.base0D;
        mOnPrimary = colors.withHashtag.base00;

        mSecondary = colors.withHashtag.base0E;
        mOnSecondary = colors.withHashtag.base00;

        mTertiary = colors.withHashtag.base0C;
        mOnTertiary = colors.withHashtag.base00;

        mError = colors.withHashtag.base08;
        mOnError = colors.withHashtag.base00;

        mSurface = colors.withHashtag.base00;
        mOnSurface = colors.withHashtag.base05;

        mSurfaceVariant = colors.withHashtag.base01;
        mOnSurfaceVariant = colors.withHashtag.base04;

        mOutline = colors.withHashtag.base03;
        mShadow = colors.withHashtag.base00;

        mHover = colors.withHashtag.base02;
        mOnHover = colors.withHashtag.base05;

        terminal = terminalPalette;
      };

      light = {
        mPrimary = colors.withHashtag.base0D;
        mOnPrimary = colors.withHashtag.base00;

        mSecondary = colors.withHashtag.base0E;
        mOnSecondary = colors.withHashtag.base00;

        mTertiary = colors.withHashtag.base0C;
        mOnTertiary = colors.withHashtag.base00;

        mError = colors.withHashtag.base08;
        mOnError = colors.withHashtag.base00;

        mSurface = colors.withHashtag.base07;
        mOnSurface = colors.withHashtag.base00;

        mSurfaceVariant = colors.withHashtag.base06;
        mOnSurfaceVariant = colors.withHashtag.base02;

        mOutline = colors.withHashtag.base03;
        mShadow = colors.withHashtag.base00;

        mHover = colors.withHashtag.base06;
        mOnHover = colors.withHashtag.base00;

        terminal = terminalPalette;
      };
    };

    home.activation.updateNoctaliaWallpaper =
      lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        ${pkgs.noctalia}/bin/noctalia msg wallpaper-set "${config.stylix.image}" || true
      '';

    home.activation.reloadNoctalia =
      lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        ${pkgs.noctalia}/bin/noctalia msg config-reload || true
      '';
}
