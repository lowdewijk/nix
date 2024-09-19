{
  programs.ssh = {
    enable = true;

    # Keep SSH sessions alive by sending, every minute, a keep-alive signal to hosts
    serverAliveInterval = 60;

    # Use the 1Password SSH agent for all hosts
    extraConfig = ''
      Include $HOME/.config/extra_ssh/extra_ssh_config.secret

      Host *
          IdentityAgent ~/.1password/agent.sock
    '' + (builtins.readFile ./extra_ssh_config.secret);
  };
}
