# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      inputs.noctalia.nixosModules.default
      #inputs.xremap.nixosModules.default
      ./modules/stylix.nix
      ./modules/qidi-studio.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Toronto";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_CA.UTF-8";

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  # Enable auto hyprland
  services.greetd = {
   enable = true;
  
    settings = {
      initial_session = {
        command = "uwsm start hyprland-uwsm.desktop";
        user = "teo";
      };
  
     default_session = {
        command = "uwsm start hyprland-uwsm.desktop";
        user = "teo";
      };
    };
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."teo" = {
    isNormalUser = true;
    home = "/home/teo";
    description = "Teo";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      kdePackages.kate
    #  thunderbird
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;

  environment.sessionVariables = {
    XDG_DATA_DIRS = [
      "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}"
      "${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}"
    ];
  };

  #ME ZONE-------------------------------------------------------------------------

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    extraSpecialArgs = {inherit inputs;};

    users.teo= import ./home.nix;
  };

  programs.steam = {
    enable = true;
  };

  programs.gamemode.enable = true;


  programs.noctalia = {
    enable = true;
    recommendedServices.enable = true;
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
  
    open = true;
    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };

      amdgpuBusId = "PCI:12@0:0:0";
      nvidiaBusId = "PCI:1@0:0:0";
    };
  };

  services.hardware.openrgb.enable = true;

  #services.xremap = {
  #  enable = true;
  #  withWlroots = true;
  #  userName = "Teo";
  #};


  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nix.settings.extra-substituters = [
   "https://ros.cachix.org"
   "https://attic.iid.ciirc.cvut.cz/ros"
  ];
  
  nix.settings.extra-trusted-public-keys = [
   "ros.cachix.org-1:dSyZxI8geDCJrwgvCOHDoAfOm5sV1wCPjBkKL+38Rvo="
   "ros:JR95vUYsShSqfA1VTYoFt1Nz6uXasm5QrcOsGry9f6Q="
  ];


  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  #services.displayManager.defaultSession = "hyperland";
  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };
  
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  vim-full
  lf
  hyprland
  waybar
  wofi
  nwg-look
  git
  inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "26.05"; # Did you read the comment?

}
