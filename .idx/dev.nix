# To learn more about how to use Nix to configure your environment
# see: https://developers.google.com/idx/guides/customize-idx-env
{ pkgs, ... }: {
  # Which nixpkgs channel to use.
  channel = "unstable"; # or "unstable"

  # Use https://search.nixos.org/packages to find packages
  packages = [
      pkgs.python3
      pkgs.python311Packages.pip
      pkgs.nodejs_23
      pkgs.nodePackages.nodemon
      pkgs.go
    #  pkgs.gh
    #  pkgs.git
  ];

  # Sets environment variables in the workspace
  env = {};
  idx = {
    # Search for the extensions you want on https://open-vsx.org/ and use "publisher.id"
    extensions = [ "ms-python.python" "rangav.vscode-thunder-client" ];
    # Enable previews
      previews = {
         web = {
        #   # Example: run "npm run dev" with PORT set to IDX's defined port for previews,
        #   # and show it in IDX's web preview panel
           command = ["npm" "run" "dev"];
           manager = "web";
           env = {
        #     # Environment variables to set for your server
             PORT = "$PORT";
           };
         };
      };

    # Workspace lifecycle hooks
    workspace = {
       onCreate = {
        create-venv = ''
          python -m venv venv
          source venv/bin/activate
          pip install -r requirements.txt
          npm ci --production
        '';
        # Open editors for the following files by default, if they exist:
        default.openFiles = [ "main.py" ];
      };
       onStart = {
        # Example: start a background task to watch and re-build backend code
         watch-backend = "npm run watch-backend";
      };

    };
  };
}