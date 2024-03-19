{
  description = "Home Manager configuration of Joshua Rubin";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    home-manager,
    ...
  }: let
    system = "x86_64-linux"; # TODO(jawa)
    pkgs = import nixpkgs {
      inherit system;
      overlays = [
        (import ./overlays/local.nix)
      ];
      config.allowUnfreePredicate = pkg:
        builtins.elem (pkgs.lib.getName pkg) [
          "infra"
          "terraform"
          "vault"
        ];
    };
  in {
    homeConfigurations.jrubin = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;

      modules = [
        ./modules/files.nix
        ./modules/git.nix
        ./modules/home.nix
        ./modules/packages.nix
        ./modules/programs.nix
        ./modules/services.nix
        ./modules/systemd.nix
        ./modules/zsh.nix
      ];

      extraSpecialArgs = {
        sysConfig = {
          username = "jrubin";
          homeDirectory = "/home/jrubin";
          stateVersion = "23.05";
        };
      };
    };
  };
}
