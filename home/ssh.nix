{
  programs.ssh = {
    enable = true;

    # Keep SSH sessions alive by sending, every minute, a keep-alive signal to hosts
    serverAliveInterval = 60;

    # Use the 1Password SSH agent for all hosts
    extraConfig = ''
      Host *
          IdentityAgent ~/.1password/agent.sock
    '' + 
      # automatically populated by nixos-rebuild.sh using 1assword-cli
      (builtins.readFile ./secret/extra_ssh_config.secret);
  };
}
