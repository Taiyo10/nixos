{ config, pkgs, inputs, ... }:

let
  fixedCodex = pkgs.codex.overrideAttrs (old: {
    buildInputs = old.buildInputs ++ (with pkgs; [
      aws-lc
      oniguruma
      sqlite
      zstd
    ]);
  });

  t3codeWithFixedCodex = pkgs.t3code.override {
    codex = fixedCodex;
  };

  recordRegion = pkgs.writeShellApplication {
    name = "record-region";
    runtimeInputs = with pkgs; [
      coreutils
      gpu-screen-recorder
      libnotify
      slurp
    ];
    text = ''
      runtime_dir="''${XDG_RUNTIME_DIR:-/tmp}/region-recorder-$UID"
      pid_file="$runtime_dir/pid"
      output_file="$runtime_dir/output"
      log_file="$runtime_dir/recorder.log"
      mkdir -p "$runtime_dir"

      if [[ -f "$pid_file" ]]; then
        read -r recorder_pid < "$pid_file"
        if [[ "$recorder_pid" =~ ^[0-9]+$ ]] && kill -0 "$recorder_pid" 2>/dev/null; then
          kill -INT "$recorder_pid"
          notify-send -a "Screen Recorder" "Stopping recording..."
          exit 0
        fi
        rm -f "$pid_file" "$output_file"
      fi

      region=$(slurp -f '%wx%h+%x+%y') || exit 0
      videos_dir="$HOME/Videos"
      mkdir -p "$videos_dir"
      recording="$videos_dir/Recording_$(date '+%Y-%m-%d_%H-%M-%S').mp4"

      gpu-screen-recorder \
        -w region \
        -region "$region" \
        -f 60 \
        -a default_output \
        -ac aac \
        -k h264 \
        -q very_high \
        -c mp4 \
        -o "$recording" > "$log_file" 2>&1 &
      recorder_pid=$!
      printf '%s\n' "$recorder_pid" > "$pid_file"
      printf '%s\n' "$recording" > "$output_file"
      notify-send -a "Screen Recorder" "Recording selected region" "Press Shift+Print to stop"

      recorder_status=0
      wait "$recorder_pid" || recorder_status=$?
      rm -f "$pid_file" "$output_file"

      if [[ "$recorder_status" -eq 0 && -s "$recording" ]]; then
        notify-send -a "Screen Recorder" "Recording saved" "$recording"
      else
        notify-send -u critical -a "Screen Recorder" "Recording failed" "See $log_file"
      fi
    '';
  };

  rebuild = pkgs.writeShellApplication {
    name = "rebuild";
    runtimeInputs = with pkgs; [
      coreutils
      git
      nixos-rebuild
      openssh
    ];
    text = ''
      config_dir="$HOME/.nixos"

      sudo nixos-rebuild switch --flake "$config_dir#nixos"

      git -C "$config_dir" add -A
      if git -C "$config_dir" diff --cached --quiet; then
        printf 'No Git changes to commit.\n'
        exit 0
      fi

      git -C "$config_dir" commit -m "NixOS rebuild $(date '+%Y-%m-%d %H:%M')"
      git -C "$config_dir" push
    '';
  };
in
{
  imports = [
    ./modules/noctalia-stylix.nix
    inputs.zen-browser.homeModules.default
    ./modules/openrgb-stylix.nix
  ];

  home.username = "teo";
  home.homeDirectory = "/home/teo";

  home.stateVersion = "26.05";

  programs.home-manager.enable = true;

  programs.vesktop = {
    enable = true;
  };

  home.packages = with pkgs; [
    prismlauncher
    obsidian
    thunar
    t3codeWithFixedCodex
    fixedCodex
    opencode
    vscode
    recordRegion
    rebuild
  ];

  programs.kitty.enable = true;

  programs.zen-browser = {
    enable = true;
  };

  stylix.targets.zen-browser = {
    enable = true;
    profileNames = ["default"];
  };
}
