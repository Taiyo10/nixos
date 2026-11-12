# Repository Guide

## Structure

- This flake exposes one `x86_64-linux` host: `nixosConfigurations.nixos`.
- `flake.nix` loads `configuration.nix`; that file owns system services/packages and embeds Home Manager for user `teo` via `home-manager.users.teo = import ./home.nix`.
- There is no standalone `homeConfigurations` output. Do not use `home-manager switch --flake`; Home Manager changes are built and activated through the NixOS host.
- Put NixOS modules in `configuration.nix` imports and user-scoped modules in `home.nix` imports. Flake `inputs` reach both through `specialArgs` and `home-manager.extraSpecialArgs`.
- System-scoped packages, services, boot, networking, graphics, and the Hyprland/UWSM login live in `configuration.nix`. User applications and helper commands live in `home.nix`.
- `modules/stylix.nix` enables the system theme and references `wallpapers/JapanNasa.png`. The Home Manager modules `noctalia-stylix.nix` and `openrgb-stylix.nix` consume its generated palette, so keep these modules on the Home Manager side.
- `modules/qidi-studio.nix` packages the upstream AppImage as a system package. The other files in `modules/` are local NixOS or Home Manager modules, not standalone flakes.

## Important Components

- The desktop starts Hyprland through UWSM from greetd. NVIDIA PRIME offload is configured against the integrated AMD GPU, and the PCI bus IDs are host-specific.
- Noctalia provides the shell and recommended services. Stylix writes its palette to `~/.config/noctalia/palettes/Stylix.json`, then reloads the live shell and updates its wallpaper during Home Manager activation.
- OpenRGB runs as a system service. Home Manager builds `apply-stylix-rgb` and invokes it during activation to set the hardware color from Stylix `base0D`.
- `home.nix` overrides `pkgs.codex` with extra native libraries and injects that package into T3 Code. Preserve that relationship when changing either package.
- `record-region` is a generated shell application bound to the GPU screen recorder stack. It stores runtime state under `$XDG_RUNTIME_DIR`, writes recordings to `~/Videos`, and uses `SIGINT` to stop an active recording.
- `rebuild` is an intentionally stateful convenience command: it switches `~/.nixos`, stages every repository change, commits it with a timestamp, and pushes the current branch. Do not invoke it for validation or while unrelated changes are present.

## Verify And Apply

- Fast evaluation: `nix flake check --no-build --no-write-lock-file`.
- Full system build without creating a `result` symlink: `nix build --no-link .#nixosConfigurations.nixos.config.system.build.toplevel`.
- Apply the host only when deployment is intended: `sudo nixos-rebuild switch --flake .#nixos`.
- Run evaluation before a full build, and build before switching. No separate tests, linter, formatter, CI, or task runner are configured.
- Keep `flake.lock` unchanged during routine validation; update it only when intentionally changing inputs.
- Validation may require access to the Nix daemon and configured substituters. If a restricted environment cannot reach them, report that limitation rather than treating it as a configuration failure.

## Machine-Specific Constraints

- `hardware-configuration.nix` is generated hardware state; do not hand-edit it. Hostname, username/home, filesystem UUIDs, NVIDIA PRIME bus IDs, and the `system.stateVersion`/`home.stateVersion` values are machine-specific.
- `hardware-configuration.nix.backup` is a historical copy, not an imported module. `result.json` is slicer output and does not participate in the flake. Do not update either as part of configuration work unless explicitly requested.
- A switch runs Home Manager activation hooks that contact the live Noctalia session and OpenRGB hardware. Both hooks tolerate unavailable services with `|| true`; do not remove that behavior unless activation should fail when they are absent.
- When upgrading QIDI Studio in `modules/qidi-studio.nix`, update the package `version`, release URL, and fixed-output `hash` together. Its desktop entry also carries required certificate/WebKit environment overrides.
- Preserve `home-manager.useGlobalPkgs = true` when adding user packages: Home Manager intentionally shares the NixOS package set and its unfree-package policy.
