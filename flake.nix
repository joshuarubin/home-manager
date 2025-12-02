{
  description = "Home Manager configuration for Joshua Rubin";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur = {
      url = "github:nix-community/nur";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    nur,
    ...
  } @ inputs: let
    inherit (self) outputs;

    systems = [
      "x86_64-linux"
      "aarch64-darwin"
    ];

    forAllSystems = nixpkgs.lib.genAttrs systems;

    # Centralized list of allowed unfree packages
    allowedUnfreePackages = [
      "1password-cli"
      "amp-cli"
      "crush"
      "torch"
    ];

    # Import unstable with config for specific unfree packages
    # This is slightly slower than legacyPackages but necessary for unfree support
    mkUnstableWithConfig = system:
      import nixpkgs-unstable {
        inherit system;
        config.allowUnfreePredicate = pkg:
          builtins.elem (nixpkgs.lib.getName pkg) allowedUnfreePackages;
      };
  in {
    packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});

    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

    overlays = import ./overlays {inherit inputs;};

    homeManagerModules = import ./modules/home-manager;

    homeConfigurations = {
      "jrubin@vermithor" = let
        system = "aarch64-darwin";
        nurpkgs = nur.legacyPackages.${system};
      in
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};

          modules = [
            ./home.nix
            ./modules/${system}/files.nix
            ./modules/${system}/packages.nix
            ./modules/${system}/launchd.nix
            ./modules/files.nix
            ./modules/git.nix
            ./modules/packages.nix
            ./modules/programs.nix
            ./modules/zsh.nix
            nurpkgs.repos.charmbracelet.modules.homeManager.crush
          ];

          extraSpecialArgs = {
            inherit inputs outputs nur allowedUnfreePackages;
            unstable = mkUnstableWithConfig system;
            sysConfig = {
              username = "jrubin";
              homeDirectory = "/Users/jrubin";
              stateVersion = "23.05";
            };
            genericLinux = false;
            hostname = "vermithor";
            gpgKey = "71AA74EA6C4CA520";
          };
        };

      "jrubin@tessarion" = let
        system = "aarch64-darwin";
        nurpkgs = nur.legacyPackages.${system};
      in
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};

          modules = [
            ./home.nix
            ./modules/${system}/files.nix
            ./modules/${system}/packages.nix
            ./modules/${system}/launchd.nix
            ./modules/files.nix
            ./modules/git.nix
            ./modules/packages.nix
            ./modules/programs.nix
            ./modules/zsh.nix
            nurpkgs.repos.charmbracelet.modules.homeManager.crush
          ];

          extraSpecialArgs = {
            inherit inputs outputs nur allowedUnfreePackages;
            unstable = mkUnstableWithConfig system;
            sysConfig = {
              username = "jrubin";
              homeDirectory = "/Users/jrubin";
              stateVersion = "23.05";
            };
            genericLinux = false;
            hostname = "tessarion";
            gpgKey = "71AA74EA6C4CA520";
          };
        };
    };
  };
}
