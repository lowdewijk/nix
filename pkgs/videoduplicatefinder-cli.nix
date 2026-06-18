{
  lib,
  stdenvNoCC,
  fetchurl,
  autoPatchelfHook,
  makeWrapper,
  ffmpeg,
  icu,
  zlib,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "videoduplicatefinder-cli";
  version = "4.0.x-2026-06-14";

  src = fetchurl {
    url = "https://github.com/0x90d/videoduplicatefinder/releases/download/4.0.x/CLI-linux-x64.tar.gz";
    hash = "sha256-cdhMEJ91ErD6tlFBhc8O3/AVLuSs4gpiwyYtqrianyw=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [zlib];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/bin" "$out/lib/${finalAttrs.pname}"
    cp -r outputCLI/. "$out/lib/${finalAttrs.pname}/"

    chmod +x "$out/lib/${finalAttrs.pname}/vdf-cli"

    makeWrapper "$out/lib/${finalAttrs.pname}/vdf-cli" "$out/bin/vdf-cli" \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [icu]} \
      --prefix PATH : ${lib.makeBinPath [ffmpeg]}

    runHook postInstall
  '';

  meta = {
    description = "Command-line duplicate finder for videos and images";
    homepage = "https://github.com/0x90d/videoduplicatefinder";
    license = lib.licenses.mit;
    platforms = ["x86_64-linux"];
    sourceProvenance = with lib.sourceTypes; [binaryNativeCode];
    mainProgram = "vdf-cli";
  };
})
