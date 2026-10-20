# Repository Guide

## Structure

- This flake exposes one `x86_64-linux` host: `nixosConfigurations.nixos`.
- `flake.nix` loads `configuration.nix`; that file owns system services/packages and embeds Home Manager for user `teo` via `home-manager.users.teo = import ./home.nix`.
- There is no standalone `homeConfigurations` output. Do not use `home-manager switch --flake`; Home Manager changes are built and activated through the NixOS host.
- Put NixOS modules in `configuration.nix` imports and user-scoped modules in `home.nix` imports. Flake `inputs` reach both through `specialArgs` and `home-manager.extraSpecialArgs`.
- Stylix is enabled at the NixOS level in `modules/stylix.nix`. The Home Manager modules `noctalia-stylix.nix` and `openrgb-stylix.nix` consume its generated palette.

## Verify And Apply

- Fast evaluation: `nix flake check --no-build --no-write-lock-file`.
- Full system build without creating a `result` symlink: `nix build --no-link .#nixosConfigurations.nixos.config.system.build.toplevel`.
- Apply the host only when deployment is intended: `sudo nixos-rebuild switch --flake .#nixos`.
- Run evaluation before a full build, and build before switching. No separate tests, linter, formatter, CI, or task runner are configured.
- Keep `flake.lock` unchanged during routine validation; update it only when intentionally changing inputs.

## Machine-Specific Constraints

- `hardware-configuration.nix` is generated hardware state; do not hand-edit it. Hostname, username/home, filesystem UUIDs, NVIDIA PRIME bus IDs, and the `system.stateVersion`/`home.stateVersion` values are machine-specific.
- A switch runs Home Manager activation hooks that contact the live Noctalia session and OpenRGB hardware. Both hooks tolerate unavailable services with `|| true`; do not remove that behavior unless activation should fail when they are absent.
- When upgrading QIDI Studio in `modules/qidi-studio.nix`, update the package `version`, release URL, and fixed-output `hash` together. Its desktop entry also carries required certificate/WebKit environment overrides.
