{
  pkgs,
  sysConfig,
  ...
}
: {
  systemd.user = {
    startServices = "sd-switch";
    services = {
      et = {
        Unit = {
          Description = "Eternal Terminal";
          After = ["syslog.target" "network.target"];
        };

        Service = {
          Type = "simple";
          Restart = "on-failure";
          ExecStart = "${pkgs.eternal-terminal}/bin/etserver --cfgfile=${sysConfig.homeDirectory}/.config/et/et.cfg";
        };

        Install = {
          WantedBy = ["default.target"];
        };
      };
    };
  };

  xdg.configFile."et/et.cfg".source = ../../files/config/et.cfg;
}
