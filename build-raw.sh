#!/bin/sh
nix build .#nixosConfigurations.image-builder.config.system.build.raw
