{ pkgs, ... }:

let
  qidiStudio = pkgs.appimageTools.wrapType2 {
    pname = "qidi-studio";
    version = "2.07.02.60";

    src = pkgs.fetchurl {
      url = "https://github.com/QIDITECH/QIDIStudio/releases/download/v2.07.02.60/QIDIStudio_v02.07.02.60_Ubuntu24.AppImage";
      hash = "sha256-1H0rLI3V8W1I+KIbolQg/Wat9WsACMy1RIdyU0s8seg=";
    };

    extraPkgs = pkgs: with pkgs; [
      libsoup_3
      webkitgtk_4_1
      gtk3
      glib
      cairo
      gdk-pixbuf
      pango
      libsecret
      curl
      openssl
      dbus
      libGL
      libxkbcommon
      wayland
    ];

    extraInstallCommands = ''
      install -Dm644 ${pkgs.writeText "qidi-studio.desktop" ''
        [Desktop Entry]
        Name=QIDI Studio
        Comment=QIDI 3D Printer Slicer
        Exec=env SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt WEBKIT_DISABLE_COMPOSITING_MODE=0 WEBKIT_DISABLE_DMABUF_RENDERER=0 qidi-studio
        Type=Application
        Terminal=false
        Categories=Graphics;Engineering;
      ''} $out/share/applications/qidi-studio.desktop
    '';
  };
in
{
  environment.systemPackages = [
    qidiStudio
  ];
}
