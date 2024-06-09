{
  description = "Home Manager configuration for Joshua Rubin";

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
          ./home.nix
          ./modules/files.nix
          ./modules/git.nix
          ./modules/packages.nix
          ./modules/programs.nix
          ./modules/x86_64-linux/packages.nix
          ./modules/x86_64-linux/services.nix
          ./modules/x86_64-linux/systemd.nix
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
          hostname = "jrubin";
          system = "x86_64-linux";
          gpgKey = "50116F3E17627303";
        };
      };

      "jrubin@vhagar" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.aarch64-darwin;

        modules = [
          ./home.nix
          ./modules/aarch64-darwin/files.nix
          ./modules/aarch64-darwin/packages.nix
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
          hostname = "vhagar";
          system = "aarch64-darwin";
          gpgKey = "71AA74EA6C4CA520";
        };
      };
    };
  };
}
