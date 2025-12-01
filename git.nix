{ config, lib, pkgs, inputs, ... }: {
  services.gitolite = {
    enable = true;
    user = "git";
    group = "git";
    adminPubkey = inputs.serverConfig.gitoliteAdminPubkey;
    dataDir = "/var/lib/gitolite";
  };

  # # webview
  # services.cgit."${inputs.serverConfig.hostname}" = {
  #   enable = true;
  #   user = "cgit";
  #   group = "git";
  #   settings = {
  #     project-list = "/var/lib/gitolite/projects.list";
  #   };
  #   scanPath = "/var/lib/gitolite/repositories";
  # };
  # users.users.nginx.extraGroups = ["git"];

  # # configure permissions for cgit to have access to gitolite
  # systemd.services.set-gitolite-permissions = {
  #   description = "Set permissions for gitolite so cgit can view them";
  #   wantedBy = [ "gitolite-init.service" ];
  #   # serviceConfig = {
  #   #   Type = "oneshot";
  #   # };
  #   script = "chmod -R g+r /var/lib/gitolite/repositories /var/lib/gitolite/projects.list";
  # };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 80 443 ];
  };
  #services.openssh.settings.AllowUsers = [ "git" ];

}
