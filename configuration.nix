{ config, lib, pkgs, modulesPath, inputs, ... }: {

  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    (modulesPath + "/profiles/minimal.nix")
    ./git.nix
  ];

  fileSystems."/" = {
    label = "nixos";
    autoResize = true;
    fsType = "ext4";
  };
  # fileSystems."/boot" = {
  #   label = "ESP";
  #   fsType = "vfat";
  #   options = [ "fmask=0077" "dmask=0077" ];
  # };
  boot.loader.grub.device = "/dev/sda";

  networking.hostName = inputs.serverConfig.hostname;

  users.users = inputs.serverConfig.users;

  # Auto upgrades
  system.autoUpgrade = {
    enable = true;
    flake = inputs.serverConfig.repository;
    dates = "3:00";
    allowReboot = true;
  };
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Automatic garbage collection & optimisation
  nix.gc.automatic = true;
  nix.gc.dates = "03:30"; # Optional; allows customizing optimisation schedule

  nix.optimise.automatic = true;
  nix.optimise.dates = [ "04:00" ]; # Optional; allows customizing optimisation schedule

  environment.systemPackages = with pkgs; [
    vim
    tmux
  ];

  services.openssh = {
    enable = true;
    ports = inputs.serverConfig.sshPorts;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
      # AllowUsers = inputs.serverConfig.sshUsers;
    };
  };
  services.fail2ban.enable = true;
  services.fail2ban.maxretry = 6;
  services.fail2ban.bantime = "20m";

  system.stateVersion = "25.05";
}
