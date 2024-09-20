{ config, lib, pkgs, ... }:

{
  # Install 1Password CLI
  programs._1password.enable = true;
  
  # Install and configure 1Password GUI
  programs._1password-gui = {
    enable = true;
    # Certain features, including CLI integration and system authentication support, require enabling PolKit integration
    polkitPolicyOwners = [ "lobo" ];
  };

}
