{pkgs}: let
  mkOpSecretWrapper = import ../lib/mk-op-secret-wrapper.nix {inherit pkgs;};
  secretRef = "op://Personal/OpenAI/terminal-api-key";
in {
  codex = mkOpSecretWrapper {
    name = "codex";
    package = pkgs.llm-agents.codex;
    inherit secretRef;
    envVars = ["OPENAI_API_KEY" "CODEX_API_KEY"];
  };

  codex-acp = mkOpSecretWrapper {
    name = "codex-acp";
    package = pkgs.llm-agents.codex-acp;
    inherit secretRef;
    envVars = ["OPENAI_API_KEY" "CODEX_API_KEY"];
  };
}
