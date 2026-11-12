{ ... }:

let
  resumeTargets = [
    "suspend.target"
    "hibernate.target"
    "hybrid-sleep.target"
    "suspend-then-hibernate.target"
  ];
in
{
  systemd.services.openrgb-stylix-resume = {
    description = "Reapply the Stylix OpenRGB color after resume";
    wantedBy = resumeTargets;
    after = resumeTargets ++ [ "openrgb.service" ];

    environment.HOME = "/home/teo";
    serviceConfig = {
      Type = "oneshot";
      User = "teo";
    };

    script = ''
      applyRgb=/etc/profiles/per-user/teo/bin/apply-stylix-rgb
      if [[ -x "$applyRgb" ]]; then
        "$applyRgb" || true
      fi
    '';
  };
}
