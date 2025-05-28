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

  networking.hostName = "admin"; # Define your hostname.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.



  # Enable the X11 windowing system.
  services.xserver =  {
    enable = true;
    xkb.layout = "fr";
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };

  services.gnome.core-utilities.enable = false;
    
  # Enable sound.

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  services.libinput.enable = true;  
  nixpkgs.config.allowUnfree = true;
  
  users.users.operator = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
  };

  programs.firefox.enable = true;

  environment.systemPackages = with pkgs; [
    vim
    curl
    git
    kitty
    python3
    vscode
    xpipe
    btop

    (vscode-with-extensions.override {
       vscodeExtensions = with vscode-extensions; [
         bbenoist.nix 
         ms-azuretools.vscode-docker
         ms-python.python
         redhat.vscode-yaml
       ];
    })
  ];
 
  
  programs.zsh = {
    enable = true;
    ohMyZsh = {
      enable = true;
      plugins = [ "git" "python" "man" ];
      theme = "nicoulaj";
    };
  
  };
  
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };
  
  systemd.user.services.docker = {
    enable = true;
    unitConfig.ConditionUser = [ "operator" ];
  };

  system.stateVersion = "version"; # Did you read the comment?

}

