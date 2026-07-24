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

      "lightsail" = {
        HostName = "63.183.203.92";
        User = "ec2-user";
      };
    };
  };
}
