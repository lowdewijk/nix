{pkgs}:
{
  name,
  package,
  secretRef,
  envVars,
  binaryName ? name,
}: let
  inherit (pkgs) lib;
  opBin = lib.getExe pkgs._1password-cli;
  targetBin = lib.getExe' package binaryName;
  exportLines = lib.concatMapStringsSep "\n" (envVar: ''
    if [ -z "''${${envVar}:-}" ]; then
      export ${envVar}="$secret_value"
    fi
  '') envVars;
in
  pkgs.writeShellScriptBin name ''
    if [ -z "''${__OP_SECRET_WRAPPER_ATTEMPTED:-}" ] && [ -x "${opBin}" ]; then
      export __OP_SECRET_WRAPPER_ATTEMPTED=1
      secret_value="$(${opBin} read '${secretRef}' 2>/dev/null || true)"
      if [ -n "$secret_value" ]; then
        ${exportLines}
      fi
      unset secret_value
    fi

    exec ${targetBin} "$@"
  ''
