{
  description = "Home Manager configuration for Joshua Rubin";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-24.11";
    home-manager = {
      url = "github:nix-community/home-manager//release-24.11";
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
      "jrubin@vermithor" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.aarch64-darwin;

        modules = [
          ./home.nix
          ./modules/aarch64-darwin/files.nix
          ./modules/aarch64-darwin/packages.nix
          ./modules/aarch64-darwin/launchd.nix
          ./modules/files.nix
          ./modules/git.nix
          ./modules/packages.nix
          ./modules/programs.nix
          ./modules/zsh.nix
        ];

        extraSpecialArgs = {
          inherit inputs outputs;
          sysConfig = {
            username = "jrubin";
            homeDirectory = "/Users/jrubin";
            stateVersion = "23.05";
          };
          genericLinux = false;
          hostname = "vermithor";
          system = "aarch64-darwin";
          gpgKey = "71AA74EA6C4CA520";
        };
      };

      "jrubin@tessarion" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.aarch64-darwin;

        modules = [
          ./home.nix
          ./modules/aarch64-darwin/files.nix
          ./modules/aarch64-darwin/packages.nix
          ./modules/aarch64-darwin/launchd.nix
          ./modules/files.nix
          ./modules/git.nix
          ./modules/packages.nix
          ./modules/programs.nix
          ./modules/zsh.nix
        ];

        extraSpecialArgs = {
          inherit inputs outputs;
          sysConfig = {
            username = "jrubin";
            homeDirectory = "/Users/jrubin";
            stateVersion = "23.05";
          };
          genericLinux = false;
          hostname = "tessarion";
          system = "aarch64-darwin";
          gpgKey = "71AA74EA6C4CA520";
        };
      };
    };
  };
}
