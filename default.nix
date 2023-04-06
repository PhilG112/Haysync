let
    pkgs = import <nixpkgs> {};
in
{
    haysync = pkgs.haskellPackages.callPackage ./haysync.nix {};
}
