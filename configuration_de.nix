{ config, pkgs, ... }:

let
  cosmicPackages = import (builtins.fetchTarball "https://github.com/pop-os/cosmic/archive/master.tar.gz") {};
in
{
  imports =
    [ # Include the NixOS hardware configuration
      ./hardware-configuration.nix
    ];

  # Set your desired hostname
  networking.hostName = "nix-os";

  # Set your desired timezone
  time.timeZone = "London";

  # Enable the Cosmic desktop
  services.xserver = {
    enable = true;
    displayManager = {
      cosmic = {
        enable = true;
        defaultSession = "cosmic";
      };
      defaultSession = "cosmic";
    };
    windowManager = {
      cosmic = {
        enable = true;
        package = cosmicPackages.cosmic;
      };
    };
    desktopManager.sessionCommands.cosmic = {
      enable = true;
      exec = "${cosmicPackages.cosmic}/bin/cosmic-session";
    };
  };

  # Set your preferred locale(s)
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.supportedLocales = [ "en_US.UTF-8" ];

  # Configure your users and passwords
  users.users = {
    myuser = {
      isNormalUser = true;
      extraGroups = [ "wheel" ]; # Add your desired user groups
      home = "/home/nixos"; # Set the home directory path
      createHome = true;
      uid = 1000; # Set your desired UID
      shell = "/run/current-system/sw/bin/bash"; # Set your preferred shell
      #hashedPassword = "..."; # Set your hashed password
    };
  };

  # Enable NixOS-specific options
  nix = {
    package = pkgs.nixFlakes; # Use Nix flakes
    extraOptions = ''
      experimental-features = nix-command flakes ca-references
    '';
  };
}
