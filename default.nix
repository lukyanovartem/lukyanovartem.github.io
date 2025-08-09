{ pkgs ? import <nixpkgs> {} }:

let
  haskellPackages = pkgs.haskellPackages.extend (hself: hsuper: {
    hakyll-gallery = hsuper.callCabal2nix "hakyll-gallery" ((pkgs.fetchFromGitHub {
      owner = "lukyanovartem";
      repo = "web";
      rev = "f0a2a369d265f26c1b38c139c8cb54e6653e98ec";
      sha256 = "sha256-ChCp7RnVJRRjdR/u4O2s14RLrBD775fXRwFxLlVbARk=";
    }) + "/hakyll-gallery") {};
    site = hsuper.callCabal2nix "site" ./. {};
  });
in pkgs.mkShell {
  packages = [ haskellPackages.site ];
}
