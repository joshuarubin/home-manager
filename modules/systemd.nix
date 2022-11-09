{
  pkgs,
  sysConfig,
  ...
}: {
  systemd.user.services = {
    ## TODO(jawa) only run on certain machines
    k3s = {
      Unit = {
        Description = "Run k3s";
        After = "network-online.target";
      };

      Service = {
        Environment = "PATH=${sysConfig.homeDirectory}/.nix-profile/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin";
        ExecStart = ''
          /bin/sh -c 'exec ${pkgs.k3s}/bin/k3s server \
            --rootless \
            --snapshotter=fuse-overlayfs \
            --write-kubeconfig="''${HOME}/.config/k3s/kubeconfig.yaml" \
            --data-dir="''${HOME}/.local/share/k3s" \
            --write-kubeconfig-mode =644 \
            --cluster-cidr="172.20.0.0/16" \
            --service-cidr="172.21.0.0/16" \
            --node-external-ip="$(ip -j -f inet addr show scope global up | jq -r \'map(select(.operstate == "UP"))[0].addr_info[0].local\')" \
            --disable=traefik \
            --disable=metrics-server'
        '';
        ExecReload = "kill -s HUP $MAINPID";
        TimeoutSec = 0;
        RestartSec = 2;
        Restart = "always";
        StartLimitBurst = 3;
        StartLimitInterval = "60s";
        LimitNOFILE = "infinity";
        LimitNPROC = "infinity";
        LimitCORE = "infinity";
        TasksMax = "infinity";
        Delegate = "yes";
        Type = "simple";
        KillMode = "mixed";
      };

      Install = {
        WantedBy = ["multi-user.target"];
      };
    };
  };
}
