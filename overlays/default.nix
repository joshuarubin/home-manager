{inputs, ...}: {
  additions = final: _prev: import ../pkgs final.pkgs;

  modifications = _final: _prev: {
    # openssl = prev.openssl.override {withZlib = true;};
  };

  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      inherit (final) system;
      # config.allowUnfree = true;
    };
  };
}
