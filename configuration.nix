{
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./hardware.nix
  ];

  # --- Locale & time ---
  time.timeZone = "Asia/Kuala_Lumpur";

  i18n = {
    defaultLocale = "en_US.UTF-8";

    extraLocaleSettings = {
      LC_ADDRESS = "ms_MY.UTF-8";
      LC_IDENTIFICATION = "ms_MY.UTF-8";
      LC_MEASUREMENT = "ms_MY.UTF-8";
      LC_MONETARY = "ms_MY.UTF-8";
      LC_NAME = "ms_MY.UTF-8";
      LC_NUMERIC = "ms_MY.UTF-8";
      LC_PAPER = "ms_MY.UTF-8";
      LC_TELEPHONE = "ms_MY.UTF-8";
      LC_TIME = "ms_MY.UTF-8";
    };
  };

  # --- Boot ---
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;

    plymouth.enable = true;
    plymouth.theme = "bgrt";
  };

  # --- Networking ---
  networking = {
    hostName = "artemis";
    networkmanager.enable = true;
  };

  # --- Hardware & GPU ---
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    prime = {
      sync.enable = true;
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  # --- Nix & nixpkgs ---
  nixpkgs.config = {
    allowUnfree = true;
    nvidia.acceptLicense = true;
  };

  nix = {
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };

    nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
  };

  # --- Users ---
  users.users."muqri" = {
    isNormalUser = true;
    description = "Ahmad Muqri";
    shell = pkgs.zsh;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  # --- Programs & shell ---
  programs.zsh.enable = true;
  programs.tmux.enable = true;
  programs.git.enable = true;

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  programs.ssh.startAgent = true;
  programs.nix-ld.enable = true;

  # --- Services ---
  services.openssh.enable = true;

  # --- Desktop ---
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
  };

  programs.noctalia = {
    enable = true;
    recommendedServices.enable = true;
    systemd.enable = true;
  };

  services.displayManager.noctalia-greeter = {
    enable = true;

    settings = {
      cursor.theme = "capitaine-cursors";
      cursor.size = 32;
      cursor.path = "${pkgs.capitaine-cursors}/share/icons";
    };
  };

  # --- Fonts ---
  fonts = {
    fontDir.enable = true;

    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      adwaita-fonts
      google-fonts
    ];
  };

  # --- Packages ---
  environment.systemPackages = with pkgs; [
    # --- Core system utilities ---
    wget
    xdg-user-dirs
    wl-clipboard
    net-tools
    lsof
    zip
    vim

    # --- Theming & appearance ---
    adw-gtk3
    nwg-look
    papirus-icon-theme
    capitaine-cursors

    # --- GUI ---
    brave
    nautilus
    mission-center
    parsec-bin
    whatsapp-electron
    teams-for-linux
    proton-pass
    zed-editor

    # --- TUI ---
    opencode
    helix

    # --- Terminal & shell ---
    kitty
    starship
    zoxide
    fzf

    # --- Modern CLI utils ---
    bat
    eza
    fd
    ripgrep
    btop

    # --- Dev: language servers & formatters ---
    nixd
    nixfmt
    lua-language-server
    stylua

    # --- Dev: toolchains & tooling ---
    gcc
    gputils
    tree-sitter
    fnm
    devenv
    lazygit

    # --- Dotfile management ---
    stow
  ];

  system.stateVersion = "26.05";
}
