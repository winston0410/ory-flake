{
  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      nixosModule = { pkgs, config, ... }: {
        virtualisation.oci-containers.containers."ory-kratos" = let
        in {
          image = "oryd/kratos:latest";
          volumes = [

          ];
        };
      };
    in {
      devShell.${system} = (({ pkgs, ... }:
        pkgs.mkShell {
          buildInputs = with pkgs;
            [
                docker-compose
            ];

          shellHook = ''
            source ./.env
          '';
        }) { inherit pkgs; });
      inherit nixosModule;
      nixosModules = { default = nixosModule; };
      defaultPackage.x86_64-linux = let
        # kratosConfig = pkgs.writeText "kratos.yml" (builtins.readFile ./kratos.yml);
        kratosConfig = pkgs.stdenv.mkDerivation {
          name = "krato-config";
          src = ./kratos.yml;
        };
      in pkgs.dockerTools.buildImage {
        name = "oryd-kratos";
        tag = "latest";
        fromImage = pkgs.dockerTools.pullImage {
          imageName = "oryd/kratos";
          imageDigest =
            "sha256:11a8241b380830bf2254a8563a5f84fb4bbee9f40e869ff3a17bba3b4ac835a4";
          sha256 = pkgs.lib.fakeSha256;
        };

        contents = [ kratosConfig ];

        config = { Cmd = [ "ls -a" "echo hello" ]; };
      };
    };
}
