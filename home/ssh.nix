{
  programs.ssh = {
    enable = true;

    matchBlocks."*" = {
      serverAliveInterval = 60;
      identityAgent = "~/.1password/agent.sock";
    };
  };
}
