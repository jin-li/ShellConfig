{
  description = "Shared shell configuration for jin-li's machines";

  outputs = self: {
    nixosModules.default = import ./nixos/module.nix ./.;
  };
}
