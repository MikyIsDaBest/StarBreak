{
  description = "StarBreak - Network and Security Suite";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      pkgsFor = system: nixpkgs.legacyPackages.${system};
    in
    {
      packages = forAllSystems (system:
        let
          pkgs = pkgsFor system;
          pythonEnv = pkgs.python3.withPackages (ps: with ps; [
            requests
            scapy
            aiohttp
            fake-useragent
            pillow
          ]);
        in
        {
          default = pkgs.writeShellApplication {
            name = "starbreak";
            runtimeInputs = with pkgs; [
              bash
              coreutils
              curl
              gcc
              pythonEnv
              nmap
              dnsutils
            ];
            text = ''
              if [ -f "./Launcher.sh" ]; then
                exec ./Launcher.sh "$@"
              else
                cd "${./.}" && exec ./Launcher.sh "$@"
              fi
            '';
          };
        }
      );

      apps = forAllSystems (system: {
        default = {
          type = "app";
          program = "${self.packages.${system}.default}/bin/starbreak";
        };
      });

      devShells = forAllSystems (system:
        let
          pkgs = pkgsFor system;
          pythonEnv = pkgs.python3.withPackages (ps: with ps; [
            requests
            scapy
            aiohttp
            fake-useragent
            pillow
          ]);
        in
        {
          default = pkgs.mkShell {
            packages = with pkgs; [
              bash
              coreutils
              curl
              gcc
              pythonEnv
              nmap
              dnsutils
            ];
          };
        }
      );
    };
}
