{ config, lib, pkgs, modulesPath, inputs, ... }: {
  imports = [
    "${toString modulesPath}/profiles/qemu-guest.nix"
  ];

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    autoResize = true;
    fsType = "ext4";
  };

  boot.kernelParams = ["console=ttyS0"];
  boot.loader.grub.device = lib.mkDefault "/dev/vda";

  system.build.qcow2 = import "${modulesPath}/../lib/make-disk-image.nix" {
    inherit lib config pkgs;
    diskSize = inputs.serverConfig.diskSize;
    format = "qcow2";
    partitionTableType = "hybrid";
  };
}
