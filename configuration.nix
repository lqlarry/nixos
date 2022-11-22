# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.loader.systemd-boot.configurationLimit = 10;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.utf8";

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.windowManager.herbstluftwm.enable = true;
  services.xserver.windowManager.herbstluftwm.configFile = /home/larry/.config/herbstluftwm/autostart;
  services.xserver.windowManager.herbstluftwm.package = pkgs.herbstluftwm;
  services.xserver.displayManager.defaultSession = "none+herbstluftwm";

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Enable CUPS to print documents.
    services.printing.enable = true;
    services.printing.drivers = with pkgs; [ pkgs.epson-escpr ];
    services.system-config-printer.enable = true;
    services.avahi = { enable = true; nssmdns = true; };

  # Enable Pulseaudio & Bluetooth
    hardware.bluetooth.enable = true;
    hardware.bluetooth.package = pkgs.bluezFull;
    hardware.pulseaudio.extraConfig = "load-module module-combine-sink";
    services.blueman.enable = true;
    programs.dconf.enable = true;
    services.dbus.packages = with pkgs; [ blueman ];
    hardware.pulseaudio.package = pkgs.pulseaudioFull;

  # Enable mlocate to work (also add user to group)  
    services.locate = {
      enable = true;
      locate = pkgs.mlocate;
      interval = "hourly";
      localuser = null;
    };

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  # };

  # Enable touchpad support (enabled default in most desktopManager).
    services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.larry = {
    isNormalUser = true;
    description = "Larry Johnson";
    extraGroups = [ "networkmanager" "wheel" "audio" "video" "lp" "scanner" "mlocate" ];
    packages = with pkgs; [
      firefox
    #  thunderbird
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  neovim
  nodejs
  gnumake
  go
  networkmanagerapplet
  networkmanager-openvpn
  system-config-printer
  epson-escpr
  google-chrome
  sabnzbd
  calibre
  git
  picom
  polybar
  neofetch
  mpv
  mpd 
  ncmpcpp
  dunst
  wget
  kitty
  alacritty
  feh
  pcmanfm
  pavucontrol
  playerctl
  pamixer
  bluez
  blueman
  bluez-alsa
  pulseaudio-ctl
  arandr
  rofi
  tdesktop
  numlockx
  mlocate
  (let 
  my-python-packages = python-packages: with python-packages; [ 
    pillow
    requests
  ];
  python-with-my-packages = python3.withPackages my-python-packages;
  in
  python-with-my-packages)
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
  system.stateVersion = "22.05"; # Did you read the comment?

}
