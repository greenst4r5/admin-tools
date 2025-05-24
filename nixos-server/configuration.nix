# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "server"; # Define your hostname.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  console = {
    keyMap = "fr";
  };

  users.users.inp = {
     isNormalUser = true;
    openssh.authorizedKeys.keys = [
     "key"
    ];
  };

 
  environment.systemPackages = with pkgs; [
    vim 
    curl
    git
    btop
  ];


  # List services that you want to enable:

  # Docker:
  # virtualisation.docker.rootless = {
  #  enable = true;
  #  setSocketVariable = true;
  # };

  # systemd.user.services.docker = {
  #    enable = true;
  # };

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
   settings.PasswordAuthentication = false;
  };

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 22 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  networking.firewall.enable = true;

 
  system.stateVersion = "24.11";

}

