{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?rev=04f574a1c0fde90b51bf68198e2297ca4e7cccf4";
    flake-utils.url = "github:numtide/flake-utils?rev=5aed5285a952e0b949eb3ba02c12fa4fcfef535f";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages."${system}";
        hledger-prices = pkgs.buildGoModule {
          pname = "hledger-prices";
          version = "0.0.0";
          src = pkgs.lib.cleanSource ./.;
          vendorHash = "sha256-pQpattmS9VmO3ZIQUFn66az8GSmB4IvYhTTCFn6SUmo=";
        };
      in
      {
        packages.default = hledger-prices;
        apps.default = flake-utils.lib.mkApp {
          drv = hledger-prices;
        };
        devShell = pkgs.mkShell {
          buildInputs = [
            pkgs.go
            pkgs.gopls

            (pkgs.writeShellScriptBin "get-stock" ''
              ${pkgs.curl}/bin/curl "https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=$1&apikey=$ALPHA_VANTAGE_KEY"
            '')

            (pkgs.writeShellScriptBin "get-currency" ''
              ${pkgs.curl}/bin/curl "https://www.alphavantage.co/query?function=CURRENCY_EXCHANGE_RATE&from_currency=$1&to_currency=$2&apikey=$ALPHA_VANTAGE_KEY"
            '')

            (pkgs.writeShellScriptBin "search-stock" ''
              ${pkgs.curl}/bin/curl --get --data-urlencode "keywords=$1" "https://www.alphavantage.co/query?function=SYMBOL_SEARCH&apikey=$ALPHA_VANTAGE_KEY"
            '')
          ];
        };
      });
}
