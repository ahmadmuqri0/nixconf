{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix

    inputs.noctalia.nixosModules.default
    inputs.noctalia-greeter.nixosModules.default
  ];

  time.timeZone = "Asia/Kuala_Lumpur";

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
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

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.plymouth = {
    enable = true;
    theme = "bgrt";
  };

  networking.hostName = "artemis";
  networking.networkmanager.enable = true;

  users.users."muqri" = {
    isNormalUser = true;
    description = "Ahmad Muqri";
    shell = pkgs.zsh;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    wget
    xdg-user-dirs

    adw-gtk3
    nwg-look
    papirus-icon-theme
    capitaine-cursors
    wl-clipboard

    brave
    whatsapp-electron

    nil
    nixd
    lua-language-server
    stylua
    alejandra

    kitty
    starship
    lazygit
    ripgrep
    zoxide
    bat
    eza
    fzf
    vim
    fnm
    fd

    stow

    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
    inputs.noctalia-greeter.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    adwaita-fonts
  ];

  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };

  programs.noctalia = {
    enable = true;

    recommendedServices.enable = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [xdg-desktop-portal-hyprland];
  };

  programs.noctalia.systemd.enable = true;

  programs.noctalia-greeter = {
    enable = true;
    greeter-args = "";
  };

  services.openssh.enable = true;

  programs.ssh.startAgent = true;

  programs.zsh.enable = true;
  programs.tmux.enable = true;
  programs.git.enable = true;
  programs.neovim.enable = true;
  programs.thunar.enable = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nix.nixPath = ["nixpkgs=${inputs.nixpkgs}"];

  system.stateVersion = "26.05";
}
