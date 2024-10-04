{pkgs, ...}: {
  home.file.".config/aichat/config.yaml".text = ''
    model: openai:gpt-4o
    clients:
    - type: openai
      api_key: null # run aichat with `op run -- aichat`
  '';
}
