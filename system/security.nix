{globals, ...}: {
  security.sudo.extraRules = [
    {
      users = [globals.username];
      commands = [
        {
          command = "/run/current-system/sw/bin/nixos-rebuild switch --flake /home/lobo/nix";
          options = ["NOPASSWD"];
        }
        {
          command = "/run/current-system/sw/bin/nixos-rebuild boot --flake /home/lobo/nix";
          options = ["NOPASSWD"];
        }
      ];
    }
  ];
}
