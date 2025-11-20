{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks."*" = {
      serverAliveInterval = 60;
      identityAgent = "~/.1password/agent.sock";
    };
  };
}
