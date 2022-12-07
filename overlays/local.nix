self: super: {
  infra = super.callPackage "${super.path}/pkgs/tools/admin/infra" {
    buildGoModule = old:
      super.buildGoModule (
        old
        // rec {
          version = "0.19.0";
          src = super.fetchFromGitHub {
            owner = "infrahq";
            repo = old.pname;
            rev = "v${version}";
            sha256 = "sha256-eQG+Vi5FfV64iEIYQ3Djd12TfdaLOVrfRxgN5ESJ4nA=";
          };
          vendorSha256 = "sha256-Xy8dAalj/NweZHEo2IpW+L+YzmBgYD+EU7ZKOhh3iIY=";
        }
      );
  };

  buf = super.buf.overrideAttrs (_old: rec {
    doCheck = false;
  });
}
