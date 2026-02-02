{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.huntarr;
in
{
  options = {
    services.huntarr = {
      enable = lib.mkEnableOption "Huntarr, a missing content and quality upgrade helper for *arr apps";

      package = lib.mkPackageOption pkgs "huntarr" { };

      dataDir = lib.mkOption {
        type = lib.types.str;
        default = "/var/lib/huntarr";
        description = "The directory where Huntarr stores its data files.";
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 9705;
        description = "The port Huntarr listens on (used for firewall configuration).";
      };

      openFirewall = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Open ports in the firewall for the Huntarr web interface.";
      };

      user = lib.mkOption {
        type = lib.types.str;
        default = "huntarr";
        description = "User account under which Huntarr runs.";
      };

      group = lib.mkOption {
        type = lib.types.str;
        default = "huntarr";
        description = "Group under which Huntarr runs.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.tmpfiles.settings."10-huntarr".${cfg.dataDir}.d = {
      inherit (cfg) user group;
      mode = "0700";
    };

    systemd.services.huntarr = {
      description = "Huntarr";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      environment = {
        HUNTARR_CONFIG_DIR = cfg.dataDir;
      };

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        ExecStart = "${cfg.package}/bin/huntarr";
        Restart = "on-failure";
      };
    };

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.port ];
    };

    users.users = lib.mkIf (cfg.user == "huntarr") {
      huntarr = {
        group = cfg.group;
        home = cfg.dataDir;
        uid = config.ids.uids.huntarr;
      };
    };

    users.groups = lib.mkIf (cfg.group == "huntarr") {
      huntarr.gid = config.ids.gids.huntarr;
    };
  };
}
