{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks."*" = {
      serverAliveInterval = 60;
      identityAgent = "~/.1password/agent.sock";
    };

    # required to make remote bbox viewer work
    matchBlocks."prod-needs-testing" = {
      user = "oddity";
    };
  };
}
