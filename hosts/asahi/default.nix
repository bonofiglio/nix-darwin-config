{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./apple-silicon-support
    ./desktop.nix
    ./flatpak.nix
  ];

  nix.enable = true;

  services.flatpak.enable = true;

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.code-new-roman
  ];

  # Bootloader
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.enable = true;

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true;
      KbdInteractiveAuthentication = false;
    };
  };

  networking = {
    networkmanager.enable = true;
    hostName = "asahi";

    nameservers = [
      "1.1.1.1"
      "1.0.0.1"
    ];

    firewall = {
      allowedTCPPorts = [ 22 ];
    };

    wireless.iwd = {
      enable = true;
      settings.General.EnableNetworkConfiguration = true;
    };
  };

  # Time and locale
  time.timeZone = "America/Montevideo";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "es_UY.UTF-8";
    LC_IDENTIFICATION = "es_UY.UTF-8";
    LC_MEASUREMENT = "es_UY.UTF-8";
    LC_MONETARY = "es_UY.UTF-8";
    LC_NAME = "es_UY.UTF-8";
    LC_PAPER = "es_UY.UTF-8";
    LC_TELEPHONE = "es_UY.UTF-8";
    LC_TIME = "es_UY.UTF-8";
  };

  security.sudo = {
    enable = true;
    wheelNeedsPassword = true;
    extraRules = [
      {
        commands = [
          {
            command = "${pkgs.smc-lid}/bin/smc-lid";
            options = [ "NOPASSWD" ];
          }
        ];
        groups = [ "wheel" ];
      }
    ];
  };

  # Define server account
  users.users.daniel = {
    isNormalUser = true;
    createHome = true;
    extraGroups = [
      "wheel" # Allow ‘sudo’ access
      "networkmanager"
    ];
  };
  users.groups.daniel = { };

  environment.sessionVariables.AQ_DRM_DEVICES = "/dev/dri/card0";
  environment.sessionVariables.WLR_DRM_DEVICES = "/dev/dri/card0";

  hardware.asahi.useExperimentalGPUDriver = true;
  hardware.asahi.experimentalGPUInstallMode = "replace";

  hardware.graphics.enable = true;
  hardware.bluetooth.enable = true;

  # packages
  environment.systemPackages = with pkgs; [
    xdg-desktop-portal-hyprland
    yazi
    smc-lid
  ];

  system.stateVersion = "25.11";

  # home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;
  home-manager.users.daniel = ./home;
}
