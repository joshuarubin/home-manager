{
  description = "Home Manager configuration of Joshua Rubin";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    inherit (self) outputs;

    systems = [
      "x86_64-linux"
      "aarch64-darwin"
    ];

    forAllSystems = nixpkgs.lib.genAttrs systems;
  in {
    packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});

    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

    overlays = import ./overlays {inherit inputs;};

    homeManagerModules = import ./modules/home-manager;

    homeConfigurations = {
      "jrubin@jrubin" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;

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
          inherit inputs outputs;
          sysConfig = {
            username = "jrubin";
            homeDirectory = "/home/jrubin";
            stateVersion = "23.05";
          };
          genericLinux = true;
        };
      };
    };
  };
}
