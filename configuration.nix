{ config, pkgs, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = false;
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda";
  boot.loader.systemd-boot.configurationLimit = 5;

  networking.hostName = "HTPC";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Vienna";

  i18n.defaultLocale = "de_AT.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_AT.UTF-8";
    LC_IDENTIFICATION = "de_AT.UTF-8";
    LC_MEASUREMENT = "de_AT.UTF-8";
    LC_MONETARY = "de_AT.UTF-8";
    LC_NAME = "de_AT.UTF-8";
    LC_NUMERIC = "de_AT.UTF-8";
    LC_PAPER = "de_AT.UTF-8";
    LC_TELEPHONE = "de_AT.UTF-8";
    LC_TIME = "de_AT.UTF-8";
  };

  nix.settings.auto-optimise-store = true;

  nix.gc.automatic = true;
  nix.gc.dates = "daily";
  nix.gc.options = "--delete-older-than 5d";

  services.xserver.xkb = {
    layout = "at";
    variant = "nodeadkeys";
  };

  services.xserver.enable = true;
  services.displayManager.autoLogin.user = "kodi";
  services.xserver.displayManager.lightdm.greeter.enable = false;

  services.xserver.desktopManager.kodi.enable = true;
  services.xserver.desktopManager.kodi.plugins = with pkgs.kodiPlugins; [
    youtube
    jellyfin
    netflix
    orftvthek
    sponsorblock
    steam-launcher
    bluetooth-manager
    libretro
  ];
  users.extraUsers.kodi = {
    isNormalUser = true;
    password = "kodi";
  };

  nixpkgs.config.allowUnfree = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  hardware.xone.enable = true;

  environment.systemPackages = with pkgs; [
      libcec
      git
      helix
      kodi
    ];

    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
      localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
    };

  system.stateVersion = "25.05";
}
