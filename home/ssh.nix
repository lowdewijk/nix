{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = {
      "*" = {
        ServerAliveInterval = 60;
        IdentityAgent = "~/.1password/agent.sock";
      };

      # required to make remote bbox viewer work
      "prod-needs-testing" = {
        User = "oddity";
      };
    };
  };
}
